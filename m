Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947662Ab3BIBIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:08:48 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:46021 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947640Ab3BIBIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:46 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 10/16] cpuidle: remove vestage definition of cpuidle_state_usage.driver_data
Date: Fri,  8 Feb 2013 20:08:14 -0500
Message-Id: <fe265459a3bbcfada267f181f00b83fb02f6d5cb.1360371180.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360372100-28482-1-git-send-email-lenb@kernel.org>
References: <1360372100-28482-1-git-send-email-lenb@kernel.org>
In-Reply-To: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
References: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

This field is no longer used.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/linux/cpuidle.h | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 24cd1037..480c14d 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -32,8 +32,6 @@ struct cpuidle_driver;
  ****************************/
 
 struct cpuidle_state_usage {
-	void		*driver_data;
-
 	unsigned long long	disable;
 	unsigned long long	usage;
 	unsigned long long	time; /* in US */
@@ -62,26 +60,6 @@ struct cpuidle_state {
 
 #define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
 
-/**
- * cpuidle_get_statedata - retrieves private driver state data
- * @st_usage: the state usage statistics
- */
-static inline void *cpuidle_get_statedata(struct cpuidle_state_usage *st_usage)
-{
-	return st_usage->driver_data;
-}
-
-/**
- * cpuidle_set_statedata - stores private driver state data
- * @st_usage: the state usage statistics
- * @data: the private data
- */
-static inline void
-cpuidle_set_statedata(struct cpuidle_state_usage *st_usage, void *data)
-{
-	st_usage->driver_data = data;
-}
-
 struct cpuidle_device {
 	unsigned int		registered:1;
 	unsigned int		enabled:1;
-- 
1.8.1.3.535.ga923c31

