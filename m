Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbaHZLUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:20:24 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:46195 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbaHZLUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:20:22 -0400
Date: Tue, 26 Aug 2014 12:20:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lgirdwood@gmail.com, broonie@kernel.org,
        a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Subject: Re: [PATCH v2 2/5] MFD: RK808: Add new mfd driver for RK808
Message-ID: <20140826112013.GK9574@lee--X1>
References: <1408505461-24200-1-git-send-email-zyw@rock-chips.com>
 <20140820092117.GI4266@lee--X1>
 <53FA9D1E.8040202@rock-chips.com>
 <20140826092205.GG9574@lee--X1>
 <53FC5BD1.7030406@rock-chips.com>
 <20140826102036.GJ9574@lee--X1>
 <53FC63EE.6060104@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53FC63EE.6060104@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Chris Zhong wrote:
> On 08/26/2014 06:20 PM, Lee Jones wrote:
> >On Tue, 26 Aug 2014, Chris Zhong wrote:
> >>On 08/26/2014 05:22 PM, Lee Jones wrote:
> >>>On Mon, 25 Aug 2014, Chris Zhong wrote:
> >>>>On 08/20/2014 05:21 PM, Lee Jones wrote:
> >>>>>On Wed, 20 Aug 2014, Chris Zhong wrote:
> >>>>>
> >>>>>>The RK808 chip is a power management IC for multimedia and handheld
> >>>>>>devices. It contains the following components:
> >>>>>>
> >>>>>>- Regulators
> >>>>>>- RTC
> >>>>>>
> >>>>>>The rk808 core driver is registered as a platform driver and provides
> >>>>>>communication through I2C with the host device for the different
> >>>>>>components.
> >>>>>>
> >>>>>>Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> >>>>>>---
> >>>[...]
> >>>
> >>>>>>+	rk808->pdata = pdata;
> >>>>>Remove pdata from 'struct rk808'.  You can obtain it from dev.
> >>>>Can I keep this pdata in rk808, because it is used in the regulator driver.
> >>>>The one obtain from dev maybe empty.
> >>>If the one in dev is empty, you should populate that instead.
> >>So, should I malloc a pada, and assign it to client->dev?
> >If client->dev.pdata is NULL, yes.
> >
> >But actually, I have more important questions that need to be answered
> >first.  Ones which I would normally be able to answer myself if the
> >patch-set had been sent as one (i.e. threaded) instead of as
> >individual patches:
> >
> >- What are you using pdata for?
> 
> For save some properties,
> 
> like "rockchip,system-power-controller" in MFD
> and some regulator properties in regulator/rk808...
> 
> >- Where is pdata populated?
> 
> It is populated in probe in mfd/rk808.c
> 
> actually, I copy it from tps65910.c
> 
> 
> >- Where is pdata used?
> 
> pdata is used in mfd and regulator

I'm still a little confused.  I see it being populated in the MFD
driver, then I only see the attributes populated in the MFD driver
used in the MFD driver and nowhere else?  I do see other attributes
used in the regulator driver i.e. .of_node[], but these are then used
only in the regulator driver, thus they shouldn't really be pdata.

Let me put it another way:

struct rk808_board {
+       int irq;
+       int irq_base;
+       int wakeup;
+       bool pm_off;
+       struct regulator_init_data *rk808_init_data[rk808_NUM_REGULATORS];
+       struct device_node *of_node[rk808_NUM_REGULATORS];
+       int pmic_sleep_gpio;
+       unsigned int dcdc_slp_voltage[3]; /* buckx_voltage in uV */
+       unsigned int ldo_slp_voltage[7];
+};

For each of the above:

- Can it be passed from platform data i.e. arch/<arch>/{plat,mach}-*?
- Can it use local (not passed from driver to driver) variable instead?

If the answer to the first question is 'no' and/or if the answer to
the second question is 'yes', then it shouldn't be platform data.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
