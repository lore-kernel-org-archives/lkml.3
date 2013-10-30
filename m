Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3J3Lqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:46:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38393 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab3J3Lqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:46:45 -0400
Date: Wed, 30 Oct 2013 12:46:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 21/21] scripts/gdb: Add basic documentation
Message-ID: <20131030114638.GC13290@pd.tnic>
References: <cover.1382950737.git.jan.kiszka@siemens.com>
 <09fd0723f610c8bb33465c8a909f4269a35cdcf4.1382950737.git.jan.kiszka@siemens.com>
 <20131030111725.GA13298@pd.tnic>
 <5270EBE7.4010103@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5270EBE7.4010103@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 12:22:15PM +0100, Jan Kiszka wrote:
> > $ gdb vmlinux
> > Reading symbols from /w/kernel/linux-2.6/vmlinux...done.
> > warning: File "/w/kernel/linux-2.6/scripts/gdb/vmlinux-gdb.py" auto-loading has been declined by your `auto-load safe-path' set to "$debugdir:$datadir/auto-load".
> > To enable execution of this file add
> >         add-auto-load-safe-path /w/kernel/linux-2.6/scripts/gdb/vmlinux-gdb.py
> 
> Is that sufficient to be able to import all the sub-scripts as well?

If by that you mean whether I was able to use all commands in the
'apropos lx' list, then yes, it seems to work. Here's an arbitrary example:

(gdb) set $p = $lx_task_by_pid(12)
(gdb) p $lx_thread_info($p)
$8 = {task = 0xffff88007bcedb40, exec_domain = 0xffffffff8186c8a0 <default_exec_domain>, flags = 0, status = 0, cpu = 1, 
  saved_preempt_count = -2147483646, addr_limit = {seg = 18446744073709551615}, restart_block = {
    fn = 0xffffffff8105c3c0 <do_no_restart_syscall>, {futex = {uaddr = 0x0 <irq_stack_union>, val = 0, flags = 0, bitset = 0, time = 0, 
        uaddr2 = 0x0 <irq_stack_union>}, nanosleep = {clockid = 0, rmtp = 0x0 <irq_stack_union>, compat_rmtp = 0x0 <irq_stack_union>, 
        expires = 0}, poll = {ufds = 0x0 <irq_stack_union>, nfds = 0, has_timeout = 0, tv_sec = 0, tv_nsec = 0}}}, 
  sysenter_return = 0x0 <irq_stack_union>, sig_on_uaccess_error = 0, uaccess_err = 0}

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
