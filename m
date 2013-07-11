Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3GKGxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:53:08 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:51581 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3GKGxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:53:05 -0400
From: "=?UTF-8?q?=E2=80=9CCosmin?=" <cosmin90stanescu@gmail.com>
To: davem@davemloft.net
Cc: dhowells@redhat.com, ebiederm@xmission.com, rusty@rustcorp.com.au,
        serge.hallyn@canonical.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] strict_strtoul in (obsolete) changed to kstrtoul
Date: Thu, 11 Jul 2013 09:52:42 +0300
Message-Id: <1373525562-9035-1-git-send-email-user@mjolnir>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: “Cosmin <“cosmin90stanescu@gmail.com”>
---
 net/dns_resolver/dns_key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index 0a69d07..f347a2c 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -118,7 +118,7 @@ dns_resolver_instantiate(struct key *key, struct key_preparsed_payload *prep)
 				if (opt_vlen <= 0)
 					goto bad_option_value;
 
-				ret = strict_strtoul(eq, 10, &derrno);
+				ret = kstrtoul(eq, 10, &derrno);
 				if (ret < 0)
 					goto bad_option_value;
 
-- 
1.7.10.4

