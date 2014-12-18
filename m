Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaLRWp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:45:29 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:54389 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaLRWp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:45:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Agner <stefan@agner.ch>
Cc: linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        daniel.lezcano@linaro.org, tglx@linutronix.de, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, robh@kernel.org
Subject: Re: [PATCH 11/12] ARM: dts: add support for Vybrid running on Cortex-M4
Date: Thu, 18 Dec 2014 23:44:22 +0100
Message-ID: <2375016.nxLFC8UMcD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <44e9d518da24fb0c910de464269b8551@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch> <2615697.uVqMY8zKot@wuerfel> <44e9d518da24fb0c910de464269b8551@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:NfdlytMTcjxG9rR2iNDTOps17gQqn5p1P781QodXzy68S/MkhhS
 gRtZmnSky+DJsLDA+thFFJBNj7Tm+0eybSqvu6e3rGFdc5fb0o5lwO5QCPcIYcjh6Nrix0V
 z25jKrecsjbthKji6UDo8FU0d3Da0IcSubg9+rMAi7CNQ4tT8W4aMQ7xOlr3DuOMHDqmgii
 KrF6wNBeFlfneakL2ZwDQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2014 21:36:31 Stefan Agner wrote:
> On 2014-12-17 13:31, Arnd Bergmann wrote:
> > On Wednesday 17 December 2014 00:41:33 Stefan Agner wrote:
> >> On 2014-12-03 12:03, Arnd Bergmann wrote:
> >> > Starting with v3.19, you should be able to use the earlycon framework on
> >> > arm32, so it would be better to replace earlyprintk with earlycon here
> >> > and add a stdout-path property in chosen that points to the console
> >> > uart.
> >>
> >> I started to implement earlycon support, but something currently fails
> >> when earlycon tries to map the UART registers:
> >> [    0.000000] earlycon_map: Couldn't map 0x40027000
> >>
> >> I traced the issue a bit further down and found that get_vm_area_caller
> >> returns NULL (in __arm_ioremap_pfn_caller). This happend on Linus master
> >> as of today (2dbfca5a181973558277b28b1f4c36362291f5e0). Do I miss
> >> something here?
> > 
> > Hmm, I fear the arm32 FIX_EARLYCON_MEM support ended up not making it
> > into 3.19 after all. 
> 
> Is it because early_ioremap and fixmap still missing for arm32?
> According to Rob's patchset from spring fixmap is required, there is
> something in this tree:
> https://git.kernel.org/cgit/linux/kernel/git/robh/linux.git/log/?h=arm-fixmap

Right, that's the one, thanks for finding that again. There are five
patches on that branch. The first three got merged, and the one we
need is just the last one (ARM: fixmap early permanent mapping support),
but the implementation depends on the previous patch (arm: add
early_ioremap support).

I was hoping we'd see both of them in 3.19, but apparently Rob didn't
submit the latest version. If you don't mind, could you try forward-porting
them to the latest kernel and then submit them for inclusion? You could
also try adapting the last patch to work without the early_ioremap
support that we don't really need that urgently on arm32.

	Arnd
