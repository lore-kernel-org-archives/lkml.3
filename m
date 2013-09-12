Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab3ILSQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:16:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278Ab3ILSPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:15:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John Haxby <john.haxby@oracle.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Michael Marineau <michael.marineau@cf-protected.coreos.com>
Subject: [ 14/16] crypto: xor - Check for osxsave as well as avx in crypto/xor
Date: Thu, 12 Sep 2013 11:15:06 -0700
Message-Id: <20130912181157.734167038@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912181156.173326121@linuxfoundation.org>
References: <20130912181156.173326121@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
 


