Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbaFYWH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:07:29 -0400
Received: from exprod5og119.obsmtp.com ([64.18.0.189]:50566 "HELO
	exprod5og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754214AbaFYWH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:07:28 -0400
From: Feng Kan <fkan@apm.com>
To: tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org, patches@apm.com
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH v2 0/2] irqchip: gic: Add support for GIC v2 bypass disable
Date: Wed, 25 Jun 2014 15:07:19 -0700
Message-Id: <1403734041-5112-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up hex number in the gic driver and then adds
the code to preserve GIC v2 bypass disable bits in the GIC driver.

V2 Change:
	seem my send email was not working correctly, resending this with
        rebase pull.
	- had to pull HaoJian's change out of arm-gic.h to keep consistency.
	- replace GIC defines as noted by Marc
	- remove GIC_CPU_DISABLE since it no longer used.
	- fix gic_cpu_if_down as noted by Marc

PM path gic cpu ctrl register restore is not added here, I will have to 
test that seperately once all the PM code is fully in place and submit it
afterward.

Feng Kan (2):
  irqchip: gic: replace hex numbers with defines.
  irqchip: gic: preserve gic V2 bypass bits in cpu ctrl register

 drivers/irqchip/irq-gic.c | 82 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 62 insertions(+), 20 deletions(-)

-- 
1.9.1

