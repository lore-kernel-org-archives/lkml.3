Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3L0Gsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 01:48:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab3L0Gsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 01:48:51 -0500
Date: Thu, 26 Dec 2013 22:49:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, jslaby <jslaby@suse.cz>,
        Patch Tracking <patches@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH] serial: samsung: Remove hard-coded major/minor numbers
Message-ID: <20131227064924.GA3799@kroah.com>
References: <1388120848-15879-1-git-send-email-tushar.behera@linaro.org>
 <CAHbNUh27ZZ5UxuLMPvv6weNOSG4XKV9ZRrmTB9F0RvgQxufGDQ@mail.gmail.com>
 <20131227063843.GA3310@kroah.com>
 <1388126603.342451910@f289.i.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388126603.342451910@f289.i.mail.ru>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 10:43:23AM +0400, Alexander Shiyan wrote:
> Hello.
> > On Fri, Dec 27, 2013 at 12:00:20PM +0530, Tushar Behera wrote:
> > > On 27 December 2013 10:48, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > On Fri, Dec 27, 2013 at 10:37:28AM +0530, Tushar Behera wrote:
> > > >> The hard-coded values clash with the values set for amba-pl011 serial
> > > >> driver. Because of this there is no serial output on Samsung boards
> > > >> if amba-pl011 is enabled alongwith samsung-serial driver.
> > > >>
> > > >> Remove the hardcoded values and let the framework decide on
> > > >> appropriate major/minor number. This is required for multi-platform
> > > >> development work on Exynos platform.
> > > >>
> > > >> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ...
> > > >>  #define S3C24XX_SERIAL_NAME  "ttySAC"
> > > >> -#define S3C24XX_SERIAL_MAJOR 204
> > > >> -#define S3C24XX_SERIAL_MINOR 64
> > > >>
> > > >>  /* macros to change one thing to another */
> > > >>
> > > >> @@ -951,8 +949,6 @@ static struct uart_driver s3c24xx_uart_drv = {
> > > >>       .nr             = CONFIG_SERIAL_SAMSUNG_UARTS,
> > > >>       .cons           = S3C24XX_SERIAL_CONSOLE,
> > > >>       .dev_name       = S3C24XX_SERIAL_NAME,
> > > >> -     .major          = S3C24XX_SERIAL_MAJOR,
> > > >> -     .minor          = S3C24XX_SERIAL_MINOR,
> > > >
> > > > Doesn't this break existing systems and configurations that are
> > > > expecting 204:64 as the location of this serial port?
> > > >
> > > 
> > > I tested this on Exynos4210-Origen, Exynos5250-Arndale board, it works
> > > fine there. I haven't tested on any older boards.
> > 
> > How did it work?  You are relying on some userspace tools to do this
> > properly, right?  What about systems without those specific tools?
> 
> Can this issue be resolved by using MODULE_ALIAS_CHARDEV()
> in the driver code?

How exactly would that work?
