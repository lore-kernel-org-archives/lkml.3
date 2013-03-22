Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422748Ab3CVRrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:47:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46344 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422700Ab3CVRrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:47:23 -0400
X-IronPort-AV: E=Sophos;i="4.84,893,1355126400"; 
   d="scan'208";a="31941595"
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] Fix msm timer clearing bugs
References: <1363318299-10814-1-git-send-email-sboyd@codeaurora.org>
Date: Fri, 22 Mar 2013 10:47:22 -0700
In-Reply-To: <1363318299-10814-1-git-send-email-sboyd@codeaurora.org> (Stephen
	Boyd's message of "Thu, 14 Mar 2013 20:31:36 -0700")
Message-ID: <8ya4ng3ba39.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> Patches are based on v3.9-rc2. These patches will conflict with
> my other patch series to remove the local timer API, but the
> conflict isn't impossible to resolve and we can figure out how to
> deal with that after review.
>
> Patch 1 is a bug fix which could probably go into 3.9 if desired.
> Patch 2 overhauls the DT binding to be cleaner, and patch 3 fixes
> a bug where we don't wait for the timer to be clear before
> programming it leading to no more ticks.
>
> Stephen Boyd (3):
>   ARM: msm: Stop counting before reprogramming clockevent
>   ARM: msm: Rework timer binding to be more general
>   ARM: msm: Wait for timer clear to complete
>
>  .../devicetree/bindings/arm/msm/timer.txt          |  41 ++++----
>  arch/arm/boot/dts/msm8660-surf.dts                 |  20 ++--
>  arch/arm/boot/dts/msm8960-cdp.dts                  |  22 ++--
>  arch/arm/mach-msm/timer.c                          | 115 ++++++++++-----------
>  4 files changed, 90 insertions(+), 108 deletions(-)

I've pulled these into msm for/next, so the conflicts will probably show
up soon.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
