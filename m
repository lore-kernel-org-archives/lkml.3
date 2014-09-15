Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaIOK0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:26:48 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:15224 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321AbaIOK0q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:26:46 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Date: Mon, 15 Sep 2014 18:26:43 +0800
Subject: [RFC Resend] arm:extend __init_end to a page align address
Thread-Topic: [RFC Resend] arm:extend __init_end to a page align address
Thread-Index: Ac/OcQYK+iHegZKaRzKAERxvRcdQnQCG69kgABCWdjA=
Message-ID: <35FD53F367049845BC99AC72306C23D103D6DB491607@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103CDBFBFB028@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103D6DB4915FB@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103D6DB4915FB@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch change the __init_end address to a page align address, so that free_initmem()
can free the whole .init section, because if the end address is not page aligned,
it will round down to a page align address, then the tail unligned page will not be freed.

Signed-off-by: Yalin wang <yalin.wang@sonymobile.com>
---
 arch/arm/kernel/vmlinux.lds.S   | 2 +-
 arch/arm64/kernel/vmlinux.lds.S | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S index 6f57cb9..8e95aa4 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -219,8 +219,8 @@ SECTIONS
 	__data_loc = ALIGN(4);		/* location in binary */
 	. = PAGE_OFFSET + TEXT_OFFSET;
 #else
-	__init_end = .;
 	. = ALIGN(THREAD_SIZE);
+	__init_end = .;
 	__data_loc = .;
 #endif
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S index 97f0c04..edf8715 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -97,9 +97,9 @@ SECTIONS
 
 	PERCPU_SECTION(64)
 
+	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 
-	. = ALIGN(PAGE_SIZE);
 	_data = .;
 	_sdata = .;
 	RW_DATA_SECTION(64, PAGE_SIZE, THREAD_SIZE)
--
1.9.2.msysgit.0
