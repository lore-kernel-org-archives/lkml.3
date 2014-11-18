Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaKRJKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:10:49 -0500
Received: from mout.web.de ([212.227.15.4]:60113 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbaKRJKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:10:47 -0500
Message-ID: <546B0D08.2070305@users.sourceforge.net>
Date: Tue, 18 Nov 2014 10:10:32 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Benny Halevy <bhalevy@primarydata.com>,
        Boaz Harrosh <bharrosh@panasas.com>, osd-dev@open-osd.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] exofs: Deletion of an unnecessary check before the function
 call "ore_put_io_state"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:c1V3A9XX5bvXaFm9SWl3lwJhExbgb1gL8v9He0cW2Lgbp4Jn6RK
 2Ve5o7OaunxV3xCZ6HUlPiG05+e8ovcCEY91l+ge0x0aEEKYui/s/i4q3m+WDjUC9qRHxxq
 38iDmn4O44PasXyAgrQs3Sc8YxVT8O/0JuOCrd3QjIVTD7eSaCt3h54ShSws7Jm6mJKEJ+W
 Dcwr0Lh8FM1Rs4Uhh2lEQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 18 Nov 2014 10:05:19 +0100

The ore_put_io_state() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/exofs/ore_raid.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/exofs/ore_raid.c b/fs/exofs/ore_raid.c
index 84529b8..5dc7c4c 100644
--- a/fs/exofs/ore_raid.c
+++ b/fs/exofs/ore_raid.c
@@ -716,6 +716,5 @@ void _ore_free_raid_stuff(struct ore_io_state *ios)
 		if (ios->extra_part_alloc)
 			kfree(ios->per_dev[0].sglist);
 	}
-	if (ios->ios_read_4_write)
-		ore_put_io_state(ios->ios_read_4_write);
+	ore_put_io_state(ios->ios_read_4_write);
 }
-- 
2.1.3

