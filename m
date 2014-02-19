Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaBSSgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:36:03 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:34546 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaBSSfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:35:53 -0500
From: dirk.brandewie@gmail.com
To: rjw@rjwysocki.net
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH v2] intel_pstate: Use LFM bus ratio as min ratio/P state
Date: Wed, 19 Feb 2014 10:35:25 -0800
Message-Id: <1392834925-21648-1-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <5856987.3qKttR09W1@vostro.rjw.lan>
References: <5856987.3qKttR09W1@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

LFM (max efficiency ratio) is the max frequency at minimum voltage
supported by the processor.  Using LFM as the minimum P state
increases performmance without affecting power. By not using P states
below LFM we avoid using P states that are less power efficient.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index b80c03d..ff45ce1 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -356,7 +356,7 @@ static int byt_get_min_pstate(void)
 {
 	u64 value;
 	rdmsrl(BYT_RATIOS, value);
-	return value & 0xFF;
+	return (value >> 8) & 0xFF;
 }
 
 static int byt_get_max_pstate(void)
-- 
1.8.3.1

