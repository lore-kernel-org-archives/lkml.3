Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbaHHKpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:45:18 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54288 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbaHHKpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:45:16 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E4AA35.1060703@roeck-us.net>
Date: Fri, 08 Aug 2014 03:45:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arch,locking: Ciao arch_mutex_cpu_relax()
References: <1403288473.10903.2.camel@buesod1.americas.hpqcorp.net>	 <20140623065835.GF19860@laptop.programming.kicks-ass.net>	 <1403622415.15523.4.camel@buesod1.americas.hpqcorp.net>	 <20140625062510.GB4260@osiris>	 <CA+55aFx3UQG42cYrUWrTDT9CnpnRwVta6C9N_0FH1wvyDMxPgw@mail.gmail.com>	 <1404079773.2619.4.camel@buesod1.americas.hpqcorp.net>	 <CAMuHMdX2ZCEd=J_Gpf-W+Zyqg27r4C6ULZgO=pg2houR-FXLvg@mail.gmail.com>	 <1407260539.6493.3.camel@buesod1.americas.hpqcorp.net> <1407460714.2513.19.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1407460714.2513.19.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 06:18 PM, Davidlohr Bueso wrote:
> On Tue, 2014-08-05 at 10:42 -0700, Davidlohr Bueso wrote:
>> On Tue, 2014-08-05 at 15:04 +0200, Geert Uytterhoeven wrote:
>>> It looks like you forgot to update frv?  It's been failing on -next since a
>>> few days:
>
> Anyway developers can be alerted sooner about this (ie: while its still
> in -next phase), like automated emails or something? This would be extra
> nice for those archs that are harder to get tested.
>
Not sure if that would help. After all, images are being built.
People just don't care enough to have a look.

FWIW, next-20140808 build results on my build/test farm:
	total: 132 pass: 120 fail: 12
Failed builds:
	frv:defconfig
	mips:nlm_xlp_defconfig
	openrisc:defconfig
	powerpc:allmodconfig (binutils 2.23 and 2.24)
	powerpc:mpc83xx_defconfig (ditto)
	powerpc:mpc85xx_defconfig (ditto)
	powerpc:mpc85xx_smp_defconfig (ditto)
	unicore32:defconfig

with qemu test runs failing for arm, mips, mips64, and ppc.

Which points to the next problem: I simply do not have the time to track down
all those failures, and I would guess neither do others who might be interested.
Geert is doing an excellent job trying to report and fix things, but quite frankly
sometimes one feels like Sisyphus trying to keep builds clean.

Guenter

