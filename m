Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3B1BFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 20:05:47 -0500
Received: from relay1.sgi.com ([192.48.179.29]:35500 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab3B1BFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 20:05:44 -0500
Date: Wed, 27 Feb 2013 19:05:42 -0600
From: Nathan Zimmer <nzimmer@sgi.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Nathan Zimmer <nzimmer@sgi.com>, johnstul@us.ibm.com, tglx@linutronix.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] timer_list: split timer_list_show_tickdevices()
Message-ID: <20130228010542.GA12289@gulag1.americas.sgi.com>
References: <51267626.3030308@codeaurora.org> <1361921596-9636-1-git-send-email-nzimmer@sgi.com> <1361921596-9636-2-git-send-email-nzimmer@sgi.com> <512E6076.7070506@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512E6076.7070506@codeaurora.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 11:37:26AM -0800, Stephen Boyd wrote:
> On 02/26/13 15:33, Nathan Zimmer wrote:
> > @@ -246,12 +244,8 @@ static void timer_list_show_tickdevices(struct seq_file *m)
> >  #endif
> >  	SEQ_printf(m, "\n");
> >  #endif
> > -	for_each_online_cpu(cpu)
> > -		print_tickdevice(m, tick_get_device(cpu), cpu);
> >  	SEQ_printf(m, "\n");
> >  }
> 
> The duplicate newline is here again?
> 
> > -#else
> > -static void timer_list_show_tickdevices(struct seq_file *m) { }
> >  #endif
> >  
> >  static int timer_list_show(struct seq_file *m, void *v)
> >
> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 


I should have gotten this out quicker but I wanted to retest.

>From 26edd3e6c66f6eb3bb927695dd50920e1661060a Mon Sep 17 00:00:00 2001
From: Nathan Zimmer <nzimmer@sgi.com>
Date: Tue, 26 Feb 2013 09:05:26 -0600
Subject: [PATCH v4 1/2] timer_list: split timer_list_show_tickdevices()

Split timer_list_show_tickdevices() out the header and just pull the rest up
to timer_list_show.  Also tweak the location of the whitespace.  This is all
to prep for the fix.

v4: correct extra whitespace

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/time/timer_list.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index af5a7e9..380a589 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -133,7 +133,6 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
 
-	SEQ_printf(m, "\n");
 	SEQ_printf(m, "cpu: %d\n", cpu);
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		SEQ_printf(m, " clock %d:\n", i);
@@ -187,6 +186,7 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 
 #undef P
 #undef P_ns
+	SEQ_printf(m, "\n");
 }
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
@@ -195,7 +195,6 @@ print_tickdevice(struct seq_file *m, struct tick_device *td, int cpu)
 {
 	struct clock_event_device *dev = td->evtdev;
 
-	SEQ_printf(m, "\n");
 	SEQ_printf(m, "Tick Device: mode:     %d\n", td->mode);
 	if (cpu < 0)
 		SEQ_printf(m, "Broadcast device\n");
@@ -230,12 +229,11 @@ print_tickdevice(struct seq_file *m, struct tick_device *td, int cpu)
 	print_name_offset(m, dev->event_handler);
 	SEQ_printf(m, "\n");
 	SEQ_printf(m, " retries:        %lu\n", dev->retries);
+	SEQ_printf(m, "\n");
 }
 
-static void timer_list_show_tickdevices(struct seq_file *m)
+static void timer_list_show_tickdevices_header(struct seq_file *m)
 {
-	int cpu;
-
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 	print_tickdevice(m, tick_get_broadcast_device(), -1);
 	SEQ_printf(m, "tick_broadcast_mask: %08lx\n",
@@ -246,12 +244,7 @@ static void timer_list_show_tickdevices(struct seq_file *m)
 #endif
 	SEQ_printf(m, "\n");
 #endif
-	for_each_online_cpu(cpu)
-		print_tickdevice(m, tick_get_device(cpu), cpu);
-	SEQ_printf(m, "\n");
 }
-#else
-static void timer_list_show_tickdevices(struct seq_file *m) { }
 #endif
 
 static int timer_list_show(struct seq_file *m, void *v)
@@ -262,12 +255,16 @@ static int timer_list_show(struct seq_file *m, void *v)
 	SEQ_printf(m, "Timer List Version: v0.7\n");
 	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
 	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
+	SEQ_printf(m, "\n");
 
 	for_each_online_cpu(cpu)
 		print_cpu(m, cpu, now);
 
-	SEQ_printf(m, "\n");
-	timer_list_show_tickdevices(m);
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	timer_list_show_tickdevices_header(m);
+	for_each_online_cpu(cpu)
+		print_tickdevice(m, tick_get_device(cpu), cpu);
+#endif
 
 	return 0;
 }
-- 
1.8.1.2

