Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbaCDOug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:50:36 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:54871 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100AbaCDOue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:50:34 -0500
MIME-Version: 1.0
In-Reply-To: <20140304143111.GA4074@yogesh-Dell-System-XPS-L502X>
References: <20140304114814.GA28031@yogesh-Dell-System-XPS-L502X>
	<CAAsK9AF-jbJZHOT+4gY0QmZFMhj84_DuSD9jDgddDH03vodcYw@mail.gmail.com>
	<20140304143111.GA4074@yogesh-Dell-System-XPS-L502X>
Date: Tue, 4 Mar 2014 15:50:33 +0100
X-Google-Sender-Auth: MJyuQx0VxV6NLJd4UxqXsXrPOIU
Message-ID: <CAAsK9AHyrx1aTDZ8e_YU=vhqK5qa__HDN=yqanApE4=mgNe0-w@mail.gmail.com>
Subject: Re: [PATCH 1/1] Add documentation for proper usage and order of
 preference of calls to print diagnostic messages.
From: Levente Kurusa <levex@linux.com>
To: yogesh <mr.yogesh@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[+CC Rob]

2014-03-04 15:31 GMT+01:00 yogesh <mr.yogesh@gmail.com>:
> This patch adds documentation that clarifies the use of various
> diagnostic printing messages. It shows the preference of subsystem_dbg
> calls to dev_dbg (whenever possible), as they first preferred format of
> logging debug messages.
> Signed-off-by: Yogesh Chaudhari <mr.yogesh@gmail.com>

Acked-by: Levente Kurusa <levex@linux.com>

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
>
> Regards
> Yogesh
> [...]

A lot better, but please next time send it as a separate mail
with subject [PATCH v2] or something like that. Thanks!

--
Regards,
Levente Kurusa
