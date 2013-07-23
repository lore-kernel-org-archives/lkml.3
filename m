Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab3GWP3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:29:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab3GWP3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:29:53 -0400
Date: Tue, 23 Jul 2013 08:31:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/irq/devres.c: move "kernel/irq/devres.c" to
 "drivers/base/devres_irq.c"
Message-ID: <20130723153104.GD13949@kroah.com>
References: <51EE3264.7010801@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EE3264.7010801@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 03:36:04PM +0800, Chen Gang wrote:
> "kernel/irq/devres.c" is a driver extension tool for irq (with devres)
> which is independent on 'GENERIC_HARDIRQS', so it is not suitable to
> still be in "kernel/irq/" which depends on 'GENERIC_HARDIRQS'.
> 
> It is a basic tool for drivers, so can move it to "drivers/base/" to be
> independent on 'GENERIC_HARDIRQS'.
> 
> It is about irq features, so if can not find other more suitable place,
> can still let their declaration in "include/linux/interrupts.h".
> 
> The related error (with randconfig which disable 'GENERIC_HARDIRQS')
> 
>   drivers/built-in.o: In function `dw_dma_probe':
>   (.text+0x3747a): undefined reference to `devm_request_threaded_irq'

Don't fix problems when you are moving files around, that makes it
_very_ hard to review.

Remember, one thing per patch please.

> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/base/Makefile     |    2 +-
>  drivers/base/devres_irq.c |   94 +++++++++++++++++++++++++++++++++++++++++++++
>  kernel/irq/Makefile       |    2 +-
>  kernel/irq/devres.c       |   94 ---------------------------------------------
>  4 files changed, 96 insertions(+), 96 deletions(-)
>  create mode 100644 drivers/base/devres_irq.c
>  delete mode 100644 kernel/irq/devres.c

Please use git when renaming files so that the move is shown in the git
patch.  As it is, I would have to verify this by hand, and I don't want
to ever have to do that.

Also, I have no problem with the file being where it is.  This is for
irqs, which are handled by the interrupt maintainers, no need to put it
in the driver core, just because it happens to deal with "resources".
We arrange things for ease of maintainability, not always logically :)

thanks,

greg k-h
