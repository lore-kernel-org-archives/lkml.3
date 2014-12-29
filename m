Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaL2UEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 15:04:16 -0500
Received: from www.osadl.org ([62.245.132.105]:46587 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaL2UEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 15:04:15 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Michael Hanselmann <linux-kernel@hansmi.ch>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] macintosh: ams: cleanup on stack DECLARE_COMPLETION
Date: Mon, 29 Dec 2014 14:59:44 -0500
Message-Id: <1419883184-412-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix-up for incorrect use of DECLARE_COMPLETION. see also commit
6e9a4738 ("completions: lockdep annotate on stack completions")

V2: split out patch for individual files and (hopefully) proper
    labeling this time

patch is against linux-next 3.19.0-rc1 -next-20141226

patch was compile tested with ppc6xx_defconfig, CONFIG_SENSORS_AMS=m,
CONFIG_SENSORS_AMS_PMU=y

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/macintosh/ams/ams-pmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/macintosh/ams/ams-pmu.c b/drivers/macintosh/ams/ams-pmu.c
index 4f61b3e..c2b178f 100644
--- a/drivers/macintosh/ams/ams-pmu.c
+++ b/drivers/macintosh/ams/ams-pmu.c
@@ -52,7 +52,7 @@ static void ams_pmu_req_complete(struct adb_request *req)
 static void ams_pmu_set_register(u8 reg, u8 value)
 {
 	static struct adb_request req;
-	DECLARE_COMPLETION(req_complete);
+	DECLARE_COMPLETION_ONSTACK(req_complete);
 
 	req.arg = &req_complete;
 	if (pmu_request(&req, ams_pmu_req_complete, 4, ams_pmu_cmd, 0x00, reg, value))
@@ -65,7 +65,7 @@ static void ams_pmu_set_register(u8 reg, u8 value)
 static u8 ams_pmu_get_register(u8 reg)
 {
 	static struct adb_request req;
-	DECLARE_COMPLETION(req_complete);
+	DECLARE_COMPLETION_ONSTACK(req_complete);
 
 	req.arg = &req_complete;
 	if (pmu_request(&req, ams_pmu_req_complete, 3, ams_pmu_cmd, 0x01, reg))
-- 
1.7.10.4

