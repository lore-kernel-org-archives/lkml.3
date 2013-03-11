Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab3CKQQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:16:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:47184 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab3CKQQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:16:51 -0400
X-IronPort-AV: E=Sophos;i="4.84,824,1355097600"; 
   d="scan'208,223";a="11828575"
Message-ID: <513E036B.5020001@citrix.com>
Date: Mon, 11 Mar 2013 16:16:43 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] xen-blkback: Change statistics counter types to unsigned
References: <1362506372-19079-1-git-send-email-zoltan.kiss@citrix.com> <20130308184301.GA31104@phenom.dumpdata.com>
In-Reply-To: <20130308184301.GA31104@phenom.dumpdata.com>
Content-Type: multipart/mixed;
	boundary="------------090604020808080304060402"
X-Originating-IP: [10.80.2.133]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------090604020808080304060402
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit

Done, just sent in in separate mail.

On 08/03/13 18:43, Konrad Rzeszutek Wilk wrote:
> On Tue, Mar 05, 2013 at 05:59:32PM +0000, Zoltan Kiss wrote:
>> These values shouldn't be negative, but after an overflow their value
>> can turn into negative, if they are signed. xentop can show bogus
>> values in this case.
>
> I get this during compilation:
>
> /home/konrad/linux/drivers/block/xen-blkback/xenbus.c: In function ‘show_oo_req’:
> /home/konrad/linux/drivers/block/xen-blkback/xenbus.c:233: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
> /home/konrad/linux/drivers/block/xen-blkback/xenbus.c: In function ‘show_rd_req’:
> /home/konrad/linux/drivers/block/xen-blkback/xenbus.c:234: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
> /home/konrad/linux/drivers/block/xen-blkback/xenbus.c: In function ‘show_wr_req’:
> /home/konrad/linux/drivers/block/xen-blkback/xenbus.c:235: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
> /home/konrad/linux/drivers/block/xen-blkback/xenbus.c: In function ‘show_f_req’:
> /home/konrad/linux/drivers/block/xen-blkback/xenbus.c:236: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
> /home/konrad/linux/drivers/block/xen-blkback/xenbus.c: In function ‘show_ds_req’:
> /home/konrad/linux/drivers/block/xen-blkback/xenbus.c:237: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
> /home/konrad/linux/drivers/block/xen-blkback/xenbus.c: In function ‘show_rd_sect’:
> /home/konrad/linux/drivers/block/xen-blkback/xenbus.c:238: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
> /home/konrad/linux/drivers/block/xen-blkback/xenbus.c: In function ‘show_wr_sect’:
> /home/konrad/linux/drivers/block/xen-blkback/xenbus.c:239: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
>    CC      block/bsg-lib.o
>    CC      mm/dmapool.o
>    CC      kernel/debug/debug_core.o
>    CC      mm/hugetlb.o
>    CC      mm/mempolicy.o
>    CC      drivers/acpi/sleep.o
> /home/konrad/linux/drivers/block/xen-blkback/blkback.c: In function ‘print_stats’:
> /home/konrad/linux/drivers/block/xen-blkback/blkback.c:384: warning: format ‘%3d’ expects type ‘int’, but argument 3 has type ‘long long unsigned int’
> /home/konrad/linux/drivers/block/xen-blkback/blkback.c:384: warning: format ‘%4d’ expects type ‘int’, but argument 4 has type ‘long long unsigned int’
> /home/konrad/linux/drivers/block/xen-blkback/blkback.c:384: warning: format ‘%4d’ expects type ‘int’, but argument 5 has type ‘lo
>
> Could you fix it up please as one big patch if possible?
>
>>
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>> Reported-by: Ichiro Ogino <ichiro.ogino@citrix.co.jp>
>> ---
>>   drivers/block/xen-blkback/common.h |   14 +++++++-------
>>   1 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
>> index 6072390..72d09ac 100644
>> --- a/drivers/block/xen-blkback/common.h
>> +++ b/drivers/block/xen-blkback/common.h
>> @@ -208,13 +208,13 @@ struct xen_blkif {
>>
>>   	/* statistics */
>>   	unsigned long		st_print;
>> -	int			st_rd_req;
>> -	int			st_wr_req;
>> -	int			st_oo_req;
>> -	int			st_f_req;
>> -	int			st_ds_req;
>> -	int			st_rd_sect;
>> -	int			st_wr_sect;
>> +	unsigned long long			st_rd_req;
>> +	unsigned long long			st_wr_req;
>> +	unsigned long long			st_oo_req;
>> +	unsigned long long			st_f_req;
>> +	unsigned long long			st_ds_req;
>> +	unsigned long long			st_rd_sect;
>> +	unsigned long long			st_wr_sect;
>>
>>   	wait_queue_head_t	waiting_to_free;
>>   };
>> --
>> 1.7.0.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>


