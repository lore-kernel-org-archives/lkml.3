Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab3EIXMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:12:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab3EIW0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Cohen <david.a.cohen@intel.com>,
        mark gross <mark.gross@intel.com>, David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 20/73] MODSIGN: do not send garbage to stderr when enabling modules signature
Date: Thu,  9 May 2013 15:25:10 -0700
Message-Id: <20130509222528.534144609@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -175,7 +175,7 @@ signing_key.priv signing_key.x509: x509.
 	openssl req -new -nodes -utf8 -$(CONFIG_MODULE_SIG_HASH) -days 36500 \
 		-batch -x509 -config x509.genkey \
 		-outform DER -out signing_key.x509 \
-		-keyout signing_key.priv
+		-keyout signing_key.priv 2>&1
 	@echo "###"
 	@echo "### Key pair generated."
 	@echo "###"


