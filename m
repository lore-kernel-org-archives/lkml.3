Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaBNPai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:30:38 -0500
Received: from hofr.at ([212.69.189.236]:36035 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaBNPah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:30:37 -0500
Date: Fri, 14 Feb 2014 16:30:34 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: Re: [PATCH RT 4/5] allow preemption in
	mem_cgroup_move_account_page_stat
Message-ID: <20140214153034.GA4015@opentech.at>
References: <20140210153933.GE20017@opentech.at> <20140214131705.GF28438@linutronix.de> <20140214131959.GG28438@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214131959.GG28438@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, Sebastian Andrzej Siewior wrote:

> * Sebastian Andrzej Siewior | 2014-02-14 14:17:05 [+0100]:
> 
> >Now, that I look at it again. Isn't it more efficient to keep preemption
> >disabled for this very short time instead instead of invoking
> >migrate_disable() which includes preempt_disable()/enable() and a few
> >more opcodes???
> >Therefore, I drop it again.
> 
> I think doing the same for the 1/5 of this series since it also disables
> migration for a handfull of asm opcodes.
>
yup - nice run in the wrong direction :)
those short pushdowns make no sense - should have looked at that first...
the execution length/complexity (notably worst case on migrate_enable()) is
actually very high compared to a preempt_enable.

thx!
hofrat
