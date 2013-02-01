Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab3BAHGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 02:06:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35694 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3BAHGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 02:06:11 -0500
Message-ID: <510B693A.70807@ti.com>
Date: Fri, 1 Feb 2013 12:35:30 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <anilkumar@ti.com>,
        <tony@atomide.com>, <hs@denx.de>,
        <broonie@opensource.wolfsonmicro.com>, <sameo@linux.intel.com>,
        <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <rob@landley.net>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2 1/6] pinctrl: pinctrl-single: use arch_initcall and
 module_exit
References: <1359445134-13323-1-git-send-email-manishv.b@ti.com> <1359445134-13323-2-git-send-email-manishv.b@ti.com> <CACRpkdbf7TwrjfT2rhqQFGc3yh_Nt117RtzQO2y6g5Ddx5Ay_w@mail.gmail.com>
In-Reply-To: <CACRpkdbf7TwrjfT2rhqQFGc3yh_Nt117RtzQO2y6g5Ddx5Ay_w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/2013 4:29 PM, Linus Walleij wrote:
> On Tue, Jan 29, 2013 at 8:38 AM, Vishwanathrao Badarkhe, Manish
> <manishv.b@ti.com> wrote:
> 
>> Currently, I2C driver gets probed before pinctrl driver.
>> To achieve I2C pin muxing via pinctrl driver before I2C
>> probe get called, register pinctrl driver in arch_initcall.
>> Also, add module_exit to unregister pinctrl driver.
>>
>> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> 
> So your I2C driver is not returning -EPROBE_DEFER
> if it cannot find its pins?
> 
> Hm, well I can live with this, if Tony ACKs it.

FWIW, most of the other pinctrl drivers seem to be using arch_initcall() 
already.

$ grep -r arch_initcall drivers/pinctrl/*
drivers/pinctrl/pinctrl-at91.c:arch_initcall(at91_pinctrl_init);
drivers/pinctrl/pinctrl-coh901.c:arch_initcall(u300_gpio_init);
drivers/pinctrl/pinctrl-imx35.c:arch_initcall(imx35_pinctrl_init);
drivers/pinctrl/pinctrl-imx51.c:arch_initcall(imx51_pinctrl_init);
drivers/pinctrl/pinctrl-imx53.c:arch_initcall(imx53_pinctrl_init);
drivers/pinctrl/pinctrl-imx6q.c:arch_initcall(imx6q_pinctrl_init);
drivers/pinctrl/pinctrl-sirf.c:arch_initcall(sirfsoc_pinmux_init);
drivers/pinctrl/pinctrl-tegra20.c:arch_initcall(tegra20_pinctrl_init);
drivers/pinctrl/pinctrl-tegra30.c:arch_initcall(tegra30_pinctrl_init);
drivers/pinctrl/pinctrl-u300.c:arch_initcall(u300_pmx_init);
drivers/pinctrl/spear/pinctrl-spear300.c:arch_initcall(spear300_pinctrl_init);
drivers/pinctrl/spear/pinctrl-spear320.c:arch_initcall(spear320_pinctrl_init);
drivers/pinctrl/spear/pinctrl-spear310.c:arch_initcall(spear310_pinctrl_init);
drivers/pinctrl/spear/pinctrl-spear1340.c:arch_initcall(spear1340_pinctrl_init);
drivers/pinctrl/spear/pinctrl-spear1310.c:arch_initcall(spear1310_pinctrl_init);

Thanks,
Sekhar
