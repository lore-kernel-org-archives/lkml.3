Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3LDXQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:16:19 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:57636 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3LDXQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:16:15 -0500
Message-ID: <1386198962.31494.12.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH] partitions/efi: complete gpt kernel param purpose
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Matt Domsch <Matt_Domsch@dell.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "Chandramouleeswaran,Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>
Date: Wed, 04 Dec 2013 15:16:02 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

The usage of the 'gpt' kernel parameter is twofold:
(i) skip any mbr integrity checks and (ii) enable the
backup GPT header to be used in situations where the
primary one is corrupted. This last "feature" is not
obvious and needs to be properly documented in the
kernel-parameters document.

References: https://bugzilla.kernel.org/show_bug.cgi?id=63591
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 Documentation/kernel-parameters.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 50680a5..1e353a4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1013,7 +1013,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			debugfs files are removed at module unload time.
 
 	gpt		[EFI] Forces disk with valid GPT signature but
-			invalid Protective MBR to be treated as GPT.
+			invalid Protective MBR to be treated as GPT. If the
+			primary GPT is corrupted, it enables the backup/alternate
+			GPT to be used instead.
 
 	grcan.enable0=	[HW] Configuration of physical interface 0. Determines
 			the "Enable 0" bit of the configuration register.
-- 
1.8.1.4



