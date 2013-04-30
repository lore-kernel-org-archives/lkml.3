Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311Ab3D3LYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:24:42 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:48525 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760210Ab3D3LYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:24:41 -0400
X-QQ-SSF: 00000000000000F0
X-QQ-BUSINESS-ORIGIN: 2
X-Originating-IP: 218.18.229.64
X-QQ-STYLE: 
X-QQ-mid: bizmail10t1367321073t5401868
From: "=?ISO-8859-1?B?cmVtYXBlcg==?=" <yp.fangdong@gmail.com>
To: "=?ISO-8859-1?B?bGludXgtZnNkZXZlbA==?=" 
	<linux-fsdevel@vger.kernel.org>,
        "=?ISO-8859-1?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>
Subject: the rq_timed_out_fn for block device(hd)
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Date: Tue, 30 Apr 2013 19:24:33 +0800
X-Priority: 3
Message-ID: <tencent_792AA99D272B4F9025DC5D30@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3UBOlS6023072

my kernel version: linux 2.6.34.14

in block/blk-core.c file,  blk_alloc_queue_node() function:
struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
{
...
    setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
...
}

when bio request timeout, execute blk_rq_timed_out_timer() function, for each req in q->request_list, execute blk_rq_timed_out() function, this two function are defined in  blk-timeout.c file:


static void blk_rq_timed_out(struct request *req)
{
...
    ret = q->rq_timed_out_fn(req);
    switch (ret) {
...
    }
}

i can't find where the ->rq_timed_out_fn defined for block device, such as drivers/block/hd.c
but i can find that the ->rq_timed_out_fn for scsi device, in drivers/scsi/scsi_transport_fc.c, line 3965ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
