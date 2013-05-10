Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3EJPCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:02:54 -0400
Received: from multi.imgtec.com ([194.200.65.239]:14598 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab3EJPCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:02:53 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH RFC 0/2] clk: add metag specific gate/mux clocks
Date: Fri, 10 May 2013 16:02:02 +0100
Message-ID: <1368198127-1295-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_10_16_02_48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a metag architecture specific clk-gate and clk-mux which
extends the generic ones to use global lock2 to protect the register
fields. It is common with metag to have an RTOS running on a different
thread or core with access to different bits in the same register (which
contain clock gate/switch bits for other clocks). Access to such
registers must be serialised with a global lock such as the one provided
by the metag architecture port in <asm/global_lock.h>

RFC because despite extending the generic clocks there's still a bit of
duplicated code necessary. One alternative is to add special cases to
the generic clock components for when a global or callback function
based lock is desired instead of a spinlock, but I wasn't sure if that
sort of hack would really be appreciated in the generic drivers.

Comments?

James Hogan (2):
  clk: metag/clk-gate: add metag specific clock gate
  clk: metag/clk-mux: add metag specific clk-mux

 .../bindings/clock/img,meta-gate-clock.txt         |  28 +++
 .../bindings/clock/img,meta-mux-clock.txt          |  33 ++++
 drivers/clk/Makefile                               |   1 +
 drivers/clk/metag/Makefile                         |   3 +
 drivers/clk/metag/clk-gate.c                       | 179 +++++++++++++++++
 drivers/clk/metag/clk-mux.c                        | 211 +++++++++++++++++++++
 6 files changed, 455 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/img,meta-gate-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/img,meta-mux-clock.txt
 create mode 100644 drivers/clk/metag/Makefile
 create mode 100644 drivers/clk/metag/clk-gate.c
 create mode 100644 drivers/clk/metag/clk-mux.c

-- 
1.8.1.2


