Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbaANAzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:55:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaANA1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.10 55/62] intel_pstate: Add X86_FEATURE_APERFMPERF to cpu match parameters.
Date: Mon, 13 Jan 2014 16:27:20 -0800
Message-Id: <20140114002712.027849359@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit 6cbd7ee10e2842a3d1f9b60abede1c8f3d1f1130 upstream.

KVM environments do not support APERF/MPERF MSRs. intel_pstate cannot
operate without these registers.

The previous validity checks in intel_pstate_msrs_not_valid() are
insufficent in nested KVMs.

References: https://bugzilla.redhat.com/show_bug.cgi?id=1046317
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -516,7 +516,8 @@ static void intel_pstate_timer_func(unsi
 }
 
 #define ICPU(model, policy) \
-	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_ANY, (unsigned long)&policy }
+	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_APERFMPERF,\
+			(unsigned long)&policy }
 
 static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
 	ICPU(0x2a, default_policy),


