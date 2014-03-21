Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900AbaCUAGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:06:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760537AbaCUAFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:05:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.13 142/149] intel_pstate: Add support for Baytrail turbo P states
Date: Thu, 20 Mar 2014 17:05:05 -0700
Message-Id: <20140321000441.879183766@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit 61d8d2abc15e9232c3914c55502b73e559366583 upstream.

A documentation update exposed the existance of the turbo ratio
register. Update baytrail support to use the turbo range.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -34,8 +34,10 @@
 
 #define SAMPLE_COUNT		3
 
-#define BYT_RATIOS	0x66a
-#define BYT_VIDS        0x66b
+#define BYT_RATIOS		0x66a
+#define BYT_VIDS		0x66b
+#define BYT_TURBO_RATIOS	0x66c
+
 
 #define FRAC_BITS 8
 #define int_tofp(X) ((int64_t)(X) << FRAC_BITS)
@@ -367,6 +369,13 @@ static int byt_get_max_pstate(void)
 	return (value >> 16) & 0xFF;
 }
 
+static int byt_get_turbo_pstate(void)
+{
+	u64 value;
+	rdmsrl(BYT_TURBO_RATIOS, value);
+	return value & 0x3F;
+}
+
 static void byt_set_pstate(struct cpudata *cpudata, int pstate)
 {
 	u64 val;
@@ -469,7 +478,7 @@ static struct cpu_defaults byt_params =
 	.funcs = {
 		.get_max = byt_get_max_pstate,
 		.get_min = byt_get_min_pstate,
-		.get_turbo = byt_get_max_pstate,
+		.get_turbo = byt_get_turbo_pstate,
 		.set = byt_set_pstate,
 		.get_vid = byt_get_vid,
 	},


