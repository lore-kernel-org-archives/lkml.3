Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3CLCcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:32:23 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:40119 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab3CLCcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:32:22 -0400
MIME-Version: 1.0
In-Reply-To: <1362663356-21151-1-git-send-email-tom.leiming@gmail.com>
References: <1362663356-21151-1-git-send-email-tom.leiming@gmail.com>
Date: Tue, 12 Mar 2013 10:32:21 +0800
Message-ID: <CACVXFVOhr222CVrzkVP_oLgVkdReD9BXXSBg7fmp6Wvx9_peCw@mail.gmail.com>
Subject: Re: [PATCH v1] ARM: keep __my_cpu_offset consistent with generic one
From: Ming Lei <tom.leiming@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 9:35 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> Commit 14318efb(ARM: 7587/1: implement optimized percpu variable access)
> introduces arm's __my_cpu_offset to optimize percpu vaiable access,
> which really works well on hackbench, but will cause __my_cpu_offset
> to return garbage value before it is initialized in cpu_init() called
> by setup_arch, so accessing percpu variable before setup_arch may cause
> kernel hang. But generic __my_cpu_offset always returns zero before
> percpu area is brought up, and won't hang kernel.
>
> So the patch tries to clear __my_cpu_offset on boot CPU early
> to avoid boot hang.
>
> At least now percpu variable is accessed by lockdep before
> setup_arch(), and enabling CONFIG_LOCK_STAT or CONFIG_DEBUG_LOCKDEP
> can trigger kernel hang.
>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Nicolas Pitre <nico@linaro.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
> V1:
>         - documents lockdep uses percpu variable early

Looks no one objects the patch, so I has submitted it into Russell's
patch system, and hope it can be pushed to linus tree soon and
make LOCK_STAT/DEBUG_LOCKDEP usable on ARMv7.


Thanks,
-- 
Ming Lei
