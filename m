Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab3ILR7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:59:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab3ILR73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John Haxby <john.haxby@oracle.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Michael Marineau <michael.marineau@cf-protected.coreos.com>
Subject: [ 43/46] crypto: xor - Check for osxsave as well as avx in crypto/xor
Date: Thu, 12 Sep 2013 10:58:54 -0700
Message-Id: <20130912175725.640851396@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Haxby <john.haxby@oracle.com>

commit edb6f29464afc65fc73767540b854abf63ae7144 upstream.

This affects xen pv guests with sufficiently old versions of xen and
sufficiently new hardware.  On such a system, a guest with a btrfs
root won't even boot.

Signed-off-by: John Haxby <john.haxby@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reported-by: Michael Marineau <michael.marineau@coreos.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/xor_avx.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/xor_avx.h
+++ b/arch/x86/include/asm/xor_avx.h
@@ -167,12 +167,12 @@ static struct xor_block_template xor_blo
 
 #define AVX_XOR_SPEED \
 do { \
-	if (cpu_has_avx) \
+	if (cpu_has_avx && cpu_has_osxsave) \
 		xor_speed(&xor_block_avx); \
 } while (0)
 
 #define AVX_SELECT(FASTEST) \
-	(cpu_has_avx ? &xor_block_avx : FASTEST)
+	(cpu_has_avx && cpu_has_osxsave ? &xor_block_avx : FASTEST)
 
 #else
 