--------------090604020808080304060402
Content-Type: text/x-patch;
	name="0001-xen-blkback-Change-statistics-counter-types-to-unsig.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-xen-blkback-Change-statistics-counter-types-to-unsig.pa";
	filename*1="tch"

>From a7e938cfd0685285d807697feb1742784101a6c5 Mon Sep 17 00:00:00 2001
From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Mon, 11 Mar 2013 15:52:17 +0000
Subject: [PATCH 1/1] xen-blkback: Change statistics counter types to unsigned

These values shouldn't be negative, but after an overflow their value
can turn into negative, if they are signed. xentop can show bogus
values in this case.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Reported-by: Ichiro Ogino <ichiro.ogino@citrix.co.jp>
---
 drivers/block/xen-blkback/blkback.c |    4 ++--
 drivers/block/xen-blkback/common.h  |   14 +++++++-------
 drivers/block/xen-blkback/xenbus.c  |   14 +++++++-------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index de1f319..75740f9 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -381,8 +381,8 @@ irqreturn_t xen_blkif_be_int(int irq, void *dev_id)
 
 static void print_stats(struct xen_blkif *blkif)
 {
-	pr_info("xen-blkback (%s): oo %3d  |  rd %4d  |  wr %4d  |  f %4d"
-		 "  |  ds %4d\n",
+	pr_info("xen-blkback (%s): oo %3llu  |  rd %4llu  |  wr %4llu  |  f %4llu"
+		 "  |  ds %4llu\n",
 		 current->comm, blkif->st_oo_req,
 		 blkif->st_rd_req, blkif->st_wr_req,
 		 blkif->st_f_req, blkif->st_ds_req);
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 6072390..72d09ac 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -208,13 +208,13 @@ struct xen_blkif {
 
 	/* statistics */
 	unsigned long		st_print;
-	int			st_rd_req;
-	int			st_wr_req;
-	int			st_oo_req;
-	int			st_f_req;
-	int			st_ds_req;
-	int			st_rd_sect;
-	int			st_wr_sect;
+	unsigned long long			st_rd_req;
+	unsigned long long			st_wr_req;
+	unsigned long long			st_oo_req;
+	unsigned long long			st_f_req;
+	unsigned long long			st_ds_req;
+	unsigned long long			st_rd_sect;
+	unsigned long long			st_wr_sect;
 
 	wait_queue_head_t	waiting_to_free;
 };
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 5e237f6..8bfd1bc 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -230,13 +230,13 @@ int __init xen_blkif_interface_init(void)
 	}								\
 	static DEVICE_ATTR(name, S_IRUGO, show_##name, NULL)
 
-VBD_SHOW(oo_req,  "%d\n", be->blkif->st_oo_req);
-VBD_SHOW(rd_req,  "%d\n", be->blkif->st_rd_req);
-VBD_SHOW(wr_req,  "%d\n", be->blkif->st_wr_req);
-VBD_SHOW(f_req,  "%d\n", be->blkif->st_f_req);
-VBD_SHOW(ds_req,  "%d\n", be->blkif->st_ds_req);
-VBD_SHOW(rd_sect, "%d\n", be->blkif->st_rd_sect);
-VBD_SHOW(wr_sect, "%d\n", be->blkif->st_wr_sect);
+VBD_SHOW(oo_req,  "%llu\n", be->blkif->st_oo_req);
+VBD_SHOW(rd_req,  "%llu\n", be->blkif->st_rd_req);
+VBD_SHOW(wr_req,  "%llu\n", be->blkif->st_wr_req);
+VBD_SHOW(f_req,  "%llu\n", be->blkif->st_f_req);
+VBD_SHOW(ds_req,  "%llu\n", be->blkif->st_ds_req);
+VBD_SHOW(rd_sect, "%llu\n", be->blkif->st_rd_sect);
+VBD_SHOW(wr_sect, "%llu\n", be->blkif->st_wr_sect);
 
 static struct attribute *xen_vbdstat_attrs[] = {
 	&dev_attr_oo_req.attr,
-- 
1.7.0.4


--------------090604020808080304060402--
