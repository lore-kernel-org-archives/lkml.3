Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaCKRoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:44:07 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:54991 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbaCKRnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:43:12 -0400
MIME-Version: 1.0
Date: Tue, 11 Mar 2014 10:43:11 -0700
X-Google-Sender-Auth: hvDa9VbBzSOcFA3EPROw_i-RYzI
Message-ID: <CA+55aFw_1Cw1hWVLB7HG_2SKW=7NXH8=DR3a96q4fqOhoOcdpQ@mail.gmail.com>
Subject: On trying to drop X86_PPRO_FENCE..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 3:11 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> But ... when PPro was common our parallelization sucked, so I'd not be
> surprised if it triggered more frequently with a modern kernel.

Agreed. It is certainly very possible that we had no reports of this
simply because we never had any real concurrent cache accesses
(outside of the BKL).

That said, the Intel errata does do say that they never saw reports of
it in any real loads either, so it really is debatable whether it ever
made sense. Back in the PPro days, there were *other* x86 unixes
around that might have hit it, including very much the Sequent NUMA-Q.

I have this dim memory that the only reason I knew about the errata
originally was that I was talking memory ordering for the spinlock
code with Andy Glew from Intel, to verify that a simple store really
does work as an unlock, and he dropped the "Yeah, except for some
buggy old PPro cpu errata" bomb.

(Although honestly, that whole thing is so long ago that my "dim
memory" is very suspect, and it's possible the workaround actually
came independently of that from Alan Cox. This all happened in
v2.4.13-rc2 - late 2001 - and the PPro workaround came in together
with the X86 OOSTORE code, which I *think* was Alan. Asking the gnomes
in case they remember how it happened).

                 Linus
