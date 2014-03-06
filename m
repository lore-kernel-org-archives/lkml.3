Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaCFQ35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:29:57 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:64409 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaCFQ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:29:55 -0500
Date: Thu, 6 Mar 2014 08:29:51 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com
Subject: Re: [PATCH v2] mfd: max8997: use regmap to access registers
Message-ID: <20140306162951.GA14318@core.coreip.homeip.net>
References: <1394031497-16648-1-git-send-email-r.baldyga@samsung.com>
 <20140305185439.GC5453@core.coreip.homeip.net>
 <531818D6.3080500@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531818D6.3080500@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 07:42:30AM +0100, Robert Baldyga wrote:
> Hi,
> 
> On 03/05/2014 07:54 PM, Dmitry Torokhov wrote:
> > Hi Robert,
> > 
> > On Wed, Mar 05, 2014 at 03:58:17PM +0100, Robert Baldyga wrote:
> >>  
> >> -int max8997_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
> >> +int max8997_write_reg(struct regmap *map, u8 reg, u8 value)
> > 
> > Why don't you make read/write reg to take struct max8997_dev as argument
> > instead of regmap? regmap seems to be the current implementation du jur,
> > but that is core's detail, functions do not need to care.
> > 
> > Thanks.
> > 
> 
> It's because there are few regmaps in max8997_dev, and read/write reg
> functions has no way to check which regmap should be used. I think it
> would be clearer if I remove this functions and use regmap_read and
> regmap_write instead, because there is no particular purpose for them.

I see.. Then another question - why do the regmaps belong to the core
of the driver instead of individual functions? Why haptic regmap, for
example, can not be initialized in haptic code instead?

Thanks.

-- 
Dmitry
