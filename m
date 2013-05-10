Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3EJRbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 13:31:53 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34260 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab3EJRbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 13:31:52 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC] User space clock driver
Date: Fri, 10 May 2013 10:31:30 -0700
Message-Id: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is there any interest in exposing clock controls to userspace?
On Zynq we need/want this for a couple of clocks which are forwarded to
the FPGA part of the chip, in case no real device driver is taking care
of the clocks.
Additionally I can see this help debugging here and there. E.g. it can
be used to trigger rate change notifications. Hence I started this as a
generic driver instead of limiting it to my primary Zynq use-case.

The current state allows me to control the FPGA clocks on Zynq (other
clocks should work as well), so the functionality is basically there,
but I appreciate all feedback on the implementation. I suspect there
are better/other ways to do this.

	Thanks,
	Sören

Soren Brinkmann (1):
  clk: Introduce userspace clock driver

 .../devicetree/bindings/clock/clk-userspace.txt    |   7 +
 drivers/clk/Kconfig                                |   9 ++
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-userspace.c                        | 169 +++++++++++++++++++++
 4 files changed, 186 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/clk-userspace.txt
 create mode 100644 drivers/clk/clk-userspace.c

-- 
1.8.2.3

