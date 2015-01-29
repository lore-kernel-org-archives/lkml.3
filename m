Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbbA2Jl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:41:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761213AbbA2JlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:41:01 -0500
Date: Thu, 29 Jan 2015 10:40:58 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: rostedt@goodmis.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jkosina@suse.cz
Subject: Question about ftrace, dynamically allocated trampolines and dynamic
 fops
Message-ID: <alpine.LNX.2.00.1501291023000.25445@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

solving a possible race condition in kGraft and thinking about the same in 
klp live patching I looked quite a lot at ftrace code. One thing about 
recent dynamic trampolines seems a bit odd. For dynamic fops 
(FTRACE_OPS_FL_DYNAMIC is set in ops->flags) arch_ftrace_update_trampoline 
is called only for nonpreemptive kernels in ftrace_update_trampoline. The 
reason is obvious and well described in the comment there. However the 
actual callback function in arch_ftrace_update_trampoline is 
determined by call to ftrace_ops_get_func which gives generic 
ftrace_ops_list_func for dynamic ops. This function disables preemption 
(because of traversing rcu protected list), so it should be safe to use 
dynamic trampolines even for dynamic fops in preemptive kernels. Is this 
correct? 

Or maybe the problem is the opposite. Why does the ftrace use 
ftrace_ops_list_func in such situation? Even for nonpreemptive kernel and 
dynamic fops ftrace_ops_list_func has unnecessary overhead.

I'm almost sure I must have missed something but I cannot see what. Could 
you point me at the right direction?

Thanks a lot in advance,
--
Miroslav Benes
SUSE Labs
