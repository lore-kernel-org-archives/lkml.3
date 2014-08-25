Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbaHYOrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:47:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933203AbaHYOq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:46:57 -0400
Date: Mon, 25 Aug 2014 07:46:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Scott Yuan <scottzero0@gmail.com>
Cc: robh@kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250: serial device file is out of order
Message-ID: <20140825144614.GA14325@kroah.com>
References: <53FB2033.5010101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FB2033.5010101@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 07:38:27PM +0800, Scott Yuan wrote:
> From ebb85a61456bf25f87aeb8a31c92c74540bdf306 Mon Sep 17 00:00:00 2001
> From: Scott Yuan <scottzero0@gmail.com>
> Date: Sun, 24 Aug 2014 13:46:56 +0800
> Subject: [PATCH] 8250: serial device file is out of order

Why is this here in the email?  Please use git send-email to not send
this.

> On x86 architecture, the configuration of serial device maybe get from ACPI
> DSDT, but the order of DSDT is not mandatory, result as array
> serial8250_ports
> is out of order. This situation is more obvious in multiple serial port
> mainboard. Sort it by unique id that in DSDT will fix it.
> 
> Signed-off-by: Scott Yuan <scottzero0@gmail.com>
> ---
>  drivers/pnp/pnpacpi/core.c          |  1 +
>  drivers/tty/serial/8250/8250_core.c | 40
> ++++++++++++++++++++++++++++++++++++-
>  drivers/tty/serial/8250/8250_pnp.c  | 12 +++++++++++
>  include/linux/pnp.h                 |  1 +
>  include/linux/serial_8250.h         |  2 ++
>  5 files changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
> index a5c6cb7..84b518e 100644
> --- a/drivers/pnp/pnpacpi/core.c
> +++ b/drivers/pnp/pnpacpi/core.c
> @@ -254,6 +254,7 @@ static int __init pnpacpi_add_device(struct acpi_device
> *device)

Your patch is line-wrapped and can not be applied :(

