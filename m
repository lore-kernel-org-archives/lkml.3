Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099AbaJ1DxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:53:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933895AbaJ1Dwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:52:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nathalie Cyrille <nathalie.cyrille@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3.10 42/43] ARM: at91/PMC: dont forget to write PMC_PCDR register to disable clocks
Date: Tue, 28 Oct 2014 11:36:40 +0800
Message-Id: <20141028033525.214451684@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033523.407092670@linuxfoundation.org>
References: <20141028033523.407092670@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ludovic Desroches <ludovic.desroches@atmel.com>

commit cfa1950e6c6b72251e80adc736af3c3d2907ab0e upstream.

When introducing support for sama5d3, the write to PMC_PCDR register has
been accidentally removed.

Reported-by: Nathalie Cyrille <nathalie.cyrille@atmel.com>
Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/clock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -947,6 +947,7 @@ static int __init at91_clock_reset(void)
 	}
 
 	at91_pmc_write(AT91_PMC_SCDR, scdr);
+	at91_pmc_write(AT91_PMC_PCDR, pcdr);
 	if (cpu_is_sama5d3())
 		at91_pmc_write(AT91_PMC_PCDR1, pcdr1);
 


