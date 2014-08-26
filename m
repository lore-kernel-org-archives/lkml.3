Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaHZQ2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:28:40 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34465 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaHZQ2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:28:38 -0400
Date: Tue, 26 Aug 2014 09:28:32 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
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
Message-ID: <20140826162831.GA22842@core.coreip.homeip.net>
References: <1408505461-24200-1-git-send-email-zyw@rock-chips.com>
 <20140820092117.GI4266@lee--X1>
 <53FA9D1E.8040202@rock-chips.com>
 <20140826092205.GG9574@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826092205.GG9574@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Aug 26, 2014 at 10:22:05AM +0100, Lee Jones wrote:
> On Mon, 25 Aug 2014, Chris Zhong wrote:
> > On 08/20/2014 05:21 PM, Lee Jones wrote:
> > >On Wed, 20 Aug 2014, Chris Zhong wrote:
> > >
> > >>The RK808 chip is a power management IC for multimedia and handheld
> > >>devices. It contains the following components:
> > >>
> > >>- Regulators
> > >>- RTC
> > >>
> > >>The rk808 core driver is registered as a platform driver and provides
> > >>communication through I2C with the host device for the different
> > >>components.
> > >>
> > >>Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> > >>---
> 
> [...]
> 
> > >>+	rk808->pdata = pdata;
> > >Remove pdata from 'struct rk808'.  You can obtain it from dev.
> > 
> > Can I keep this pdata in rk808, because it is used in the regulator driver.
> > The one obtain from dev maybe empty.
> 
> If the one in dev is empty, you should populate that instead.

No, drivers should not populate platform data in devices - they do not
own it (unlike drvdata). Platform data should be read-only so that if
one would unbind and then try to re-bind the driver we'd end up in
exactly same state as before.

For DT systems we should be allocating platform data separately and make
sure we clean up after ourselves.

Thanks.

-- 
Dmitry
