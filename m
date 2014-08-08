Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbaHHHiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:38:11 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:37549 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbaHHHiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:38:08 -0400
Date: Fri, 8 Aug 2014 08:38:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, ajitpal.singh@st.com
Subject: Re: [PATCH v2 06/11] pwm: sti: Add new driver for ST's PWM IP
Message-ID: <20140808073802.GC21618@lee--X1>
References: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
 <1405348412-7352-7-git-send-email-lee.jones@linaro.org>
 <20140807142344.GA11095@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140807142344.GA11095@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Aug 2014, Thierry Reding wrote:
> On Mon, Jul 14, 2014 at 03:33:27PM +0100, Lee Jones wrote:
> [...]
> > +static int sti_pwm_probe(struct platform_device *pdev)
> > +{
> [...]
> > +	pc->clk = of_clk_get_by_name(np, "pwm");
> 
> This didn't compile because the np variable isn't declared. It was easy
> to fix up, so I did, but please be more careful next time that the
> patches you submit at least compile (preferably without sparse warnings
> of which I also fixed up a couple).

That's annoying, I thought I did build test the final changes.
However, there's a mistake in the Makefile meaning that it wasn't
building with no warning/error messages - it actually wasn't building
at all!  Sorry about that Thierry.

I guess if you can build the driver, you've already fixed that?

diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 878333a..79665e3 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_PWM_PXA)         += pwm-pxa.o
 obj-$(CONFIG_PWM_RENESAS_TPU)  += pwm-renesas-tpu.o
 obj-$(CONFIG_PWM_SAMSUNG)      += pwm-samsung.o
 obj-$(CONFIG_PWM_SPEAR)                += pwm-spear.o
-obj-$(CONFIG_PWM_STI)          += pwm-st.o
+obj-$(CONFIG_PWM_STI)          += pwm-sti.o
 obj-$(CONFIG_PWM_TEGRA)                += pwm-tegra.o
 obj-$(CONFIG_PWM_TIECAP)       += pwm-tiecap.o
 obj-$(CONFIG_PWM_TIEHRPWM)     += pwm-tiehrpwm.o

After that change, I can see that you're absolutely correct:

  CC      drivers/pwm/pwm-sti.o
../drivers/pwm/pwm-sti.c: In function ‘sti_pwm_config’:
../drivers/pwm/pwm-sti.c:202:3: warning:
  format ‘%lu’ expects argument of type ‘long unsigned int’, but
  argument 5 has type ‘int’ [-Wformat=]
     dev_dbg(dev, "prescale:%u, period:%lu, duty:%i, pwmvalx:%u\n",
     ^
../drivers/pwm/pwm-sti.c: In function ‘sti_pwm_probe’:
../drivers/pwm/pwm-sti.c:352:31: error: ‘np’ undeclared 
  pc->clk = of_clk_get_by_name(np, "pwm");
                               ^
Sorry for the fuss.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
