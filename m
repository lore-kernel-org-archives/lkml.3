Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaAWTHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:07:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaAWTGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:06:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.12 25/27] ARM: 7934/1: DT/kernel: fix arch_match_cpu_phys_id to avoid erroneous match
Date: Thu, 23 Jan 2014 11:07:02 -0800
Message-Id: <20140123190651.325319682@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123190648.720195687@linuxfoundation.org>
References: <20140123190648.720195687@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

commit e44ef891e9e68b6ce7d3fd3bac73b7d5433050ae upstream.

The MPIDR contains specific bitfields(MPIDR.Aff{2..0}) which uniquely
identify a CPU, in addition to some non-identifying information and
reserved bits. The ARM cpu binding defines the 'reg' property to only
contain the affinity bits, and any cpu nodes with other bits set in
their 'reg' entry are skipped.

As such it is not necessary to mask the phys_id with MPIDR_HWID_BITMASK,
and doing so could lead to matching erroneous CPU nodes in the device
tree. This patch removes the masking of the physical identifier.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/devtree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -171,7 +171,7 @@ void __init arm_dt_init_cpu_maps(void)
 
 bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
 {
-	return (phys_id & MPIDR_HWID_BITMASK) == cpu_logical_map(cpu);
+	return phys_id == cpu_logical_map(cpu);
 }
 
 /**


