Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab3BVS12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:27:28 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38165 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758184Ab3BVS1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:27:23 -0500
Date: Fri, 22 Feb 2013 18:27:06 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: vfp: fix fpsid register subarchitecture field mask
 width
Message-ID: <20130222182705.GC19527@mudshark.cambridge.arm.com>
References: <1361520485-30269-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361520485-30269-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

On Fri, Feb 22, 2013 at 08:08:05AM +0000, Stephen Boyd wrote:
> From: Steve Muckle <smuckle@codeaurora.org>
> 
> The subarchitecture field in the fpsid register is 7 bits wide.
> The topmost bit is used to designate that the subarchitecture
> designer is not ARM. We use this field to determine which VFP
> version is supported by the CPU. Since the topmost bit is masked
> off we detect non-ARM subarchitectures as supporting only
> HWCAP_VFP and not HWCAP_VFPv3 as it should be for Qualcomm's
> processors.

I'm struggling to see why this has anything to do with the hwcaps being set
incorrectly. What value do you have in fpsid? As far as I can tell, the
subarchitecture bits 6:0 should start at 0x40 for you, right?

I can see cases for changing this code, I just don't see why it would go
wrong in the case you're describing.

Cheers,

Will
