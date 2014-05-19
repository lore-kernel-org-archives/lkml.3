Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaESL0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:26:54 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:52126 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaESL0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:26:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Bolle <pebolle@tiscali.nl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: remove ARM710 specific assembler code
Date: Mon, 19 May 2014 13:26:48 +0200
Message-ID: <5053472.zFAHKQVpbv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <9DBC3527-1961-40DD-8CBA-9A1B5D3003C9@arm.com>
References: <1364507176.1345.45.camel@x61.thuisdomein> <20140517094636.GP3693@n2100.arm.linux.org.uk> <9DBC3527-1961-40DD-8CBA-9A1B5D3003C9@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:4dK6C5DCU5RkwacmfzU6+NirElEyNirMaZZB78ipsQU
 Po7EqaZ1xPr+19I+mAQIrzeHjrFLmv2L2IwML24BU7iFs5WbSJ
 MEtDIkz1VYPpve4t3Gw/TdWCtPKgADGyKXj9YmfqA3byqggP4T
 REocn/QhbD2CwG/wBwqihJAzU9ELLImLAwelCnX1N9rFx/uC2V
 UUWjyqC4XNuiC+uYfw/RbYRmhQ5smDPVhxlDFcKgD0TBwmehyn
 DmgD93KkVET5uuZe7+l6kQMHW8aGOxp4L7WHShSeef17mJMb6X
 QG3HmsnsT1+xsx6jRjiwOdiRw3RDyr9hr0y5avmxYzVSzKNHU3
 Dp9FZCXlGDxbaPxWyg8o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 May 2014 10:56:02 Catalin Marinas wrote:
> > The difference between what you're proposing and what happened to ARMv3
> > is that ARMv3 was broken for quite some time (we read from some of the
> > CP15 registers which are read-only in ARMv3) and no one ever raised a
> > problem with that.  So, after a sufficient period of time, it got removed
> > - and no one batted an eyelid.  That's the correct way to do it - allow
> > code to age, and if no one notices it's been broken, then it can be
> > removed.
> 
> I’m more for pro-actively “breaking” it with a DEPRECATED
> dependency. For example, if you suspect that some code like ARM710T is
> no longer in use, we mark it and see if anyone complains about this over
> a two years period. If not, it gets removed.
> 
> Waiting for code to get broken is another way but it’s less
> predictable.

We used to have 'feature-removal-schedule.txt' file in the Documentation.
It never worked, and I don't see a reason to introduce something like that
again.

Yes, this means we will keep going through things that may or may not be
considered obsolete occasionally asking whether it's already dead. There
are a number of platforms we removed in the past years (e.g. shark,
h720x, bcmring, pnx4008, ixp2xxx, tcc8k and others before) and we haven't
had to revert any of those back. The rule has always been that even if
someone later comes and wants them back, we will revert the removal.
Others have been given temporary (e.g. gemini) or permanent (e.g. ixp4xx)
extensions, based on the feedback from the maintainers or remaining
users.

For the case of ARM710T, I think the last remaining user that can be
configured is mach-integrator, but I don't know if anybody even has that
CPU tile, or wants to keep using it. If Russell and Linus as the only
people that have cared about Integrator in the past years want to
cut down the number of supported CPUs, that would be a different matter:
quite a number of CPUs are not supported in any other platform.
Note that the integrator target in qemu does not support any ARM7, only
StrongARM, ARM9 or later. I also double-checked about mach-clps711x,
but I'm pretty sure those SoCs are all either ARM710a (no longer supported)
or ARM720T (quite active).

	Arnd
