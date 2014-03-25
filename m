Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaCYQO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 12:14:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:53775 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaCYQO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 12:14:26 -0400
Date: Tue, 25 Mar 2014 17:14:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
cc: linux-gpio@vger.kernel.org, Alexandre Courbot <acourbot@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] provide irqchip in gpiolib
In-Reply-To: <1395751894-7110-1-git-send-email-linus.walleij@linaro.org>
Message-ID: <alpine.DEB.2.02.1403251714020.4203@ionos.tec.linutronix.de>
References: <1395751894-7110-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014, Linus Walleij wrote:

> This series provides a central facility for registering a chained
> (cascaded) irqchip as a sibling to a certain gpiochip. Patch one
> adds the API, patch 2, 3, 4 convert three drivers that I can test
> to use this facility.

Very nice consolidation work!

Acked-by: Thomas Gleixner <tglx@linutronix.de>
 

> Linus Walleij (4):
>   gpio: add IRQ chip helpers in gpiolib
>   gpio: pl061: convert driver to use gpiolib irqchip
>   pinctrl: nomadik: convert driver to use gpiolib irqchip
>   pinctrl: coh901: convert driver to use gpiolib irqchip
> 
>  drivers/gpio/Kconfig              |   4 +
>  drivers/gpio/gpio-pl061.c         |  80 ++++-----------
>  drivers/gpio/gpiolib.c            | 188 +++++++++++++++++++++++++++++++++++
>  drivers/pinctrl/Kconfig           |   4 +
>  drivers/pinctrl/pinctrl-coh901.c  | 204 ++++++++++----------------------------
>  drivers/pinctrl/pinctrl-nomadik.c | 123 ++++++-----------------
>  include/linux/gpio/driver.h       |  29 ++++++
>  7 files changed, 329 insertions(+), 303 deletions(-)
> 
> -- 
> 1.8.5.3
> 
> 
