Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3L0GiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 01:38:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3L0GiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 01:38:11 -0500
Date: Thu, 26 Dec 2013 22:38:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-serial <linux-serial@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, jslaby <jslaby@suse.cz>,
        Patch Tracking <patches@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH] serial: samsung: Remove hard-coded major/minor numbers
Message-ID: <20131227063843.GA3310@kroah.com>
References: <1388120848-15879-1-git-send-email-tushar.behera@linaro.org>
 <20131227051843.GA840@kroah.com>
 <CAHbNUh27ZZ5UxuLMPvv6weNOSG4XKV9ZRrmTB9F0RvgQxufGDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHbNUh27ZZ5UxuLMPvv6weNOSG4XKV9ZRrmTB9F0RvgQxufGDQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 12:00:20PM +0530, Tushar Behera wrote:
> On 27 December 2013 10:48, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Dec 27, 2013 at 10:37:28AM +0530, Tushar Behera wrote:
> >> The hard-coded values clash with the values set for amba-pl011 serial
> >> driver. Because of this there is no serial output on Samsung boards
> >> if amba-pl011 is enabled alongwith samsung-serial driver.
> >>
> >> Remove the hardcoded values and let the framework decide on
> >> appropriate major/minor number. This is required for multi-platform
> >> development work on Exynos platform.
> >>
> >> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> >> ---
> >>  drivers/tty/serial/samsung.c |    4 ----
> >>  1 file changed, 4 deletions(-)
> >>
> >> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> >> index c1af04d..9c20543 100644
> >> --- a/drivers/tty/serial/samsung.c
> >> +++ b/drivers/tty/serial/samsung.c
> >> @@ -56,8 +56,6 @@
> >>  /* UART name and device definitions */
> >>
> >>  #define S3C24XX_SERIAL_NAME  "ttySAC"
> >> -#define S3C24XX_SERIAL_MAJOR 204
> >> -#define S3C24XX_SERIAL_MINOR 64
> >>
> >>  /* macros to change one thing to another */
> >>
> >> @@ -951,8 +949,6 @@ static struct uart_driver s3c24xx_uart_drv = {
> >>       .nr             = CONFIG_SERIAL_SAMSUNG_UARTS,
> >>       .cons           = S3C24XX_SERIAL_CONSOLE,
> >>       .dev_name       = S3C24XX_SERIAL_NAME,
> >> -     .major          = S3C24XX_SERIAL_MAJOR,
> >> -     .minor          = S3C24XX_SERIAL_MINOR,
> >
> > Doesn't this break existing systems and configurations that are
> > expecting 204:64 as the location of this serial port?
> >
> 
> I tested this on Exynos4210-Origen, Exynos5250-Arndale board, it works
> fine there. I haven't tested on any older boards.

How did it work?  You are relying on some userspace tools to do this
properly, right?  What about systems without those specific tools?

> > Why change this one and not the amba-pl011 driver?
> >
> 
> I could only test this driver, so thought of changing this rather than
> modifying amba-pl011 driver. I don't have any other reason.

Please get the samsung driver maintainer to agree with this and sign off
on it before trying to get it merged again.

greg k-h
