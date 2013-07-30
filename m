Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab3G3A2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:28:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52458 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3G3A2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:28:50 -0400
Date: Mon, 29 Jul 2013 17:28:49 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: ohad@wizery.com,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>
Subject: Re: [PATCH] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex
 block
Message-ID: <20130730002849.GE8868@codeaurora.org>
References: <1375128719-23642-1-git-send-email-galak@codeaurora.org>
 <E9700EA7-7154-46C5-9258-03F030DF69F6@codeaurora.org>
 <20130729214035.GC8868@codeaurora.org>
 <9EB1A821-7137-4812-B58A-20F669BCA7DD@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9EB1A821-7137-4812-B58A-20F669BCA7DD@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Kumar Gala wrote:
> 
> On Jul 29, 2013, at 4:40 PM, Stephen Boyd wrote:
> 
> > On 07/29, Kumar Gala wrote:
> >>> +#include <linux/of_device.h>
> >>> +#include <linux/hwspinlock.h>
> >>> +
> >>> +#include <asm/io.h>
> > 
> > <linux/io.h> please.
> 
> will change, I choice <asm/io.h> since *_relaxed are arm specific.
> 

I thought readl_relaxed() was universal for HAS_IOMEM arches.
Unfortunately writel_relaxed() isn't defined on all arches.
Luckily this driver depends on ARCH_MSM so it isn't a problem.

Perhaps it should just depend on HAS_IOMEM so we can use it on
arm64 and/or hexagon in the future without having to change the
Kconfig. That would require introducing writel_relaxed() into the
other arches that don't have it right now.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
