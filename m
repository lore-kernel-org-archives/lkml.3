Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab3GVN45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:56:57 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:43438 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab3GVN44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:56:56 -0400
Date: Mon, 22 Jul 2013 15:56:39 +0200
From: Robert Richter <rric@kernel.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Jed Davis <jld@mozilla.com>, Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>
Subject: Re: [PATCH] ARM: Fix r7/r11 confusion when CONFIG_THUMB2_KERNEL=y
Message-ID: <20130722135639.GA6927@rric.localhost>
References: <1373685501-1620-1-git-send-email-jld@mozilla.com>
 <20130715135420.GG10000@mudshark.cambridge.arm.com>
 <20130720044655.GC9433@mozilla.com>
 <20130721213753.GA29879@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130721213753.GA29879@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.07.13 22:37:53, Will Deacon wrote:
> Ok, I think I'm with you now. I also think that a better solution would be
> to try and limit the r7/fp confusion to one place, perhaps behind something
> like:
> 
> void arm_get_current_stackframe(struct pt_regs *regs, struct stackframe *frame);

In unwind_backtrace() there is already common code to do this and also
to get it from a task_struct. This could be ripped out. I would prefer
then the following function:

 void init_stackframe(struct stackframe *frame, struct pt_regs *regs,
      		      struct task_struct *tsk)

-Robert
