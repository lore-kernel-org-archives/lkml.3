Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbaISLtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:49:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56331 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232AbaISLtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:49:09 -0400
Date: Fri, 19 Sep 2014 04:48:07 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-d3bfca1a7b028a57d648dbc0985492c6a4466ccf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, broonie@linaro.org, torvalds@linux-foundation.org,
        peterz@infradead.org, nicolas.pitre@linaro.org, linux@roeck-us.net,
        linux@arm.linux.org.uk, robh+dt@kernel.org, vincent.guittot@linaro.org,
        nico@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, broonie@linaro.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, linux@roeck-us.net, robh+dt@kernel.org,
        linux@arm.linux.org.uk, nico@linaro.org, vincent.guittot@linaro.org,
        tglx@linutronix.de
In-Reply-To: <1409051215-16788-6-git-send-email-vincent.guittot@linaro.org>
References: <1409051215-16788-6-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] ARM: topology:
  Use the new cpu_capacity interface
Git-Commit-ID: d3bfca1a7b028a57d648dbc0985492c6a4466ccf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3bfca1a7b028a57d648dbc0985492c6a4466ccf
Gitweb:     http://git.kernel.org/tip/d3bfca1a7b028a57d648dbc0985492c6a4466ccf
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Tue, 26 Aug 2014 13:06:48 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:27 +0200

ARM: topology: Use the new cpu_capacity interface

Use the new arch_scale_cpu_capacity() scheduler facility in order to reflect
the original capacity of a CPU instead of arch_scale_freq_capacity() which is
more linked to a scaling of the capacity linked to the frequency.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: preeti@linux.vnet.ibm.com
Cc: riel@redhat.com
Cc: Morten.Rasmussen@arm.com
Cc: efault@gmx.de
Cc: daniel.lezcano@linaro.org
Cc: dietmar.eggemann@arm.com
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@linaro.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/1409051215-16788-6-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm/kernel/topology.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index e35d880..89cfdd6 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -42,7 +42,7 @@
  */
 static DEFINE_PER_CPU(unsigned long, cpu_scale);
 
-unsigned long arch_scale_freq_capacity(struct sched_domain *sd, int cpu)
+unsigned long arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
 {
 	return per_cpu(cpu_scale, cpu);
 }
@@ -166,7 +166,7 @@ static void update_cpu_capacity(unsigned int cpu)
 	set_capacity_scale(cpu, cpu_capacity(cpu) / middle_capacity);
 
 	printk(KERN_INFO "CPU%u: update cpu_capacity %lu\n",
-		cpu, arch_scale_freq_capacity(NULL, cpu));
+		cpu, arch_scale_cpu_capacity(NULL, cpu));
 }
 
 #else
