Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab3GJKfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:35:40 -0400
Received: from multi.imgtec.com ([194.200.65.239]:26239 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab3GJKfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:35:37 -0400
Message-ID: <51DD38F5.2030101@imgtec.com>
Date: Wed, 10 Jul 2013 11:35:33 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] metag architecture fix
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_07_10_11_35_34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this single arch/metag fix for a network checksum bug
(discovered after you merged the other metag changes).

Thanks
James

The following changes since commit 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376:

  Linux 3.10 (2013-06-30 15:13:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag.git tags/metag-fixes-for-v3.11-1

for you to fetch changes up to d903bca9bc542bd6d60019f9f761be15ad79c956:

  metag: checksum.h: fix carry in csum_tcpudp_nofold (2013-07-09 11:09:17 +0100)

----------------------------------------------------------------
arch/metag fixes for v3.11

This is just a single fix to fix bad UDP checksums sometimes being
generated to IP addresses *.*.255.255.

----------------------------------------------------------------
James Hogan (1):
      metag: checksum.h: fix carry in csum_tcpudp_nofold

 arch/metag/include/asm/checksum.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/metag/include/asm/checksum.h b/arch/metag/include/asm/checksum.h
index 999bf76..08dd1cc 100644
--- a/arch/metag/include/asm/checksum.h
+++ b/arch/metag/include/asm/checksum.h
@@ -64,7 +64,8 @@ static inline __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
 					__wsum sum)
 {
 	unsigned long len_proto = (proto + len) << 8;
-	asm ("ADD    %0, %0, %1\n"
+	asm ("ADDS   %0, %0, %1\n"
+	     "ADDCS  %0, %0, #1\n"
 	     "ADDS   %0, %0, %2\n"
 	     "ADDCS  %0, %0, #1\n"
 	     "ADDS   %0, %0, %3\n"

