Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaIAJee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:34:34 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:11339 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752207AbaIAJed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:34:33 -0400
Date: Mon, 1 Sep 2014 10:34:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Leo Yan <leoy@marvell.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2] arm64: fix bug for reloading FPSIMD state after cpu
 power off
Message-ID: <20140901093427.GC608@arm.com>
References: <1409540991-7573-1-git-send-email-leoy@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409540991-7573-1-git-send-email-leoy@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 04:09:51AM +0100, Leo Yan wrote:
> Now arm64 defers reloading FPSIMD state, but this optimization also
> introduces the bug after cpu resume back from low power mode.
> 
> The reason is after the cpu has been powered off, s/w need set the
> cpu's fpsimd_last_state to NULL so that it will force to reload
> FPSIMD state for the thread, otherwise there has the chance to meet
> the condition for both the task's fpsimd_state.cpu field contains the
> id of the current cpu, and the cpu's fpsimd_last_state per-cpu variable
> points to the task's fpsimd_state, so finally kernel will skip to reload
> the context during it return back to userland.
> 
> Signed-off-by: Leo Yan <leoy@marvell.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

(and cc'ing Will to pick it up since he's handling the 3.17 release)

Thanks.
