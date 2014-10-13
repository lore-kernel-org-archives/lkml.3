Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaJMUZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:25:06 -0400
Received: from mout.gmx.net ([212.227.15.19]:62378 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbaJMUZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:25:04 -0400
Message-ID: <543C3515.9090000@gmx.de>
Date: Mon, 13 Oct 2014 22:24:53 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>,
        "Carlos O'Donell" <carlos@systemhalted.org>
Subject: Re: [GIT PULL] parisc architecture patch for v3.18
References: <20141012100837.GA1553@p100.box> <20141013144143.475ca9f9@alan.etchedpixels.co.uk>
In-Reply-To: <20141013144143.475ca9f9@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:fCDT32VFaSjAo3J0X4dYGvWY3PHU+T0XtiOI9avrG9px+vUvr80
 blwghf8STTRDwNvGVjH3iM+3peR5exY7sJ4C7nyxon7F0BNVG5Oq+3vwXCOUOYDW1d50lem
 bIVcenhP35FH8vEHpyCDscf7L+NzoUCAPC+xJIZQDsOznBPjVYAwKqO+N+utHA5+OkVS2on
 12Ji8SiAlvQkJ6Vxvy8mg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2014 03:41 PM, One Thousand Gnomes wrote:
> On Sun, 12 Oct 2014 12:08:37 +0200
> Helge Deller <deller@gmx.de> wrote:
>
>> Hi Linus,
>>
>> please pull one patch for the parisc architecture for kernel 3.18 from
>>    git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.18-1
>>
>> This patch intentionally breaks the ABI on PARISC Linux!
>>
>> It assigns new numbers to SIGSTKFLT, SIGXCPU, SIGXFSZ and SIGSYS so that
>> those are below 32 and thus leaves us with 32 RT signals like other
>> Linux architectures (SIGRTMIN now becomes 32 instead of 37).
>>
>> Even if it breaks the ABI, it doesn't seem to have any visible impact on
>> existing userspace applications.
>
> I somehow doubt your kill command magically corrects its signal numbering
> table. Likewise what does gdb do given a core dump that died from one of
> those signals, and what does your shell report if you kill one that way.
> It seems to me your minimal set of binaries to swap to get it right is
> non-zero but not problematic (libc, kill, shells, top, gdb) ?

My patch of course just marks the start of a transition phase, in which
some few applications need to be rebuilt (libc as the most important one).
But after all it makes a somewhat smooth transition possible, and as I
wrote in the commit message this is the best solution (out of 3) with the
least impact which we have.
  
> I can however really only think of one app that actually *used* SIGXCPU,
> and that was to respawn itself to avoid annoying sysadmin set CPU limits
> anyway.

:-)

Helge
