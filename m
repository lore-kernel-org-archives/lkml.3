Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878Ab3LBVYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:24:05 -0500
Received: from smtprelay0197.hostedemail.com ([216.40.44.197]:44575 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758055Ab3LBVYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:24:01 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3867:3870:3873:4605:5007:6119:7652:7809:8660:10004:10400:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:13069:13148:13161:13229:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: low12_3ffd60f955c16
X-Filterd-Recvd-Size: 2155
Message-ID: <1386019438.2680.32.camel@joe-AO722>
Subject: checkpatch not warning for some split strings
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Date: Mon, 02 Dec 2013 13:23:58 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Josh.

Back when you added commit ca56dc098ca
("checkpatch: check for quoted strings broken across lines")

You added this test case:

    Test case:
    
    void context(void)
    {
        struct { unsigned magic; const char *strdata; } foo[] = {
                { 42, "these strings"
                      "do not produce warnings" },
                { 256, "though perhaps"
                       "they should" },
        };

which avoids emitting a warning on split strings across
multiple lines without a function-call like '(' use on
the line above.

Perhaps the "\(" test should be removed as checkpatch
doesn't emit a warning for some uses like:

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
[]
@@ -1868,7 +1865,8 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
                /* Else poor success; go back to mode in "active" table */
                } else {
                        IWL_DEBUG_RATE(mvm,
-                                      "LQ: GOING BACK TO THE OLD TABLE suc=%d cur-tpt=%d old-tpt=%d\n",
+                                      "GOING BACK TO THE OLD TABLE: SR %d "
+                                      "cur-tpt %d old-tpt %d\n",
                                       window->success_ratio,
                                       window->average_tpt,
                                       lq_sta->last_tpt);


