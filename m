Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab3EGEJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:09:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8035 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932992Ab3EGD6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:48 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=29mrlvBcXDgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=FId6TfzOcMcA:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035846.205157800@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Richard Guy Briggs <rbriggs@redhat.com>, Zhang Rui <rui.zhang@intel.com>
Subject: [032/126] thermal: return an error on failure to register thermal class
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0032-thermal-return-an-error-on-failure-to-register-therm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rbriggs@redhat.com>

[ Upstream commit da28d966f6aa942ae836d09729f76a1647932309 ]

The return code from the registration of the thermal class is used to
unallocate resources, but this failure isn't passed back to the caller of
thermal_init.  Return this failure back to the caller.

This bug was introduced in changeset 4cb18728 which overwrote the return code
when the variable was re-used to catch the return code of the registration of
the genetlink thermal socket family.

Signed-off-by: Richard Guy Briggs <rbriggs@redhat.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/thermal/thermal_sys.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 2ab31e4..03d203f 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1518,6 +1518,7 @@ static int __init thermal_init(void)
 		idr_destroy(&thermal_cdev_idr);
 		mutex_destroy(&thermal_idr_lock);
 		mutex_destroy(&thermal_list_lock);
+		return result;
 	}
 	result = genetlink_init();
 	return result;
-- 
1.7.10.4


