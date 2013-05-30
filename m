Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030310Ab3E3JQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:16:01 -0400
Received: from mic92-1-81-57-185-249.fbx.proxad.net ([81.57.185.249]:55994
	"EHLO smtp.natisbad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967942Ab3E3JPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:15:51 -0400
X-Greylist: delayed 630 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 May 2013 05:15:51 EDT
X-Hashcash: 1:20:130530:thomas.petazzoni@free-electrons.com::d7zfQHKih3pW+rMb:000000000000000000000000004hwZ
From: arno@natisbad.org (Arnaud Ebalard)
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v5 12/13] ARM: kirkwood: remove redundant DT board files
References: <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1369855975-21489-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1369855975-21489-13-git-send-email-sebastian.hesselbarth@gmail.com>
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: D3A5 B68A 839B 38A5 815A 781B B77C 0748 A7AE 341B
X-Hashcash: 1:20:130530:davem@davemloft.net::oMEk0LUvR19jkoSH:0000000000000000000000000000000000000000000RM2
X-Hashcash: 1:20:130530:sebastian.hesselbarth@gmail.com::46FMLjP2VbIvWZYB:0000000000000000000000000000000TaU
X-Hashcash: 1:20:130530:benh@kernel.crashing.org::1qDToEgGfhAgjGqV:00000000000000000000000000000000000001OPN
X-Hashcash: 1:20:130530:linux-arm-kernel@lists.infradead.org::XZwbVp2ZxwqWJR1p:00000000000000000000000002swM
X-Hashcash: 1:20:130530:buytenh@wantstofly.org::vs4zV5XoLaPDFYna:0000000000000000000000000000000000000003olO
X-Hashcash: 1:20:130530:linuxppc-dev@lists.ozlabs.org::wkoP03B0GqeDekkx:000000000000000000000000000000003qD+
X-Hashcash: 1:20:130530:andrew@lunn.ch::mdYyC8k5dU1lwBBG:0005oTi
X-Hashcash: 1:20:130530:jason@lakedaemon.net::DK7m2DfjUGGmb/l7:000000000000000000000000000000000000000007oeF
X-Hashcash: 1:20:130530:linux-kernel@vger.kernel.org::ypiSPfQlHnmkWnd2:0000000000000000000000000000000006z2/
X-Hashcash: 1:20:130530:netdev@vger.kernel.org::qDSOtf8wkdYGN81H:000000000000000000000000000000000000000BHLP
Date: Thu, 30 May 2013 11:06:08 +0200
Message-ID: <8738t4q1kv.fsf@natisbad.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason and Sebastian,

Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> writes:

> With DT support for mv643xx_eth board specific init for some boards now
> is unneccessary. Remove those board files, Kconfig entries, and
> corresponding entries in kirkwood_defconfig.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Note: board-km_kirkwood.c is also removed, as Valentin Longchamp confirmed
> the lock-up is not caused by accessing clock gating registers but rather
> non-existent device registers. This will be addressed by dtsi separation
> for kirkwood and bobcat SoC variants.
>
> Changelog:
> v3->v4:
> - remove more boards that don't require board specific setup
>
> Cc: David Miller <davem@davemloft.net>
> Cc: Lennert Buytenhek <buytenh@wantstofly.org>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/configs/kirkwood_defconfig           |   16 ----
>  arch/arm/mach-kirkwood/Kconfig                |  117 -------------------------
>  arch/arm/mach-kirkwood/Makefile               |   16 ----
>  arch/arm/mach-kirkwood/board-dnskw.c          |    7 --
>  arch/arm/mach-kirkwood/board-dockstar.c       |   32 -------
>  arch/arm/mach-kirkwood/board-dreamplug.c      |   35 --------
>  arch/arm/mach-kirkwood/board-dt.c             |   62 +------------
>  arch/arm/mach-kirkwood/board-goflexnet.c      |   34 -------
>  arch/arm/mach-kirkwood/board-guruplug.c       |   33 -------
>  arch/arm/mach-kirkwood/board-ib62x0.c         |   29 ------
>  arch/arm/mach-kirkwood/board-iconnect.c       |   10 ---
>  arch/arm/mach-kirkwood/board-iomega_ix2_200.c |   34 -------
>  arch/arm/mach-kirkwood/board-km_kirkwood.c    |   44 ----------
>  arch/arm/mach-kirkwood/board-lsxl.c           |   16 ----
>  arch/arm/mach-kirkwood/board-mplcec4.c        |   14 ---
>  arch/arm/mach-kirkwood/board-ns2.c            |   35 --------
>  arch/arm/mach-kirkwood/board-openblocks_a6.c  |   26 ------
>  arch/arm/mach-kirkwood/board-readynas.c       |    6 --

Just a stupid note: With Thomas ongoing work to get mvebu-pcie driver in
place and enabled for kirkwood, some boards setup files will also lose
their pcie init routines, which may allow you to kill those additonal
files soon.

For instance 6bd98481ab34 (arm: kirkwood: NETGEAR ReadyNAS Duo v2 init
PCIe via DT) currently sitting in jcooper/mvebu/pcie_kirkwood removes
the PCIE init routine in board-readynas.c, and yours remove ge00
init. With both applied, the whole file can go away.

AFAICT, this may be the case soon for:

 arch/arm/mach-kirkwood/board-iconnect.c   (36e5722089)
 arch/arm/mach-kirkwood/board-mplcec4.c    (9470fbfb8d)
 arch/arm/mach-kirkwood/board-nsa310.c     (40fa8e5da2)
 arch/arm/mach-kirkwood/board-readynas.c   (6bd98481ab)
 arch/arm/mach-kirkwood/board-ts219.c      (259e234608)

Anyway, thanks for this work Sebastian.

Cheers,

a+
