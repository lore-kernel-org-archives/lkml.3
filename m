Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaCDQ2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:28:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47395 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaCDQ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:28:05 -0500
Message-ID: <5315FF0F.9000207@infradead.org>
Date: Tue, 04 Mar 2014 08:27:59 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: yogesh <mr.yogesh@gmail.com>, Levente Kurusa <levex@linux.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/1] Add documentation for proper usage and order of preference
 of calls to print diagnostic messages.
References: <20140304114814.GA28031@yogesh-Dell-System-XPS-L502X> <CAAsK9AF-jbJZHOT+4gY0QmZFMhj84_DuSD9jDgddDH03vodcYw@mail.gmail.com> <20140304143111.GA4074@yogesh-Dell-System-XPS-L502X>
In-Reply-To: <20140304143111.GA4074@yogesh-Dell-System-XPS-L502X>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 06:31 AM, yogesh wrote:
> This patch adds documentation that clarifies the use of various
> diagnostic printing messages. It shows the preference of subsystem_dbg
> calls to dev_dbg (whenever possible), as they first preferred format of
> logging debug messages.
> Signed-off-by: Yogesh Chaudhari <mr.yogesh@gmail.com>
> ---
>  Documentation/CodingStyle | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 7fe0546..083f738 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -662,6 +662,23 @@ and driver, and are tagged with the right level:  dev_err(), dev_warn(),
>  dev_info(), and so forth.  For messages that aren't associated with a
>  particular device, <linux/printk.h> defines pr_debug() and pr_info().
>  
> +If the subsystem has its own diagnostic macros then they should be used
> +instead of dev_dbg calls.
> +e.g. If you are using network subsystem, use netdev_dbg;

   E.g., if you are

> +if you are using V4L, use v4l_dbg etc.
> +This standardises the output format in every subsystem.
> +
> +Depending on your changes, the following order of precedence
> +applies to printing messages:
> +1. [subsystem]_dbg() is preferred when the subsystem has its own
> +diagnostic macros.
> +2. dev_dbg() is preferred when you have a generic struct device object.
> +3. pr_debug() should be used when 1 and 2 above are not applicable.
> +4. printk() should be avoided.
> +
> +Note: The above order applies to diagnostic calls of all log levels viz:
> +*_emerg, *_alert, *_crit, *_err, *_warn, *_notice, *_info and *_dbg.
> +
>  Coming up with good debugging messages can be quite a challenge; and once
>  you have them, they can be a huge help for remote troubleshooting.  Such
>  messages should be compiled out when the DEBUG symbol is not defined (that
> --


-- 
~Randy
