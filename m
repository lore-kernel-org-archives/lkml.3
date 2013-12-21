Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab3LUKde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:33:34 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:39389 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab3LUKdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:33:33 -0500
Date: Sat, 21 Dec 2013 16:01:16 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kevin McKinney <klmckinney1@gmail.com>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Lilis Iskandar <veeableful@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        josh@joshtriplett.org
Subject: [PATCH 1/2] drivers: bcm: Mark functions as static in Qos.c
Message-ID: <20131221103116.GA3286@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions MatchSrcIpAddress(), MatchDestIpAddress() and MatchTos()
as static in Qos.c because they are not used outside this file.

This eliminates the following warnings in Qos.c:
drivers/staging/bcm/Qos.c:27:6: warning: no previous prototype for ‘MatchSrcIpAddress’ [-Wmissing-prototypes]
drivers/staging/bcm/Qos.c:61:6: warning: no previous prototype for ‘MatchDestIpAddress’ [-Wmissing-prototypes]
drivers/staging/bcm/Qos.c:94:6: warning: no previous prototype for ‘MatchTos’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/staging/bcm/Qos.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index 1609a2b..0727599 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -24,7 +24,7 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex);
 *
 * Returns     - TRUE(If address matches) else FAIL .
 *********************************************************************/
-bool MatchSrcIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULONG ulSrcIP)
+static bool MatchSrcIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULONG ulSrcIP)
 {
 	UCHAR ucLoopIndex = 0;
 
@@ -58,7 +58,7 @@ bool MatchSrcIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULONG ulSr
 *
 * Returns     - TRUE(If address matches) else FAIL .
 *********************************************************************/
-bool MatchDestIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULONG ulDestIP)
+static bool MatchDestIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULONG ulDestIP)
 {
 	UCHAR ucLoopIndex = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
@@ -91,7 +91,7 @@ bool MatchDestIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULONG ulD
 *
 * Returns     - TRUE(If address matches) else FAIL.
 **************************************************************************/
-bool MatchTos(struct bcm_classifier_rule *pstClassifierRule, UCHAR ucTypeOfService)
+static bool MatchTos(struct bcm_classifier_rule *pstClassifierRule, UCHAR ucTypeOfService)
 {
 
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
-- 
1.7.9.5

