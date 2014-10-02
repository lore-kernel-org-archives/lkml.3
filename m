Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaJBOdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:33:19 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:65500 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaJBOdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:33:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: linux-next: build failure after merge of the arm-soc tree
Date: Thu, 02 Oct 2014 16:32:42 +0200
Message-ID: <14357384.nIoLZkacVq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141002113742.2b521495@canb.auug.org.au>
References: <20141002113742.2b521495@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Sv4dqcjwlMiAjpkpwqeUc82Lsn03Lm9/my+fTxoSU1A
 eV/m67YjwkT+hj/pu7aICCzgOqoD1HvkCRH2QgqleR2UBSurOV
 d1YjUskvF1E3FOKy+q1Dg8ItGREfHPHnjxqa4sP9oDvENjBpCw
 O8DzCK1IiHHypQqbYa6YfMyokU65G9hWLgrkzJj8lDATe0IDDM
 24mRqJXatNhFrFvCruyr/0HIjEQA3cK0JWUEseTFjGQM3PXYiJ
 /p2IfPh7bN3kIAkuTbDIlKZNgcfN+aOaRcF+IE+it0q13vfmxA
 +sGhAL1kbIp9sQKrzu9Lerov1UBEqecsfdquXnxBYNQlw68nbc
 xdXyC3mGDmGAff5cjXBo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 October 2014 11:37:42 Stephen Rothwell wrote:
> After merging the arm-soc tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
> 
> arch/arm/boot/dts/exynos5250-snow.dts:13:46: fatal error: dt-bindings/clock/maxim,max77686.h: No such file or directory
>  #include <dt-bindings/clock/maxim,max77686.h>
>                                               ^
> 
> Caused by commit c04c92ed5614 ("ARM: dts: Add rtc_src clk for s3c-rtc
> on exynos5250-snow").
> 
> Presumably there is some dependency on some tree that someone has
> forgotten to merge 
> 
> I reverted that commit for today.
> 
> Which then got to:
> 
> /scratch/sfr/next/arch/arm/boot/dts/exynos5420-peach-pit.dts:15:46: fatal error: dt-bindings/clock/maxim,max77802.h: No such file or directory
>  #include <dt-bindings/clock/maxim,max77802.h>
>                                               ^
> compilation terminated.
> /scratch/sfr/next/arch/arm/boot/dts/exynos5800-peach-pi.dts:15:46: fatal error: dt-bindings/clock/maxim,max77802.h: No such file or directory
>  #include <dt-bindings/clock/maxim,max77802.h>
>                                               ^
> compilation terminated.
> Error: /scratch/sfr/next/arch/arm/boot/dts/hisi-x5hd2.dtsi:417.21-22 syntax error
> FATAL ERROR: Unable to parse input tree
> 
> Caused by 8bd43b6e6df7 ("ARM: dts: Add rtc_src clk for s3c-rtc on
> exynos Peach boards").
> 
> I give up ... please test your trees better ...

I'm deeply sorry about that. I actually saw the problem here but was too
tired to fix it up again by redoing all the merges in our next/late
branch.

I've changed the for-next branch now to drop all of next/late, I think
we're better off not sending any of it for 3.18, especially as I found
some other problems as well.

> I have used the arm-soc tree form next-20141001 for today (which still
> needs 5 reverts to get it to build :-().

D'oh. I actually fixed these already last friday in the next/dt branch
but for some reason forgot to include it in for-next.
I've made sure that everything is included now.

	Arnd
