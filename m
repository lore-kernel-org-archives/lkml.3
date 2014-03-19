Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934342AbaCSREq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:04:46 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:60954 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbaCSREn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:04:43 -0400
Date: Wed, 19 Mar 2014 17:04:37 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Mark Brown <broonie@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Vince Hsu <vinceh@nvidia.com>
Subject: Re: [PATCH] mfd: as3722: make FUSE7_REG readable
Message-ID: <20140319170437.GA18095@lee--X1>
References: <1393951832-2638-1-git-send-email-swarren@wwwdotorg.org>
 <20140305015539.GK10579@lee--X1>
 <5329C133.60900@wwwdotorg.org>
 <20140319170138.GK31687@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140319170138.GK31687@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >> From: Stephen Warren <swarren@nvidia.com>
> > >>
> > >> The FUSE7_REG register is not currently marked readable. This causes
> > >> as3722_sd0_is_low_voltage() to emit an error during boot, and assume
> > >> the range of the SD0 regulator:
> > >>
> > >> as3722-regulator as3722-regulator: Reg 0xa7 read failed: -5
> > >>
> > >> Fixes: d4807ad2c4c0 ("regmap: Check readable regs in _regmap_read")
> > >> [exposed the bug, by checking for readability]
> > >> Fixes: 762a8ee80897 ("regulator: as3722: detect SD0 low-voltage mode")
> > >> [left out this register from the readable list]
> > >> Cc: Mark Brown <broonie@linaro.org>
> > >> Cc: Michal Simek <michal.simek@xilinx.com>
> > >> Cc: Andrew Bresticker <abrestic@chromium.org>
> > >> Cc: Vince Hsu <vinceh@nvidia.com>
> > >> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > >> ---
> > >> Note: I believe the regmap commit mentioned above is for 3.15, whereas
> > >> the as3722 commit is in at least 3.14. So, this only needs to be applied
> > >> for 3.15, but might make sense to go into earlier kernels, at your
> > >> discretion.
> > > 
> > > Applied to MFD -next (v3.15).
> > 
> > I don't see this in next-20140319; did it get dropped somewhere, or was
> > your branch not pushed out?
> 
> Ah, thanks for the reminder.
> 
> I moved the MFD tree from linaro.org to kernel.org, but failed to let
> Stephen know. I'll do so now.

Whoops. No, you're Stephen. I meant Andrew.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
