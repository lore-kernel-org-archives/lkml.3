Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967513Ab3E3FfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 01:35:10 -0400
Received: from ozlabs.org ([203.10.76.45]:34213 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967423Ab3E3Fec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 01:34:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: What is listed in /sys/module?
In-Reply-To: <20130529102735.3ce72ecc@endymion.delvare>
References: <20130529102735.3ce72ecc@endymion.delvare>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 30 May 2013 10:24:31 +0930
Message-ID: <878v2xmgmw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare <khali@linux-fr.org> writes:
> Hi Greg, Rusty,
>
> I have a question related to /sys/module and can't seem to find the
> answer by myself so I hope you can explain.
>
> I noticed that /sys/module contains more than /proc/modules. At first I
> thought that any potentially modular piece of code would show up
> in /sys/module, so /sys/module would include both actual modules and
> "built-in modules".
>
> However I then noticed that some built-in modules do _not_ show up
> in /sys/module. For example, I have USB and I2C core support built into
> my 3.9.4 kernel, /sys/module/usbcore exists but /sys/module/i2c_core
> does not. CONFIG_SENSORS_W83795=y did not give me /sys/module/w83795
> either.

Yes.  /sys/module entries are created for builtin "modules" with
parameters.  This is because, the module names are discovered by
scouring the parameters: see param_sysfs_builtin().

Two things to note about builtin modules:

1) There is nothing other than parameters in /sys/module/, except a
   uevent which is used for managing the parameters.  So, without
   parameters, it would be an empty directory.

2) We actually do generate a list of builtin modules these days, called
   modules.builtin.  So we could generate sysfs dirs from this.

If you want to make it consistent, I look forward to your patch!

Cheers,
Rusty.
