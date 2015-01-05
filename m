Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbbAELbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:31:43 -0500
Received: from smtprelay4.synopsys.com ([198.182.47.9]:51004 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbbAELbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:31:10 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <robh@kernel.org>, <jslaby@suse.cz>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v2 0/3] Early 8250 fixlets
Date: Mon, 5 Jan 2015 17:00:34 +0530
Message-ID: <1420457437-17636-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series addresses some of the issues seen on early 8250 uart when
working with ARC SDP platform.


Changes since v1 [1]
	-Rebased to linux-next of 20150105
	-Patch 3/3 SNAFU fixed (arch over-ride was not correct due to mix up
	 of orig work based off 3.13 vs. 3.19+ based linux next submission
	 (different core earlycon code)
Thx,
-Vineet

[1] http://www.spinics.net/lists/kernel/msg1893299.html

Vineet Gupta (3):
  serial: 8250_early: optimize early 8250 uart
  serial: 8250_early: prepare for dynamic BASE_BAUD
  ARC: runtime determine BASE_BAUD per machine

 arch/arc/include/asm/serial.h        | 24 ++++--------------------
 arch/arc/kernel/devtree.c            | 24 ++++++++++++++++++++++++
 drivers/tty/serial/8250/8250_early.c |  7 +++++--
 drivers/tty/serial/earlycon.c        | 13 +++++++++++--
 4 files changed, 44 insertions(+), 24 deletions(-)

-- 
1.9.1

