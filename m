Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbaFZRno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:43:44 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:49272 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756597AbaFZRnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:43:40 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqUHAI5arFNXQz8N/2dsb2JhbABagw2rSgEBAQEBAQUBbZh/AYEMF3WEBAEFJy8jEFE5HhmIRgHCKReFZIkcB4RDBZpZizqIO4NEOy8
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: wein@de.ibm.com, stefan.haberland@de.ibm.com,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 4/4] drivers/s390/block/dasd.c: replace seq_printf by seq_puts
Date: Thu, 26 Jun 2014 19:41:49 +0200
Message-Id: <1403804509-9565-5-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1403804509-9565-1-git-send-email-fabf@skynet.be>
References: <1403804509-9565-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warnings:
"WARNING: Prefer seq_puts to seq_printf"

Cc: Stefan Weinhuber <wein@de.ibm.com>
Cc: Stefan Haberland <stefan.haberland@de.ibm.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/s390/block/dasd.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index baae088..1e50626 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -976,37 +976,37 @@ static void dasd_stats_seq_print(struct seq_file *m,
 	seq_printf(m, "total_sectors %u\n", data->dasd_io_sects);
 	seq_printf(m, "total_pav %u\n", data->dasd_io_alias);
 	seq_printf(m, "total_hpf %u\n", data->dasd_io_tpm);
-	seq_printf(m, "histogram_sectors ");
+	seq_puts(m, "histogram_sectors ");
 	dasd_stats_array(m, data->dasd_io_secs);
-	seq_printf(m, "histogram_io_times ");
+	seq_puts(m, "histogram_io_times ");
 	dasd_stats_array(m, data->dasd_io_times);
-	seq_printf(m, "histogram_io_times_weighted ");
+	seq_puts(m, "histogram_io_times_weighted ");
 	dasd_stats_array(m, data->dasd_io_timps);
-	seq_printf(m, "histogram_time_build_to_ssch ");
+	seq_puts(m, "histogram_time_build_to_ssch ");
 	dasd_stats_array(m, data->dasd_io_time1);
-	seq_printf(m, "histogram_time_ssch_to_irq ");
+	seq_puts(m, "histogram_time_ssch_to_irq ");
 	dasd_stats_array(m, data->dasd_io_time2);
-	seq_printf(m, "histogram_time_ssch_to_irq_weighted ");
+	seq_puts(m, "histogram_time_ssch_to_irq_weighted ");
 	dasd_stats_array(m, data->dasd_io_time2ps);
-	seq_printf(m, "histogram_time_irq_to_end ");
+	seq_puts(m, "histogram_time_irq_to_end ");
 	dasd_stats_array(m, data->dasd_io_time3);
-	seq_printf(m, "histogram_ccw_queue_length ");
+	seq_puts(m, "histogram_ccw_queue_length ");
 	dasd_stats_array(m, data->dasd_io_nr_req);
 	seq_printf(m, "total_read_requests %u\n", data->dasd_read_reqs);
 	seq_printf(m, "total_read_sectors %u\n", data->dasd_read_sects);
 	seq_printf(m, "total_read_pav %u\n", data->dasd_read_alias);
 	seq_printf(m, "total_read_hpf %u\n", data->dasd_read_tpm);
-	seq_printf(m, "histogram_read_sectors ");
+	seq_puts(m, "histogram_read_sectors ");
 	dasd_stats_array(m, data->dasd_read_secs);
-	seq_printf(m, "histogram_read_times ");
+	seq_puts(m, "histogram_read_times ");
 	dasd_stats_array(m, data->dasd_read_times);
-	seq_printf(m, "histogram_read_time_build_to_ssch ");
+	seq_puts(m, "histogram_read_time_build_to_ssch ");
 	dasd_stats_array(m, data->dasd_read_time1);
-	seq_printf(m, "histogram_read_time_ssch_to_irq ");
+	seq_puts(m, "histogram_read_time_ssch_to_irq ");
 	dasd_stats_array(m, data->dasd_read_time2);
-	seq_printf(m, "histogram_read_time_irq_to_end ");
+	seq_puts(m, "histogram_read_time_irq_to_end ");
 	dasd_stats_array(m, data->dasd_read_time3);
-	seq_printf(m, "histogram_read_ccw_queue_length ");
+	seq_puts(m, "histogram_read_ccw_queue_length ");
 	dasd_stats_array(m, data->dasd_read_nr_req);
 }
 
@@ -1020,7 +1020,7 @@ static int dasd_stats_show(struct seq_file *m, void *v)
 	data = profile->data;
 	if (!data) {
 		spin_unlock_bh(&profile->lock);
-		seq_printf(m, "disabled\n");
+		seq_puts(m, "disabled\n");
 		return 0;
 	}
 	dasd_stats_seq_print(m, data);
@@ -1073,7 +1073,7 @@ static ssize_t dasd_stats_global_write(struct file *file,
 static int dasd_stats_global_show(struct seq_file *m, void *v)
 {
 	if (!dasd_global_profile_level) {
-		seq_printf(m, "disabled\n");
+		seq_puts(m, "disabled\n");
 		return 0;
 	}
 	dasd_stats_seq_print(m, &dasd_global_profile_data);
@@ -1176,7 +1176,7 @@ static void dasd_statistics_removeroot(void)
 
 int dasd_stats_generic_show(struct seq_file *m, void *v)
 {
-	seq_printf(m, "Statistics are not activated in this kernel\n");
+	seq_puts(m, "Statistics are not activated in this kernel\n");
 	return 0;
 }
 
-- 
1.8.4.5

