Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbaH0L1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 07:27:20 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:64984 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbaH0L1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 07:27:18 -0400
Date: Wed, 27 Aug 2014 12:27:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Chris Zhong <zyw@rock-chips.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sameo@linux.intel.com, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Subject: Re: [PATCH v2 2/5] MFD: RK808: Add new mfd driver for RK808
Message-ID: <20140827112709.GB6364@lee--X1>
References: <1408505461-24200-1-git-send-email-zyw@rock-chips.com>
 <20140820092117.GI4266@lee--X1>
 <53FA9D1E.8040202@rock-chips.com>
 <20140826092205.GG9574@lee--X1>
 <20140826162831.GA22842@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140826162831.GA22842@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Dmitry Torokhov wrote:
> On Tue, Aug 26, 2014 at 10:22:05AM +0100, Lee Jones wrote:
> > On Mon, 25 Aug 2014, Chris Zhong wrote:
> > > On 08/20/2014 05:21 PM, Lee Jones wrote:
> > > >On Wed, 20 Aug 2014, Chris Zhong wrote:
> > > >
> > > >>The RK808 chip is a power management IC for multimedia and handheld
> > > >>devices. It contains the following components:
> > > >>
> > > >>- Regulators
> > > >>- RTC
> > > >>
> > > >>The rk808 core driver is registered as a platform driver and provides
> > > >>communication through I2C with the host device for the different
> > > >>components.
> > > >>
> > > >>Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> > > >>---
> > 
> > [...]
> > 
> > > >>+	rk808->pdata = pdata;
> > > >Remove pdata from 'struct rk808'.  You can obtain it from dev.
> > > 
> > > Can I keep this pdata in rk808, because it is used in the regulator driver.
> > > The one obtain from dev maybe empty.
> > 
> > If the one in dev is empty, you should populate that instead.
> 
> No, drivers should not populate platform data in devices - they do not
> own it (unlike drvdata). Platform data should be read-only so that if
> one would unbind and then try to re-bind the driver we'd end up in
> exactly same state as before.

Right.

I guess this point is moot now, as my other point about pdata not
actually being required has been accecpted.  But, when I say "you
can obtain it from dev" I meant via dev_get_platdata(dev), rather than
dev_get_platdata(dev->parent).  So if this 'pdata' has to go somewhere,
rather than sticking it in the MFD's (parent) platform_data, the
.platform_data attribute in 'struct mfd_cell' should be used.

> For DT systems we should be allocating platform data separately and make
> sure we clean up after ourselves.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
