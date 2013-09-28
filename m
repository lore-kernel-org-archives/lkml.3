Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab3I1TPQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:15:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41549 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab3I1TPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:15:08 -0400
Date: Sat, 28 Sep 2013 21:15:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH -v1.1] x86, boot: Further compress CPUs bootup message
Message-ID: <20130928191500.GG5956@pd.tnic>
References: <20130927103802.GA4422@pd.tnic>
 <20130927143249.GD4422@pd.tnic>
 <20130927143554.GF4422@pd.tnic>
 <20130928082542.GA18198@gmail.com>
 <20130928102305.GA5956@pd.tnic>
 <20130928134449.GB26931@gmail.com>
 <20130928174749.GE5956@pd.tnic>
 <20130928175444.GA4402@gmail.com>
 <20130928180459.GF5956@pd.tnic>
 <20130928181236.GA4999@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130928181236.GA4999@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 08:12:36PM +0200, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@alien8.de> wrote:
> 
> > -			pr_info("Booting Node %3d, Processors:", node);
> > +			printk(KERN_INFO ".... node #%3d, CPUs:  ", node);
> 
> I think this should use %*s# and num_digits(node) as well?

How's that:

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

?

Btw, num_digits() needed to handle the val==0 case :)

---
From: Borislav Petkov <bp@suse.de>
Date: Sat, 28 Sep 2013 19:37:18 +0200
Subject: [PATCH -v1.2] x86, boot: Further compress CPUs bootup message

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

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/smpboot.c | 24 +++++++++++++++++++-----
 arch/x86/lib/misc.c       |  4 ++++
 kernel/smp.c              |  7 ++++++-
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index d41f3ba26ced..2a165580fa16 100644
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
index bc35cde9769f..0325603c6fd5 100644
--- a/arch/x86/lib/misc.c
+++ b/arch/x86/lib/misc.c
@@ -2,6 +2,10 @@ int num_digits(int val)
 {
 	int digits = 0;
 
+	/* Handle special case */
+	if (!val)
+		return 1;
+
 	while (val) {
 		val /= 10;
 		digits++;
diff --git a/kernel/smp.c b/kernel/smp.c
index 0564571dcdf7..f5768b0c816a 100644
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
 
-- 
1.8.4



-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
