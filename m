Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3JAJLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:11:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3JAJLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:11:15 -0400
Date: Tue, 1 Oct 2013 02:10:30 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-a17bce4d1dce8f3cf714bc2e5d8e4bac009dc077@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, bp@alien8.de,
        akpm@linux-foundation.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, bp@alien8.de,
        akpm@linux-foundation.org, tglx@linutronix.de, bp@suse.de
In-Reply-To: <20130930095624.GB16383@pd.tnic>
References: <20130930095624.GB16383@pd.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86/boot: Further compress CPUs bootup message
Git-Commit-ID: a17bce4d1dce8f3cf714bc2e5d8e4bac009dc077
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 01 Oct 2013 02:10:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a17bce4d1dce8f3cf714bc2e5d8e4bac009dc077
Gitweb:     http://git.kernel.org/tip/a17bce4d1dce8f3cf714bc2e5d8e4bac009dc077
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Mon, 30 Sep 2013 11:56:24 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 1 Oct 2013 10:52:30 +0200

x86/boot: Further compress CPUs bootup message

Turn it into (for example):

[    0.073380] x86: Booting SMP configuration:
[    0.074005] .... node   #0, CPUs:          #1   #2   #3   #4   #5   #6   #7
[    0.603005] .... node   #1, CPUs:     #8   #9  #10  #11  #12  #13  #14  #15
[    1.200005] .... node   #2, CPUs:    #16  #17  #18  #19  #20  #21  #22  #23
[    1.796005] .... node   #3, CPUs:    #24  #25  #26  #27  #28  #29  #30  #31
[    2.393005] .... node   #4, CPUs:    #32  #33  #34  #35  #36  #37  #38  #39
[    2.996005] .... node   #5, CPUs:    #40  #41  #42  #43  #44  #45  #46  #47
[    3.600005] .... node   #6, CPUs:    #48  #49  #50  #51  #52  #53  #54  #55
[    4.202005] .... node   #7, CPUs:    #56  #57  #58  #59  #60  #61  #62  #63
[    4.811005] .... node   #8, CPUs:    #64  #65  #66  #67  #68  #69  #70  #71
[    5.421006] .... node   #9, CPUs:    #72  #73  #74  #75  #76  #77  #78  #79
[    6.032005] .... node  #10, CPUs:    #80  #81  #82  #83  #84  #85  #86  #87
[    6.648006] .... node  #11, CPUs:    #88  #89  #90  #91  #92  #93  #94  #95
[    7.262005] .... node  #12, CPUs:    #96  #97  #98  #99 #100 #101 #102 #103
[    7.865005] .... node  #13, CPUs:   #104 #105 #106 #107 #108 #109 #110 #111
[    8.466005] .... node  #14, CPUs:   #112 #113 #114 #115 #116 #117 #118 #119
[    9.073006] .... node  #15, CPUs:   #120 #121 #122 #123 #124 #125 #126 #127
[    9.679901] x86: Booted up 16 nodes, 128 CPUs

and drop useless elements.

Change num_digits() to hpa's division-avoiding, cell-phone-typed
version which he went at great lengths and pains to submit on a
Saturday evening.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: huawei.libin@huawei.com
Cc: wangyijing@huawei.com
Cc: fenghua.yu@intel.com
Cc: guohanjun@huawei.com
Cc: paul.gortmaker@windriver.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130930095624.GB16383@pd.tnic
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c | 24 +++++++++++++++++++-----
 arch/x86/lib/misc.c       | 20 +++++++++++++++-----
 kernel/smp.c              |  7 ++++++-
 3 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index d41f3ba..2a16558 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -647,22 +647,38 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 	return (send_status | accept_status);
 }
 
+void smp_announce(void)
+{
+	int num_nodes = num_online_nodes();
+
+	printk(KERN_INFO "x86: Booted up %d node%s, %d CPUs\n",
+	       num_nodes, (num_nodes > 1 ? "s" : ""), num_online_cpus());
+}
+
 /* reduce the number of lines printed when booting a large cpu count system */
 static void announce_cpu(int cpu, int apicid)
 {
 	static int current_node = -1;
 	int node = early_cpu_to_node(cpu);
-	static int width;
+	static int width, node_width;
 
 	if (!width)
 		width = num_digits(num_possible_cpus()) + 1; /* + '#' sign */
 
+	if (!node_width)
+		node_width = num_digits(num_possible_nodes()) + 1; /* + '#' */
+
+	if (cpu == 1)
+		printk(KERN_INFO "x86: Booting SMP configuration:\n");
+
 	if (system_state == SYSTEM_BOOTING) {
 		if (node != current_node) {
 			if (current_node > (-1))
-				pr_cont(" OK\n");
+				pr_cont("\n");
 			current_node = node;
-			pr_info("Booting Node %3d, Processors:", node);
+
+			printk(KERN_INFO ".... node %*s#%d, CPUs:  ",
+			       node_width - num_digits(node), " ", node);
 		}
 
 		/* Add padding for the BSP */
@@ -671,8 +687,6 @@ static void announce_cpu(int cpu, int apicid)
 
 		pr_cont("%*s#%d", width - num_digits(cpu), " ", cpu);
 
-		if (cpu == num_present_cpus() - 1)
-			pr_cont(" OK\n");
 	} else
 		pr_info("Booting Node %d Processor %d APIC 0x%x\n",
 			node, cpu, apicid);
diff --git a/arch/x86/lib/misc.c b/arch/x86/lib/misc.c
index bc35cde..76b373a 100644
--- a/arch/x86/lib/misc.c
+++ b/arch/x86/lib/misc.c
@@ -1,11 +1,21 @@
+/*
+ * Count the digits of @val including a possible sign.
+ *
+ * (Typed on and submitted from hpa's mobile phone.)
+ */
 int num_digits(int val)
 {
-	int digits = 0;
+	int m = 10;
+	int d = 1;
 
-	while (val) {
-		val /= 10;
-		digits++;
+	if (val < 0) {
+		d++;
+		val = -val;
 	}
 
-	return digits;
+	while (val >= m) {
+		m *= 10;
+		d++;
+	}
+	return d;
 }
diff --git a/kernel/smp.c b/kernel/smp.c
index 0564571..f5768b0 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -524,6 +524,11 @@ void __init setup_nr_cpu_ids(void)
 	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
 }
 
+void __weak smp_announce(void)
+{
+	printk(KERN_INFO "Brought up %d CPUs\n", num_online_cpus());
+}
+
 /* Called by boot processor to activate the rest. */
 void __init smp_init(void)
 {
@@ -540,7 +545,7 @@ void __init smp_init(void)
 	}
 
 	/* Any cleanup work */
-	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
+	smp_announce();
 	smp_cpus_done(setup_max_cpus);
 }
 
