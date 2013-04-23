Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab3DWWPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:15:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507Ab3DWVwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:52:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lingzhu Xiang <lxiang@redhat.com>
Subject: [ 18/42] ARM: i.MX35: enable MAX clock
Date: Tue, 23 Apr 2013 14:52:16 -0700
Message-Id: <20130423215207.403759053@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 5dc2eb7da1e387e31ce54f54af580c6a6f512ca6 upstream.

The i.MX35 has two bits per clock gate which are decoded as follows:
      0b00 -> clock off
      0b01 -> clock is on in run mode, off in wait/doze
      0b10 -> clock is on in run/wait mode, off in doze
      0b11 -> clock is always on

The reset value for the MAX clock is 0b10.

The MAX clock is needed by the SoC, yet unused in the Kernel, so the
common clock framework will disable it during late init time. It will
only disable clocks though which it detects as being turned on. This
detection is made depending on the lower bit of the gate. If the reset
value has been altered by the bootloader to 0b11 the clock framework
will detect the clock as turned on, yet unused, hence it will turn it
off and the system locks up.

This patch turns the MAX clock on unconditionally making the Kernel
independent of the bootloader.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/clk-imx35.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-imx/clk-imx35.c
+++ b/arch/arm/mach-imx/clk-imx35.c
@@ -265,6 +265,7 @@ int __init mx35_clocks_init()
 	clk_prepare_enable(clk[gpio3_gate]);
 	clk_prepare_enable(clk[iim_gate]);
 	clk_prepare_enable(clk[emi_gate]);
+	clk_prepare_enable(clk[max_gate]);
 
 	/*
 	 * SCC is needed to boot via mmc after a watchdog reset. The clock code


