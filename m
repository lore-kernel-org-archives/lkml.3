Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3F1S4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:56:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41802 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3F1S4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:56:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Cohen <david.a.cohen@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 039/105] MODSIGN: do not send garbage to stderr when enabling modules signature
Date: Fri, 28 Jun 2013 11:51:01 -0700
Message-Id: <1372445527-24414-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Cohen <david.a.cohen@intel.com>

commit 07c449bbc6aa514098c4f12c7b04180cec2417c6 upstream.

When compiling kernel with -jN (N > 1), all warning/error messages
printed while openssl is generating key pair may get mixed dots and
other symbols openssl sends to stderr. This patch makes sure openssl
logs go to default stdout.

Example of the garbage on stderr:

crypto/anubis.c:581: warning: ‘inter’ is used uninitialized in this function
Generating a 4096 bit RSA private key
.........
drivers/gpu/drm/i915/i915_gem_gtt.c: In function ‘gen6_ggtt_insert_entries’:
drivers/gpu/drm/i915/i915_gem_gtt.c:440: warning: ‘addr’ may be used uninitialized in this function
.net/mac80211/tx.c: In function ‘ieee80211_subif_start_xmit’:
net/mac80211/tx.c:1780: warning: ‘chanctx_conf’ may be used uninitialized in this function
..drivers/isdn/hardware/mISDN/hfcpci.c: In function ‘hfcpci_softirq’:
.....drivers/isdn/hardware/mISDN/hfcpci.c:2298: warning: ignoring return value of ‘driver_for_each_device’, declared with attribute warn_unused_result

Signed-off-by: David Cohen <david.a.cohen@intel.com>
Reviewed-by: mark gross <mark.gross@intel.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 6c072b6..f8f435a 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -185,7 +185,7 @@ signing_key.priv signing_key.x509: x509.genkey
 	openssl req -new -nodes -utf8 $(sign_key_with_hash) -days 36500 -batch \
 		-x509 -config x509.genkey \
 		-outform DER -out signing_key.x509 \
-		-keyout signing_key.priv
+		-keyout signing_key.priv 2>&1
 	@echo "###"
 	@echo "### Key pair generated."
 	@echo "###"
-- 
1.8.1.2

