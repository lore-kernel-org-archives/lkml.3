Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaKJD26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 22:28:58 -0500
Received: from out4133-130.mail.aliyun.com ([42.120.133.130]:53169 "EHLO
	out4133-130.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184AbaKJD25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 22:28:57 -0500
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Nov 2014 22:28:57 EST
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r46d02004;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=4;RT=4;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Vlastimil Babka'" <vbabka@suse.cz>, "'P. Christeas'" <xrg@linux.gr>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>
References: <00a801cffbd8$434189b0$c9c49d10$@alibaba-inc.com> <1433036.WjB5pb09Zh@xorhgos3.pefnos> <545F3556.5000802@suse.cz>
In-Reply-To: <545F3556.5000802@suse.cz>
Subject: Re: Early test: hangs in mm/compact.c w. Linus's 12d7aacab56e9ef185c
Date: Mon, 10 Nov 2014 11:23:15 +0800
Message-ID: <00f301cffc95$ab4adad0$01e09070$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQLNGskR6DANUF8ZyPx3jvFQMc78ygEv7npMAmXqJP2aQkTUUA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > I guess this one would mitigate against Vlastmil's migration scanner issue,
> > wouldn't it?
> 
Nope, I wanted to see  if free pages are low enough.

> Please no, that's a wrong fix. The purpose of compaction is to make the
> high-order watermark meet, not give up.
> 
Yupe, have to spin.

--- a/mm/compaction.c	Sun Nov  9 12:02:59 2014
+++ b/mm/compaction.c	Mon Nov 10 11:12:07 2014
@@ -1074,6 +1074,8 @@ static int compact_finished(struct zone 
 	watermark = low_wmark_pages(zone);
 	watermark += (1 << cc->order);
 
+	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
+		return COMPACT_SKIPPED;
 	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
 		return COMPACT_CONTINUE;
 
--


