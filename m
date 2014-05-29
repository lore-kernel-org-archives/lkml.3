Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258AbaE2IDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:03:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38733 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933179AbaE2IDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:03:02 -0400
Date: Thu, 29 May 2014 09:01:52 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Wang Nan <wangnan0@huawei.com>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Geng Hui <hui.geng@huawei.com>
Subject: Re: [PATCH RESEND] ARM: kdump: 2nd kernel should use strict
 pfn_valid in SPARSEMEM platform
Message-ID: <20140529080151.GB29812@arm.com>
References: <1401266668-34365-1-git-send-email-wangnan0@huawei.com>
 <5386BD6A.7020509@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5386BD6A.7020509@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 05:54:02AM +0100, AKASHI Takahiro wrote:
> Catalin, Will
> 
> Can we assume that HAVE_ARCH_PFN_VALID is alway yes on arm64?
> Looking at arm64/Kconfig,
> config ARCH_HAS_HOLES_MEMORYMODEL
> 	def_bool y if SPARSEMEM
> ...
> config HAVE_ARCH_PFN_VALID
> 	def_bool ARCH_HAS_HOLES_MEMORYMODEL || !SPARSEMEM
> 
> is this intentional?

Looks like an artifact of the way we constructed those option, so yes, we
could just make that a def_bool y if you like.

Will
