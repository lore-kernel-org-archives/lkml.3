Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab3BLKOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:14:53 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34347
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756062Ab3BLKOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:14:52 -0500
Message-ID: <1360664089.4485.6.camel@laptop>
Subject: Re: [patch v4 02/18] sched: select_task_rq_fair clean up
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 11:14:49 +0100
In-Reply-To: <1358996820-23036-3-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <1358996820-23036-3-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
> It is impossible to miss a task allowed cpu in a eligible group.

I suppose your reasoning goes like: tsk->cpus_allowed is protected by
->pi_lock, we hold this, therefore it cannot change and
find_idlest_group() dtrt?

We can then state that this is due to adding proper serialization to
tsk->cpus_allowed.

> And since find_idlest_group only return a different group which
> excludes old cpu, it's also impossible to find a new cpu same as old
> cpu.

Sounds plausible, but I'm not convinced, do we have hard serialization
against hotplug?



