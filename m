Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaLZL44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 06:56:56 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:7956 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbaLZL4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 06:56:53 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'minchan@kernel.org'" <minchan@kernel.org>,
        "'Konstantin Khlebnikov'" <koct9i@gmail.com>,
        "'Kirill A. Shutemov'" <kirill@shutemov.name>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'n-horiguchi@ah.jp.nec.com'" <n-horiguchi@ah.jp.nec.com>,
        "'pintu.k@samsung.com'" <pintu.k@samsung.com>
Date: Fri, 26 Dec 2014 19:56:49 +0800
Subject: [RFC] mm:change meminfo cached calculation
Thread-Topic: [RFC] mm:change meminfo cached calculation
Thread-Index: AdAUm5skPt4e77aMQROTaYv2A3+JEABH+XSwAS5N5DABo3oMAA==
Message-ID: <35FD53F367049845BC99AC72306C23D103EDAF89E160@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
	<CALYGNiOuBKz8shHSrFCp0BT5AV6XkNOCHj+LJedQQ-2YdZtM7w@mail.gmail.com>
	<35FD53F367049845BC99AC72306C23D103E688B313F2@CNBJMBX05.corpusers.net>
	<20141205143134.37139da2208c654a0d3cd942@linux-foundation.org>
	<35FD53F367049845BC99AC72306C23D103E688B313F4@CNBJMBX05.corpusers.net>
	<20141208114601.GA28846@node.dhcp.inet.fi>
	<35FD53F367049845BC99AC72306C23D103E688B313FB@CNBJMBX05.corpusers.net>
 <CALYGNiMEytHuND37f+hNdMKqCPzN0k_uha6CaeL_fyzrj-obNQ@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E688B31408@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103EDAF89E14C@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103EDAF89E14C@CNBJMBX05.corpusers.net>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBQBvEhX010931

This patch subtract sharedram from cached,
sharedram can only be swap into swap partitions,
they should be treated as swap pages, not as cached pages.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 fs/proc/meminfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index d3ebf2e..2b598a6 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -45,7 +45,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	committed = percpu_counter_read_positive(&vm_committed_as);
 
 	cached = global_page_state(NR_FILE_PAGES) -
-			total_swapcache_pages() - i.bufferram;
+			total_swapcache_pages() - i.bufferram - i.sharedram;
 	if (cached < 0)
 		cached = 0;
 
-- 
2.1.3
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
