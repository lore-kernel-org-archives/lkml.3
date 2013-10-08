Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab3JHH1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:27:51 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:32987 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3JHH1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:27:47 -0400
Date: Tue, 8 Oct 2013 09:27:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [raw v1 0/4] Replace __this_cpu ops with raw_cpu_ops where
 necessary
Message-ID: <20131008072743.GB4455@gmail.com>
References: <0000014194309038-3923fc42-2039-45da-b8fa-2df545112405-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014194309038-3923fc42-2039-45da-b8fa-2df545112405-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> The kernel can detect __this_cpu ops in preemptible contexts after
> the preemption check patchset that I posted last week.
> 
> Here is a selection of patches to fix false positives caused by
> the additional checks. So far I have found no bug. Amazing.
> Looks like there was some prior work done to shake these things out?
> 
> I ran an upstream kernel using Ubuntu 13.04 + the preempt checking +
> the patches below on my desktop and with the following patches no
> __this_cpu ops triggered messages. The kernel had the default Ubuntu
> desktop configuration (+ CONFIG_PREEMPT + CONFIG_DEBUG_THIS_CPU_OPERATIONS).

Here are the current list of technical problems that still plague your 
submission:

 - see the technical questions I raised about the snmp patch

 - broken threading resulting in patches arriving out of order. (You
   ignored peterz's helpful suggestion to upgrade Quilt which would allow
   you to fix this.)

 - broken subject lines - no 'PATCH' for patches

 - inconsistent patch titles: broken, inconsistent subsystem tags, etc.

 - incomplete changelogs: you fail to quote the false positive that led 
   you to a change. In cases this results in a totally context-free
   changelog which loses information the moment it's committed upstream.

In particular the last 4 items were mentioned to you for your last 
submission - which you failed to fix. You should wait with your next 
submission until you have enough time to fix *all* problems that were 
reported to you, not just some.

All in one, still a sloppy, incomplete submission.

Thanks,

	Ingo
