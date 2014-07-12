Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaGLAnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 20:43:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaGLAnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 20:43:11 -0400
Date: Fri, 11 Jul 2014 17:47:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: kgdb_nmi: Convert kgdb_nmi_tty_enabled into a
 module parameter
Message-ID: <20140712004739.GA13893@kroah.com>
References: <1405081811-15254-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405081811-15254-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 01:30:11PM +0100, Daniel Thompson wrote:
> At present it is not possible to boot with the ttyNMI0 console treating
> character input normally. To use the console requires that kdb be
> entered and the nmi_console command be used to enable the console (or if
> only kgdb is present then gdb must directly manipulate the value of
> kgdb_nmi_tty_enabled).
> 
> Introducing a module parameter makes the console much more usable.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: linux-serial@vger.kernel.org
> ---
>  drivers/tty/serial/kgdb_nmi.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/tty/serial/kgdb_nmi.c b/drivers/tty/serial/kgdb_nmi.c
> index cfadf29..9361d69 100644
> --- a/drivers/tty/serial/kgdb_nmi.c
> +++ b/drivers/tty/serial/kgdb_nmi.c
> @@ -43,6 +43,11 @@ module_param_named(magic, kgdb_nmi_magic, charp, 0600);
>  MODULE_PARM_DESC(magic, "magic sequence to enter NMI debugger (default $3#33)");
>  
>  static bool kgdb_nmi_tty_enabled;
> +module_param_named(tty, kgdb_nmi_tty_enabled, bool, 0600);
> +MODULE_PARM_DESC(tty, "if set to false (default), characters received from "
> +		      "the UART will be passed exclusively to the knock "
> +		      "detector; when set to true characters will be passed "
> +		      "both to the knock detector and to the TTY layer");

Module options suck rocks through straws.

Isn't there _any_ other way to determine this "dynamically"?  How will
someone know to set this option?

Yeah, there are other options in this module, but please, why add more?

greg k-h
