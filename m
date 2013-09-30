Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab3I3NXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:23:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13609 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab3I3NXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:23:30 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-5b-52497b509171
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] checkpatch: warn about incorrect __initdata placement
Date: Mon, 30 Sep 2013 15:23:11 +0200
Message-id: <1534354.yq7QTJSTju@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jQd2Aas8gg+lTNC0+rNWwmH3/MYvF
	2aY37BaXd81hc2DxmNXQy+bxZdU1Zo++LasYPT5vkgtgieKySUnNySxLLdK3S+DK+PdyClNB
	A0fFjRXNrA2Me9m6GDk5JARMJF4/egtli0lcuLceyObiEBKYziix93g7O4TTwiQxrWsfM0gV
	m4CVxMT2VYwgtoiAmsTdM91gcWaBHInXP9eDTRIWcJP413SHHcRmEVCV6JxzCayGV0BT4vrb
	SWC2qICnxKdJS6HighI/Jt9jgZgjL7Fv/1RWCFtLYv3O40wTGPlmISmbhaRsFpKyBYzMqxhF
	UwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCg/GZ1A7GlQ0WhxgFOBiVeHgnLPcIEmJNLCuuzD3E
	KMHBrCTCK17mGSTEm5JYWZValB9fVJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomD
	U6qBMcb/YsSnIIUjH91ifrr/3/MoNW9lJ/M0Sda1DYc311Wy2Mgaa1lVHfY7adn50kS9lGf3
	3T/Xj++9v+JOqsLVez/Y6nw+L7qUaLDlGtNVr94WRY2qPdpfvx28efXRm4VrV8nOrLslWyvP
	FjjLgKkhWvqS4Z2wJ1ybfl/guvC6wmJPVlvrnfsn+pVYijMSDbWYi4oTARZffXRCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 23d55bf..88d07a6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4275,6 +4275,12 @@ sub process {
 			WARN("EXPORTED_WORLD_WRITABLE",
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
+
+# check for incorrect __initdata placement
+		if ($line =~ /\bstruct\s+__initdata.*\=/) {
+			WARN("INITDATA_PLACEMENT",
+			     "__initdata tag should be placed between the variable name and equal sign\n" . $herecurr);
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
-- 
1.8.2.3


