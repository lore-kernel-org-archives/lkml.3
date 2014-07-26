Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbaGZURt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:17:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaGZTCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:02:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 16/23] dns_resolver: Null-terminate the right string
Date: Sat, 26 Jul 2014 12:02:16 -0700
Message-Id: <20140726190150.220329363@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190149.723570428@linuxfoundation.org>
References: <20140726190149.723570428@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit 640d7efe4c08f06c4ae5d31b79bd8740e7f6790a ]

*_result[len] is parsed as *(_result[len]) which is not at all what we
want to touch here.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 84a7c0b1db1c ("dns_resolver: assure that dns_query() result is null-terminated")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dns_resolver/dns_query.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -151,7 +151,7 @@ int dns_query(const char *type, const ch
 		goto put;
 
 	memcpy(*_result, upayload->data, len);
-	*_result[len] = '\0';
+	(*_result)[len] = '\0';
 
 	if (_expiry)
 		*_expiry = rkey->expiry;


