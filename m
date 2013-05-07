Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab3EGE1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:27:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7252 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab3EGE0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:26:01 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=9RVMK01ZKXYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=-tgtV8mKT_MA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=lyTQiZhTPTvVCN06mPwA:9 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035850.102141403@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>
Subject: [055/126] udl: handle EDID failure properly.
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0055-udl-handle-EDID-failure-properly.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@gmail.com>

[ Upstream commit 1baee58638fc58248625255f5c5fcdb987f11b1f ]

Don't oops seems proper.

Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/udl/udl_connector.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/udl/udl_connector.c b/drivers/gpu/drm/udl/udl_connector.c
index 8d9dc44..2185ed8 100644
--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -56,6 +56,10 @@ static int udl_get_modes(struct drm_connector *connector)
 	int ret;
 
 	edid = (struct edid *)udl_get_edid(udl);
+	if (!edid) {
+		drm_mode_connector_update_edid_property(connector, NULL);
+		return 0;
+	}
 
 	connector->display_info.raw_edid = (char *)edid;
 
-- 
1.7.10.4


