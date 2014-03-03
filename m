Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaCCFY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 00:24:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:37272 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbaCCFYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 00:24:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,575,1389772800"; 
   d="scan'208,223";a="492644427"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "'qemu-devel@nongnu.org'" <qemu-devel@nongnu.org>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: "'hpa@zytor.com'" <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "'gleb@redhat.com'" <gleb@redhat.com>
Subject: [PATCH] target-i386: bugfix of Intel MPX
Thread-Topic: [PATCH] target-i386: bugfix of Intel MPX
Thread-Index: Ac82oNCIFQFsH9+FTXuk6EyHE47FPg==
Date: Mon, 3 Mar 2014 05:24:14 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350152FC71@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3a7783cd9a0556787809d3d5ecb5f2b85dd9fc02 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Mon, 3 Mar 2014 18:56:39 +0800
Subject: [PATCH] target-i386: bugfix of Intel MPX

The correct size of cpuid 0x0d sub-leaf 4 is 0x40, not 0x10.
This is confirmed by Anvin H Peter and Mallick Asit K.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Asit K Mallick <asit.k.mallick@intel.com>
---
 target-i386/cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/target-i386/cpu.c b/target-i386/cpu.c
index 0e8812a..9f69d7e 100644
--- a/target-i386/cpu.c
+++ b/target-i386/cpu.c
@@ -339,7 +339,7 @@ static const ExtSaveArea ext_save_areas[] = {
     [3] = { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
             .offset = 0x3c0, .size = 0x40  },
     [4] = { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
-            .offset = 0x400, .size = 0x10  },
+            .offset = 0x400, .size = 0x40  },
 };
 
 const char *get_register_name_32(unsigned int reg)
-- 
1.7.1
