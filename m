Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaIXSMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:12:33 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:39534 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaIXSMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:12:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140924154737.50db90eb@canb.auug.org.au>
References: <20140924154737.50db90eb@canb.auug.org.au>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 24 Sep 2014 11:12:09 -0700
Message-ID: <CALCETrWED3LzZzRwVL+X2dtLGVcQ7fPijbObJa-UvyARySoDeQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the tip tree with the audit tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 10:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the tip tree got a conflict in
> arch/x86/kernel/ptrace.c between commit 91397401bb50 ("ARCH: AUDIT:
> audit_syscall_entry() should not require the arch") from the audit tree
> and commit e0ffbaabc46d ("x86: Split syscall_trace_enter into two
> phases") from the tip tree.
>
> I fixed it up (see below - there is more cleanup possible since
> do_audit_syscall_entry() no longer needs its "arch" argument) and can
> carry the fix as necessary (no action is required).

[mainly for Eric]

This appears to re-introduce the bug fixed in:

commit 81f49a8fd7088cfcb588d182eeede862c0e3303e
Author: Andy Lutomirski <luto@amacapital.net>
Date:   Fri Sep 5 15:13:52 2014 -0700

    x86, x32, audit: Fix x32's AUDIT_ARCH wrt audit

This bug is not currently observable because enabling x32 disables
syscall auditing.

Eric, do you want to fix this or should I?

--Andy
