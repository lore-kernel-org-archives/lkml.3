Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbaEGKRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 06:17:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62728 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754598AbaEGKRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 06:17:40 -0400
Date: Wed, 7 May 2014 11:17:09 +0100
From: Will Deacon <will.deacon@arm.com>
To: Larry Bassel <larry.bassel@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH v2 2/2] arm64: enable context tracking
Message-ID: <20140507101709.GE18456@arm.com>
References: <1399419149-26685-1-git-send-email-larry.bassel@linaro.org>
 <1399419149-26685-3-git-send-email-larry.bassel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399419149-26685-3-git-send-email-larry.bassel@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 12:32:29AM +0100, Larry Bassel wrote:
> Make calls to ct_user_enter when the kernel is exited
> and ct_user_exit when the kernel is entered (in el0_da,
> el0_ia, el0_svc, el0_irq).

Why only these entry points? I can reschedule after any exception from EL0,
so I'd expect all exceptions from userspace to need annotating, no?

> These macros expand to function calls which will only work
> properly if el0_sync and related code has been rearranged
> (in a previous patch of this series).
> 
> In order to avoid saving registers, the slow syscall path
> is forced (as x86 does).

... and if you decide to handle undef exceptions, I think you'll need
the register saving too, in case the kernel needs to perform emulation.

Will
