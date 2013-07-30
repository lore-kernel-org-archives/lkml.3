Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab3G3Mk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:40:27 -0400
Received: from [213.199.154.187] ([213.199.154.187]:50812 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750767Ab3G3MkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:40:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 7
X-BigFish: VS7(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kz70kd2izz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1de2h1dfeh1dffh1e23h1155h)
From: Arpit Goel <B44344@freescale.com>
To: <linux@arm.linux.org.uk>, <takata@linux-m32r.org>, <philb@gnu.org>,
        <geert@linux-m68k.org>, <schwidefsky@de.ibm.com>,
        <heiko.carstens@de.ibm.com>, <linux390@de.ibm.com>,
        <davem@davemloft.net>, <rob.herring@calxeda.com>, <arnd@arndb.de>,
        <sboyd@codeaurora.org>, <swarren@nvidia.com>, <john.stultz@linaro.org>,
        <jesper.nilsson@axis.com>, <gregkh@linuxfoundation.org>,
        <sam@ravnborg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-m32r@ml.linux-m32r.org>, <linux-m32r-ja@ml.linux-m32r.org>,
        <linux-m68k@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <sparclinux@vger.kernel.org>, Arpit Goel <B44344@freescale.com>
Subject: [PATCH 0/2] Make PPC macro spin_event_timeout() architecture independent
Date: Tue, 30 Jul 2013 18:08:18 +0530
Message-ID: <1375187900-17582-1-git-send-email-B44344@freescale.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set moves USECS_PER_JIFFY to architecture timex.h from architecture
specific C files. Patch-set further uses this to make PPC macro
spin_event_timeout() architecture independent. This change enables drivers to
use spin_event_timeout() even in non-PowerPC based SoC's.

This patchset has been compiled for ARM, PowerPC and x86.

Patch[1/2] : Moves USECS_PER_JIFFY to architecture specific timex.h files from
	     architecture specific C files.

Patch[2/2] : Converts PPC macro spin_event_timeout() in architecture independent
	     macro.

Arpit Goel (2):
  Make USECS_PER_JIFFY available for generic use
  Convert PowerPC macro spin_event_timeout() to architecture independent
        macro

 arch/arm/include/asm/timex.h      |  2 ++
 arch/arm/kernel/time.c            |  3 ---
 arch/m32r/include/asm/timex.h     |  2 ++
 arch/m32r/kernel/time.c           |  3 ---
 arch/m68k/hp300/time.c            |  4 +---
 arch/m68k/include/asm/timex.h     |  2 ++
 arch/s390/include/asm/timex.h     |  2 ++
 arch/s390/kernel/time.c           |  2 --
 arch/sparc/include/asm/timex_32.h |  2 ++
 arch/sparc/include/asm/timex_64.h |  2 ++
 arch/sparc/kernel/pcic.c          |  1 -
 include/linux/delay.h             | 40 +++++++++++++++++++++++++++++++++++++++
 12 files changed, 53 insertions(+), 12 deletions(-)

-- 
1.8.1.4


