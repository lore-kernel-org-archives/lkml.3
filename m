Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbaCDNjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:39:45 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:58024 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081AbaCDNjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:39:43 -0500
MIME-Version: 1.0
In-Reply-To: <20140304114814.GA28031@yogesh-Dell-System-XPS-L502X>
References: <20140304114814.GA28031@yogesh-Dell-System-XPS-L502X>
Date: Tue, 4 Mar 2014 14:39:42 +0100
X-Google-Sender-Auth: AeK7HIfsGoAIJ7zILlVe-Iundmo
Message-ID: <CAAsK9AF-jbJZHOT+4gY0QmZFMhj84_DuSD9jDgddDH03vodcYw@mail.gmail.com>
Subject: Re: [PATCH 1/1] Add documentation for proper usage and order of
 preference of calls to print diagnostic messages.
From: Levente Kurusa <levex@linux.com>
To: yogesh <mr.yogesh@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-03-04 12:48 GMT+01:00 yogesh <mr.yogesh@gmail.com>:
> This patch adds documentation that clarifies the use of various diagnostic printing messages. It shows the preference of subsystem_dbg calls to dev_dbg (whenever possible), as the first preferred format of logging debug messages.

Please wrap your changelog at 80 characters a line.

> Signed-off-by: Yogesh Chaudhari <mr.yogesh@gmail.com>
> ---
>  Documentation/CodingStyle | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 7fe0546..9e0de25 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -662,6 +662,20 @@ and driver, and are tagged with the right level:  dev_err(), dev_warn(),
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
> +1. [subsystem]_dbg() is preferred when you the

The 'you' is unnecessary and incorrect.

> +subsystem has its own diagnostic macros.
> +2. dev_dbg() is preferred when you have a generic struct device object.
> +3. pr_debug() is used when 1 and 2 above are not applicable.

I think it's better to say "should be used".

> +4. printk() should be avoided.
> +
>  Coming up with good debugging messages can be quite a challenge; and once
>  you have them, they can be a huge help for remote troubleshooting.  Such
>  messages should be compiled out when the DEBUG symbol is not defined (that

I think we should also mention *_warn, *_err etc not just *_dbg.

--
Regards,
Levente Kurusa
