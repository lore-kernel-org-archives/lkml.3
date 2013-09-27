Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3I0LA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 07:00:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44229 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753265Ab3I0LAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 07:00:20 -0400
Date: Fri, 27 Sep 2013 11:59:58 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH v1 1/7] arm64: fix possible invalid FPSIMD
 initialization state
Message-ID: <20130927105957.GB11063@MacBook-Pro.local>
References: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
 <1380269087-8520-2-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380269087-8520-2-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 09:04:41AM +0100, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> If context switching happens during executing fpsimd_flush_thread(),
> stale value in FPSIMD registers will be saved into current thread's
> fpsimd_state by fpsimd_thread_switch(). That may cause invalid
> initialization state for the new process, so disable preemption
> when executing fpsimd_flush_thread().

Good catch.

-- 
Catalin
