Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583AbaHZKUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:20:47 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60581 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934440AbaHZKUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:20:45 -0400
Date: Tue, 26 Aug 2014 11:20:36 +0100
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
Message-ID: <20140826102036.GJ9574@lee--X1>
References: <1408505461-24200-1-git-send-email-zyw@rock-chips.com>
 <20140820092117.GI4266@lee--X1>
 <53FA9D1E.8040202@rock-chips.com>
 <20140826092205.GG9574@lee--X1>
 <53FC5BD1.7030406@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53FC5BD1.7030406@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Chris Zhong wrote:
> On 08/26/2014 05:22 PM, Lee Jones wrote:
> >On Mon, 25 Aug 2014, Chris Zhong wrote:
> >>On 08/20/2014 05:21 PM, Lee Jones wrote:
> >>>On Wed, 20 Aug 2014, Chris Zhong wrote:
> >>>
> >>>>The RK808 chip is a power management IC for multimedia and handheld
> >>>>devices. It contains the following components:
> >>>>
> >>>>- Regulators
> >>>>- RTC
> >>>>
> >>>>The rk808 core driver is registered as a platform driver and provides
> >>>>communication through I2C with the host device for the different
> >>>>components.
> >>>>
> >>>>Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> >>>>---
> >[...]
> >
> >>>>+	rk808->pdata = pdata;
> >>>Remove pdata from 'struct rk808'.  You can obtain it from dev.
> >>Can I keep this pdata in rk808, because it is used in the regulator driver.
> >>The one obtain from dev maybe empty.
> >If the one in dev is empty, you should populate that instead.
> 
> So, should I malloc a pada, and assign it to client->dev?

If client->dev.pdata is NULL, yes.

But actually, I have more important questions that need to be answered
first.  Ones which I would normally be able to answer myself if the
patch-set had been sent as one (i.e. threaded) instead of as
individual patches:

- What are you using pdata for?
- Where is pdata populated?
- Where is pdata used?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
