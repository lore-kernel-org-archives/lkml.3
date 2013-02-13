Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab3BMNiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:38:09 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:29750
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755759Ab3BMNiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:38:07 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz8275dhz2dh87h2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 13 Feb 2013 21:37:52 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Max Filippov <jcmvbkbc@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] gpio: devm_gpio_* support should not depend on GPIOLIB
Message-ID: <20130213133749.GA13464@r65073-Latitude-E6420>
References: <20130118140346.3f9b182aa7daa175b4f136bf@canb.auug.org.au>
 <1358495866-9329-1-git-send-email-shawn.guo@linaro.org>
 <CACRpkdZA9O6N7hmtU-6R1Ff6hW5vjD_ar9RLG1dbkd+MWyoKiw@mail.gmail.com>
 <CAMo8BfJ=6WbAHoCpftRHW1iMtG8robyYUEqqCG2SecixDTgC+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAMo8BfJ=6WbAHoCpftRHW1iMtG8robyYUEqqCG2SecixDTgC+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late response due to Chinese New Year Holidays here.

On Sun, Feb 10, 2013 at 07:46:30AM +0300, Max Filippov wrote:
> On Sat, Jan 19, 2013 at 2:33 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Fri, Jan 18, 2013 at 8:57 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> >
> >> Some architectures (e.g. blackfin) provide gpio API without requiring
> >> GPIOLIB support (ARCH_WANT_OPTIONAL_GPIOLIB).  devm_gpio_* functions
> >> should also work for these architectures, since they do not really
> >> depend on GPIOLIB.
> >>
> >> Add a new option GPIO_DEVRES (enabled by default) to control the build
> >> of devres.c.  It also removes the empty version of devm_gpio_*
> >> functions for !GENERIC_GPIO build from linux/gpio.h, and moves the
> >> function declarations from asm-generic/gpio.h into linux/gpio.h.
> >>
> >> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> >
> > OK I removed the old version of the patch and pushed this instead.
> 
> Hi,
> 
> this patch causes the following errors for xtensa defconfig build:
> 
I assume this is a build of arch/xtensa/common_defconfig.

> include/asm-generic/gpio.h:265:2: error: implicit declaration of
> function '__gpio_get_value' [-Werror=implicit-function-declaration]
> include/asm-generic/gpio.h:271:2: error: implicit declaration of
> function '__gpio_set_value' [-Werror=implicit-function-declaration]
> include/linux/gpio.h:60:90: error: redefinition of 'gpio_cansleep'
> include/linux/gpio.h:62:2: error: implicit declaration of function
> '__gpio_cansleep' [-Werror=implicit-function-declaration]
> include/linux/gpio.h:67:2: error: implicit declaration of function
> '__gpio_to_irq' [-Werror=implicit-function-declaration]
> drivers/gpio/devres.c:26:2: error: implicit declaration of function
> 'gpio_free' [-Werror=implicit-function-declaration]
> drivers/gpio/devres.c:60:2: error: implicit declaration of function
> 'gpio_request' [-Werror=implicit-function-declaration]
> drivers/gpio/devres.c:90:2: error: implicit declaration of function
> 'gpio_request_one' [-Werror=implicit-function-declaration]
> 
I'm not sure why GENERIC_GPIO is needed for this build at all.  At
least, with the change below, everything seems building fine with
common_defconfig.

Shawn

diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 13358e1..cfc41f3 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -31,9 +31,6 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_HWEIGHT
        def_bool y
 
-config GENERIC_GPIO
-       def_bool y
-
 config ARCH_HAS_ILOG2_U32
        def_bool n
 


