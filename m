Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3DPGBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:01:03 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53105 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab3DPGBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:01:01 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 16 Apr 2013 08:00:40 +0200
Message-ID: <CAKgNAkj0iKJuwk6moKYqzh_VRLfSQ=9pS6prt=BpXrk5mz=50w@mail.gmail.com>
Subject: Help request for clone(2) man page
To: Al Viro <viro@ftp.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>,
        Peter Schiffer <pschiffe@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

I see that you did some consolidating work for clone() in Linux 3.8,
and for that reason I suspect you know the answer to the questions
below. Could you take a short moment to look at the questions?

The relevant pieces of the clone(2) man page are quoted below. There
is some ancient text there that talks about the "struct pt_regs *regs"
argument. In 3.8, I see that you made changes that make mention of
that argument (even more?) obsolete, replacing it with 'tls_val'. In
any case, the page never actually explained the purpose of the
argument, and I do not know the past or present details.

Would you be able to help with the following:
* Provide a short explanation of the purpose of the 'tls_val' argument.
* Was the mention of "struct pt_regs *regs" already long obsolete, or
did it only become obsolete in 3.8? (I suspect the former.) In any
case, (if it makes sense to do so)would you be able to make some short
explanation of that argument, and also some statement about when it
became obsolete? (This is relevant, because man pages tries not to
document just current behavior but also the details in past kernel
versions.)

I'll try to work in whatever text you give me as part of the man page.

Thanks,

Michael



NAME
       clone, __clone2 - create a child process

SYNOPSIS
       /* Prototype for the glibc wrapper function */

       #include <sched.h>

       int clone(int (*fn)(void *), void *child_stack,
                 int flags, void *arg, ...
                 /* pid_t *ptid, struct user_desc *tls, pid_t *ctid */ );

       /* Prototype for the raw system call */

       long clone(unsigned long flags, void *child_stack,
                 void *ptid, void *ctid,
                 struct pt_regs *regs);
DESCRIPTION
       clone() creates a new process, in a manner similar to fork(2).

       This page describes both the glibc clone()  wrapper  function  and
       the  underlying  system  call on which it is based.  The main text
       describes the wrapper function; the differences for the raw system
       call are described toward the end of this page.

 [...]
   The raw system call interface
       The raw clone() system call corresponds more closely to fork(2) in
       that execution in the child continues from the point of the  call.
       As  such, the fn and arg arguments of the clone() wrapper function
       are omitted.  Furthermore, the argument order  changes.   The  raw
       system  call  interface  on  x86  and  many other architectures is
       roughly:

           long clone(unsigned long flags, void *child_stack,
                      void *ptid, void *ctid,
                      struct pt_regs *regs);

       Another difference for the raw system call is that the child_stack
       argument may be zero, in which case copy-on-write semantics ensure
       that the child gets separate copies of  stack  pages  when  either
       process  modifies the stack.  In this case, for correct operation,
       the CLONE_VM option should not be specified.

       For some architectures, the order of the arguments for the  system
       call  differs  from  that  shown above.  On the score, microblaze,
       ARM, ARM 64, PA-RISC, arc, Power PC, xtensa,  and  MIPS  architec‐
       tures,  the  order  of the fourth and fifth arguments is reversed.
       On the cris and s390 architectures, the order  of  the  first  and
       second arguments is reversed.

   clone2()
       On ia64, a different interface is used:

       int __clone2(int (*fn)(void *),
                    void *child_stack_base, size_t stack_size,
                    int flags, void *arg, ...
                 /* pid_t *ptid, struct user_desc *tls, pid_t *ctid */ );

       The  prototype  shown above is for the glibc wrapper function; the
       raw system call interface has no fn or arg argument,  and  changes
       the  order  of  the arguments so that flags is the first argument,
       and tls is the last argument.

       __clone2() operates in  the  same  way  as  clone(),  except  that
       child_stack_base points to the lowest address of the child's stack
       area, and stack_size specifies the size of the stack pointed to by
       child_stack_base.
