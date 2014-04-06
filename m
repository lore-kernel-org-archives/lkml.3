Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaDFW2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 18:28:17 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:17616 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753726AbaDFW2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 18:28:15 -0400
Date: Sun, 6 Apr 2014 23:27:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Jean Pihet <jean.pihet@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: fix !CONFIG_COMPAT build failures
Message-ID: <20140406222737.GA26274@arm.com>
References: <1396707949-397-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396707949-397-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2014 at 03:25:49PM +0100, Mark Salter wrote:
> Recent arm64 builds using CONFIG_ARM64_64K_PAGES are failing with:
> 
>   arch/arm64/kernel/perf_regs.c: In function ‘perf_reg_abi’:
>   arch/arm64/kernel/perf_regs.c:41:2: error: implicit declaration of function ‘is_compat_thread’
> 
>   arch/arm64/kernel/perf_event.c:1398:2: error: unknown type name ‘compat_uptr_t’
> 
> This is due to some recent arm64 perf commits with compat support:
> 
>   commit 23c7d70d55c6d9:
>     ARM64: perf: add support for frame pointer unwinding in compat mode
> 
>   commit 2ee0d7fd36a3f8:
>     ARM64: perf: add support for perf registers API
> 
> Those patches make the arm64 kernel unbuildable if CONFIG_COMPAT is not
> defined and CONFIG_ARM64_64K_PAGES depends on !CONFIG_COMPAT. This patch
> allows the arm64 kernel to build with and without CONFIG_COMPAT.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

Thanks. Applied.

-- 
Catalin
