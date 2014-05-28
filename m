Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaE1LpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:45:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55226 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363AbaE1LpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:45:08 -0400
Date: Wed, 28 May 2014 12:44:38 +0100
From: Will Deacon <will.deacon@arm.com>
To: Larry Bassel <larry.bassel@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH v5 2/2] arm64: enable context tracking
Message-ID: <20140528114438.GF15222@arm.com>
References: <1401130573-7443-1-git-send-email-larry.bassel@linaro.org>
 <1401130573-7443-3-git-send-email-larry.bassel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401130573-7443-3-git-send-email-larry.bassel@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry,

On Mon, May 26, 2014 at 07:56:13PM +0100, Larry Bassel wrote:
> Make calls to ct_user_enter when the kernel is exited
> and ct_user_exit when the kernel is entered (in el0_da,
> el0_ia, el0_svc, el0_irq and all of the "error" paths).
> 
> These macros expand to function calls which will only work
> properly if el0_sync and related code has been rearranged
> (in a previous patch of this series).
> 
> The calls to ct_user_exit are made after hw debugging has been
> enabled (enable_dbg_and_irq).
> 
> The call to ct_user_enter is made at the beginning of the
> kernel_exit macro.
> 
> This patch is based on earlier work by Kevin Hilman.
> Save/restore optimizations were also done by Kevin.

Apologies if we've discussed this before (it rings a bell), but why are we
penalising the fast syscall path with this? Shouldn't TIF_NOHZ contribute to
out _TIF_WORK_MASK, then we could do the tracking on the syscall slow path?

I think that would tidy up your mov into x19 too.

Also -- how do you track ret_from_fork in the child with these patches?

Will
