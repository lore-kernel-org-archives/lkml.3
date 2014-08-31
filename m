Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaHaMwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 08:52:40 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:47408 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaHaMwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 08:52:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdV_naTfQOLwOshWq1Q15kSE39a8GWChsjt3RrWRcd6peg@mail.gmail.com>
References: <1409369788-22563-1-git-send-email-bobby.prani@gmail.com> <CAMuHMdV_naTfQOLwOshWq1Q15kSE39a8GWChsjt3RrWRcd6peg@mail.gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 31 Aug 2014 08:52:04 -0400
Message-ID: <CAJhHMCDaSAzU3zvhY2FRFoBaQH4oQBTsUsYMU6pvBbCXydROZQ@mail.gmail.com>
Subject: Re: [RFC PATCH] powerpc: Wire up three syscalls
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anton Blanchard <anton@samba.org>, Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Sun, Aug 31, 2014 at 4:53 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Pranith,
>
> On Sat, Aug 30, 2014 at 5:36 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:
>> I see that the three syscalls seccomp, getrandom and memfd_create are not wired
>> because of which we get a warning while compilation.
>>
>> So I wired them up in this patch. What else needs to be done? I tried the
>> memfd_test after compiling this kernel, but it is failing. What am I missing for
>> this to work? Any advice is really appreciated! :)
>
> Did it fail due to the (silly) "ifeq ($(ARCH),X86)" checks in
> tools/testing/selftests/memfd/Makefile?
>

I removed that check and compiled memfd_test.c by hand. This is the
following error which I get when I run the test:

$ ./memfd_test
memfd: CREATE
memfd: BASIC
10 != 0 = GET_SEALS(3)
Aborted

This is basically when checking the seals which we already added. It
should return 10 (F_SEAL_SHRINK | F_SEAL_WRITE), instead it is returning 0.

What else needs to be done for this to properly work? I see that for
m68k, you just wired it up like in this patch. Did it work after that?

-- 
Pranith
