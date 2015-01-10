Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbbAJVsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:48:12 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:41107 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbbAJVsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:48:11 -0500
MIME-Version: 1.0
In-Reply-To: <10028397.kdbz8TfPck@wuerfel>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
	<4665410.x9Uu42bKmJ@wuerfel>
	<CA+55aFxphoLdFkwkVFQ87Q8EbYNqFAE-n0yTvCSOJzSO2MtDgw@mail.gmail.com>
	<10028397.kdbz8TfPck@wuerfel>
Date: Sat, 10 Jan 2015 13:48:10 -0800
X-Google-Sender-Auth: cVP8QXcWP0G0PV-w-jsCjozsW4E
Message-ID: <CA+55aFy4v3zOQDS62ECDD-WtjbbzdFxGOT1tNSuGy5ChzM4JGg@mail.gmail.com>
Subject: Re: Linux 3.19-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 1:36 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>>  (d) the powerpc TLB fill/buildup/teardown costs are horrible, so on
>> AIX the cost of lots of small pages is much higher too.
>
> I think (d) applies to ARM as well, since it has no hardware
> dirty/referenced bit tracking and requires the OS to mark the
> pages as invalid/readonly until the first access. ARMv8.1
> has a fix for that, but it's optional and we haven't seen any
> implementations yet.

Powerpc really makes things worse by having those hashed page tables
that (a) have bad locality and (b) have to be built up and torn down
in software. I don't think ARM ends up coming close, even with the
issues it has.

Now, it's definitely true that the x86 page table handling hadrware
tends to just be superior. Both Intel and AMD had to work really hard
on it, because Windows (in the pre-NT days) used to flush the TLB
absolutely _all_ the time.  So x86 hardware really does tend to do
very well on this.

ARM simply doesn't have the same kind of history. TLB issues seldom
show up very much on simple benchmarks or on smaller loads. It's one
of those things that tends to take a couple of generations.

[ Or, sadly, _much_ more, because some hardware designers never get
the memo, and continue to blame software and say "you should use big
pages", because they don't see the problems ]

Of course, it's entirely possible that vendors like AMD coudl transfer
their TLB handling know-how to their ARM64 cores. I have no visibility
into that, maybe some people here do..

                      Linus
