Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaLRDuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 22:50:11 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:15127 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbaLRDuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 22:50:09 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'minchan@kernel.org'" <minchan@kernel.org>,
        "'Konstantin Khlebnikov'" <koct9i@gmail.com>,
        "'Kirill A. Shutemov'" <kirill@shutemov.name>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'n-horiguchi@ah.jp.nec.com'" <n-horiguchi@ah.jp.nec.com>
Date: Thu, 18 Dec 2014 11:50:01 +0800
Subject: [RFC] MADV_FREE doesn't work when doesn't have swap partition
Thread-Topic: [RFC] MADV_FREE doesn't work when doesn't have swap partition
Thread-Index: AdAUm5skPt4e77aMQROTaYv2A3+JEABH+XSwAS5N5DA=
Message-ID: <35FD53F367049845BC99AC72306C23D103EDAF89E14C@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
	<CALYGNiOuBKz8shHSrFCp0BT5AV6XkNOCHj+LJedQQ-2YdZtM7w@mail.gmail.com>
	<35FD53F367049845BC99AC72306C23D103E688B313F2@CNBJMBX05.corpusers.net>
	<20141205143134.37139da2208c654a0d3cd942@linux-foundation.org>
	<35FD53F367049845BC99AC72306C23D103E688B313F4@CNBJMBX05.corpusers.net>
	<20141208114601.GA28846@node.dhcp.inet.fi>
	<35FD53F367049845BC99AC72306C23D103E688B313FB@CNBJMBX05.corpusers.net>
 <CALYGNiMEytHuND37f+hNdMKqCPzN0k_uha6CaeL_fyzrj-obNQ@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E688B31408@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E688B31408@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBI3oct1014587

I notice this commit:
mm: support madvise(MADV_FREE),

it can free clean anonymous pages directly,
doesn't need pageout to swap partition,

but I found it doesn't work on my platform,
which don't enable any swap partitions.

I make a change for this.
Just to explain my issue clearly,
Do we need some other checks to still scan anonymous pages even
Don't have swap partition but have clean anonymous pages?
---
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5e8772b..8258f3a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1941,7 +1941,7 @@ static void get_scan_count(struct lruvec *lruvec, int swappiness,
                force_scan = true;

        /* If we have no swap space, do not bother scanning anon pages. */
-       if (!sc->may_swap || (get_nr_swap_pages() <= 0)) {
+       if (!sc->may_swap) {
                scan_balance = SCAN_FILE;
                goto out;
        }
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
