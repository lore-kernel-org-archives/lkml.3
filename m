Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaBGQVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:21:13 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:54428 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbaBGQVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:21:08 -0500
From: Fabrice GASNIER <fabrice.gasnier@st.com>
To: linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        jonathan.austin@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
        nico@linaro.org, sboyd@codeaurora.org, marc.zyngier@arm.com,
        ben.dooks@codethink.co.uk, vgupta@synopsys.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: maxime.coquelin@st.com
Subject: [RFC PATCH]  ARM: Enable imprecise external aborts earlier
Date: Fri,  7 Feb 2014 17:19:14 +0100
Message-Id: <1391789955-26927-1-git-send-email-fabrice.gasnier@st.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some HW / drivers like PCIe use imprecise aborts on ARM to detect ports
that are behind a switch, by using: hook_fault_code(16+6, ...);

At PCIe bus enumeration, imprecise aborts are not enabled. Imprecise
aborts are enabled late during bootup process, when userland
init starts. It seems unmasked later when starting userland init
process (e.g. when CPSR.A bit on arm is cleared). Aborts are deferred
until then.

Enable imprecise external aborts earlier during bootup.

Reference :
http://marc.info/?l=linux-arm-kernel&m=139118404708291&w=2

Fabrice Gasnier (1):
  ARM: Add imprecise abort enable/disable macro

 arch/arm/include/asm/irqflags.h |   33 +++++++++++++++++++++++++++++++++
 arch/arm/kernel/smp.c           |    1 +
 arch/arm/kernel/traps.c         |    4 ++++
 3 files changed, 38 insertions(+)

-- 
1.7.9.5

