Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab3CGDpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:45:41 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38597 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033Ab3CGDpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:45:40 -0500
Date: Thu, 7 Mar 2013 03:44:55 +0000
From: Will Deacon <will.deacon@arm.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [RFC PATCH] ARM: keep __my_cpu_offset consistent with generic one
Message-ID: <20130307034454.GE25137@mudshark.cambridge.arm.com>
References: <1362624468-5451-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362624468-5451-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 07, 2013 at 02:47:48AM +0000, Ming Lei wrote:
> Commit 14318efb(ARM: 7587/1: implement optimized percpu variable access)
> introduces arm's __my_cpu_offset to optimize percpu vaiable access,
> which really works well on hackbench test, but may cause __my_cpu_offset
> to return garbage value before it is initialized in cpu_init() called
> by setup_arch, so accessing a percpu variable before setup_arch may cause
> kernel hang. But the generic__my_cpu_offset always returns zero before
> percpu area is brought up.
> 
> So the patch tries to clear __my_cpu_offset on boot CPU early
> to avoid boot hang.
> 
> At least now percpu variable is accessed by lockdep before
> setup_arch(), and enabling CONFIG_LOCK_STAT or CONFIG_DEBUG_LOCKDEP
> can trigger kernel hang.

For the record, can you include a backtrace or something please? The
description makes it sounds like a caller bug, so it would be good to
document a valid user of per-cpu before cpu_init().

Will
