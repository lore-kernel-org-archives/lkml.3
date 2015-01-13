Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbbALXNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:13:48 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:34442
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbbALXNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:13:46 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, hpa@zytor.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, stable <stable@vger.kernel.org>
Subject: [PATCH RESEND 1/1] X86: Mark the Hyper-V clocksource as being continuous
Date: Mon, 12 Jan 2015 16:26:02 -0800
Message-Id: <1421108762-3331-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hyper-V clocksource is continuous; mark it accordingly.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: stable <stable@vger.kernel.org>
---
 arch/x86/kernel/cpu/mshyperv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index a450373..939155f 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -107,6 +107,7 @@ static struct clocksource hyperv_cs = {
 	.rating		= 400, /* use this when running on Hyperv*/
 	.read		= read_hv_clock,
 	.mask		= CLOCKSOURCE_MASK(64),
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static void __init ms_hyperv_init_platform(void)
-- 
1.7.4.1

