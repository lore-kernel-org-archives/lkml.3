Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750814Ab3HSH7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 03:59:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60105 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab3HSH7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 03:59:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [RFC v1 5/5] ARM: mvebu: add board init for Armada 1500
Date: Mon, 19 Aug 2013 09:58:54 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <201308172112.30773.arnd@arndb.de> <52115268.4010100@gmail.com>
In-Reply-To: <52115268.4010100@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308190958.54613.arnd@arndb.de>
X-Provags-ID: V02:K0:CmIFiVV2ydW83HUrSGmtVfuy9opQ7aGyGgQSYI3WQk2
 jj+vyE3hmb92laMilPVijo3ySUZ0daG0vFSxcPIpOgny9o/cmL
 HpuqC38wZMUydyes8ldoAshM+LNiZ/jcIAWyLDBx/CJeB9bF9o
 rLUPAeKg7AjYmqOLhIVDI3wVPtbP5PsfhWT6qW5tdLXgeq8tFv
 Gqjy9Nvutvijc1QQRWqWNpRvOtDiOCcSCljuUlDnPpQsRbRFsW
 YU7LdoSFaYCMLo7sjoG7yIylcetZ7L/c62GGbiAEhgN5CWhLOG
 2x3JNQ1g/RL3w2KZ38KGPhtI5vJogjtpqoPzab/FIhsAiR9mDq
 BiBQ4SOz7u6EAYSXbNO0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 August 2013, Sebastian Hesselbarth wrote:
> AFAIK, there is Armada 1500 (88de3100) used in every Google TV 2nd Gen
> devices, some older multimedia boxes also used Armada 1000 (88de3010),
> and Chromecast comprises Armada 1500-mini (88de3005).

According to the chromecast kernel sources (which seem to have all the
gtv stuff in them), they changed the CPU core between minor versons
of the 88de3100:

PJ4 based:

- MV88DE3100_BG2_A0
- MV88DE3100_BG2_A1

Cortex-A5 or Cortex-A9 based:

- MV88DE3100_BG2_CD
- MV88DE3100_BG2_CZ
- MV88DE3100_BG3

Those are Kconfig strings, I don't know how those correspond to
chip identification registers or labels printed on the SoC package.

> We should be able to find out if it is PJ4B or Cortex-A9 by checking
> any CPU register?

/proc/cpuinfo will tell you what core you have, see
http://wiki.casthacks.com/index.php?title=Google_ChromeCast_Specs:

CPU implementer : 0x41     # 0x41 == ARM Ltd
CPU architecture: 7        # 0x07 == ARMv7
CPU variant     : 0x3      # 0x03 == Core revision r3
CPU part        : 0xc09    # 0xc0? == Cortex-A?, 0xc09 == A9
CPU revision    : 0        # 0x00 == minor revision r3p0

On http://forum.gtvhacker.com/star-vap430-f40/topic972.html, I found
this for a PJ4 based 88de3100:

CPU implementer : 0x56
CPU architecture: 7
CPU variant     : 0x2
CPU part        : 0x584
CPU revision    : 1

Comparing those to other bits I found on the web, it actually seems to
be a PJ4B rather than the original PJ4.

	Arnd
