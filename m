Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3KSLDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:03:15 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54981 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751887Ab3KSLDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:03:13 -0500
Date: Tue, 19 Nov 2013 11:02:16 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Warren <swarren@nvidia.com>, Tomasz Figa <t.figa@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Alex Courbot <acourbot@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: move firmware_ops to drivers/firmware
Message-ID: <20131119110216.GD26487@arm.com>
References: <1384678169-28228-1-git-send-email-acourbot@nvidia.com>
 <CAHkRjk5LBOFx3ir49RgEsaFwvp5UCpTjYFWto+URXebAsOP0RA@mail.gmail.com>
 <52898417.80601@nvidia.com>
 <20131118115842.GE4050@arm.com>
 <528A4869.2020701@wwwdotorg.org>
 <20131118173047.GF9838@arm.com>
 <528A64D2.4020107@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528A64D2.4020107@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 07:04:50PM +0000, Christopher Covington wrote:
> On 11/18/2013 12:30 PM, Catalin Marinas wrote:
> [...]
> > You can't run legacy AArch32 code at EL3 and have lower levels in AArch64
> > mode (architectural constraint).
> 
> What prevents AArch32 code from running at EL3 and then requesting a reset to
> AArch64 by writing to the Reset Management Register before sliding down to
> lower exception levels?

You can do this for some initial code but the firmware still needs to
switch to AArch64 before dropping to lower exception levels. What this
thread is about is run-time calls to firmware for booting secondary
CPUs, idle, l2x0. At this point, the code at EL3 must run in AArch64
mode. There is no way you can bounce between AArch32 and AArch64 modes
using reset just to handle some SMCs.

-- 
Catalin
