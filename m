Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3D3Fj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 01:39:29 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54954 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab3D3Fj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 01:39:28 -0400
X-QQ-SSF: 00000000000000F0
X-QQ-BUSINESS-ORIGIN: 2
X-Originating-IP: 219.133.127.76
X-QQ-STYLE: 
X-QQ-mid: bizmail10t1367300360t2614654
From: "=?ISO-8859-1?B?cmVtYXBlcg==?=" <yp.fangdong@gmail.com>
To: "=?ISO-8859-1?B?bGludXgtZnNkZXZlbA==?=" 
	<linux-fsdevel@vger.kernel.org>,
        "=?ISO-8859-1?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>
Subject: generic_make_request not locked
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Date: Tue, 30 Apr 2013 13:39:20 +0800
X-Priority: 3
Message-ID: <tencent_0BD3EAC403C9DFE43143959B@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
X-QQ-FName: AE25DCE0E7F84218A4D87622E1CF637B
X-QQ-LocalIP: 112.95.241.173
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3U5dsSG021519

/*
 * We only want one ->make_request_fn to be active at a time,
 * else stack usage with stacked devices could be a problem.
 * So use current->bio_list to keep a list of requests
 * submited by a make_request_fn function.
 * current->bio_list is also used as a flag to say if
 * generic_make_request is currently active in this task or not.
 * If it is NULL, then no make_request is active.  If it is non-NULL,
 * then a make_request is active, and new requests should be added
 * at the tail
 */
void generic_make_request(struct bio *bio)
{
...
    if (current->bio_list) {
        /* make_request is active */
        bio_list_add(current->bio_list, bio);
        return;
    }
...
}

current->bio_list is a global variable, and generic_make_request would run on multithread environment, so, i don't understand why here( bio_list_add ) not lock?
thx everybody.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
