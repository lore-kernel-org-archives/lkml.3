Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaKLWdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:33:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbaKLWdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:33:44 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        andi@firstfloor.org, rientjes@google.com, riel@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org, davidlohr@hp.com
Subject: [PATCH 1/3] hugetlb: fix hugepages= entry in kernel-parameters.txt
Date: Wed, 12 Nov 2014 17:33:11 -0500
Message-Id: <1415831593-9020-2-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1415831593-9020-1-git-send-email-lcapitulino@redhat.com>
References: <1415831593-9020-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hugepages= entry in kernel-parameters.txt states that
1GB pages can only be allocated at boot time and not
freed afterwards. This is not true since commit
944d9fec8d7aee, at least for x86_64.

Instead of adding arch-specifc observations to the
hugepages= entry, this commit just drops the out of date
information. Further information about arch-specific
support and available features can be obtained in the
hugetlb documentation.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
---
 Documentation/kernel-parameters.txt | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 479f332..d919af0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1228,9 +1228,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			multiple times interleaved with hugepages= to reserve
 			huge pages of different sizes. Valid pages sizes on
 			x86-64 are 2M (when the CPU supports "pse") and 1G
-			(when the CPU supports the "pdpe1gb" cpuinfo flag)
-			Note that 1GB pages can only be allocated at boot time
-			using hugepages= and not freed afterwards.
+			(when the CPU supports the "pdpe1gb" cpuinfo flag).
 
 	hvc_iucv=	[S390] Number of z/VM IUCV hypervisor console (HVC)
 			       terminal devices. Valid values: 0..8
-- 
1.9.3

