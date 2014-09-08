Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbaIHM5C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:57:02 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:61274 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbaIHM5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:57:00 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        =?UTF-8?q?Ga=EBl=20PORTAY?= <gael.portay@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: cleanup for 3.18 #2
Date: Mon, 8 Sep 2014 14:56:56 +0200
Message-ID: <1410181016-9944-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Another pull-request that can be considered as "fixes-non-critical" or
"cleanup". I choose the latest as the patches are a little bit more than just
fixes.  The bug found by Gaël is present on AT91 kernels for a long time so I
decided to avoid trying to submit it during the "-rc phase" or adding a
"stable" tag.
This material goes on top of the previous "cleanup" pull-request that you took
but comes with no dependency.

Thanks, best regards,

The following changes since commit 2626063f86cdce500153e8550334b9331421dc6f:

  ARM: at91: remove old irq material (2014-08-19 20:32:49 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-cleanup2

for you to fetch changes up to d07a1ecdfb96b26dd665b54fee22fc7417b1cb08:

  clocksource: tcb_clksrc: sanitize IRQ request (2014-09-08 10:54:03 +0200)

----------------------------------------------------------------
Second batch of AT91 cleanup for 3.18:
- Timer Counter (TC) fixup and cleanup:
  - fix segmentation fault when kexec-ing a kernel by masking
    TC interrupts at shutdown and probe time
  - use modern driver model: devm_*, probe function, sanitize IRQ request

----------------------------------------------------------------
Gaël PORTAY (4):
      ARM: at91/tclib: prefer using of devm_* functions
      ARM: at91/tclib: move initialization from alloc to probe
      ARM: at91/tclib: mask interruptions at shutdown and probe
      clocksource: tcb_clksrc: sanitize IRQ request

 drivers/clocksource/tcb_clksrc.c |  15 ++----
 drivers/misc/atmel_tclib.c       | 101 +++++++++++++++--------------------
 drivers/pwm/pwm-atmel-tcb.c      |   2 +-
 include/linux/atmel_tc.h         |  13 +++--
 4 files changed, 60 insertions(+), 71 deletions(-)

-- 
Nicolas Ferre
