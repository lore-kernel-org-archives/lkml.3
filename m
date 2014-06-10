Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaFJItl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:49:41 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36042 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaFJIsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:48:52 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-fa-5396c6709a2b
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jwboyer@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 2/4] KEYS: fix couple of things
Date: Tue, 10 Jun 2014 11:48:16 +0300
Message-id: <b596263e2dff55879cc43aa4b43f26c08b994052.1402387862.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1402387862.git.d.kasatkin@samsung.com>
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
 <cover.1402387862.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1402387862.git.d.kasatkin@samsung.com>
References: <cover.1402387862.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xa7oFx6YFG3y8pGJx6+9eZot3Tb9Z
	LL4srbM48O4Ji8XsXQ9ZLC7vmsNm8aHnEZvFpxWTmB04PHbOusvuMe3EMhaPB4c2s3i833eV
	zaNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyfvxbxFxwiL1i1munBsa5bF2MnBwSAiYSt27d
	YISwxSQu3FsPFOfiEBJYyiixfd1VZgink0nicP9MsA42AT2JDc0/2EESIgJtjBJtW5+BJZgF
	0iU+TeplB7GFBfQlXs+6xAJiswioSpzf2M8MYvMKxEm8ejiNCWKdnMTJY5NZuxg5ODgFrCQ+
	LAoFCQsJlEmc/PwBU9hSov/1VLYJjPwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoQE
	5dcdjEuPWR1iFOBgVOLhNfCfFizEmlhWXJl7iFGCg1lJhPfuNqAQb0piZVVqUX58UWlOavEh
	RiYOTqkGxvNvLRYsWPaqwDav7qJMsDcXY/SqT5d5cr6lt3LeOr1KwLntoodpjN0aoSOJld7r
	T6592/QqJUzq11e1QybvUgPsTW+dtDk88Xt7qPTrOxPmT86uP3sx7PYV1mdbIh2rK1Kdl36I
	sXSs3KmfxTV7dcC1jKZvt/dqav6+yseh8LiqLzldpuGcvxJLcUaioRZzUXEiAHS296QoAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 crypto/asymmetric_keys/x509_public_key.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 6af338f..962f9b9 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -177,6 +177,7 @@ static int x509_validate_trust(struct x509_certificate *cert,
 	if (!IS_ERR(key))  {
 		pk = key->payload.data;
 		ret = x509_check_signature(pk, cert);
+		key_put(key);
 	}
 	return ret;
 }
@@ -237,7 +238,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		ret = x509_check_signature(cert->pub, cert); /* self-signed */
 		if (ret < 0)
 			goto error_free_cert;
-	} else {
+	} else if (!prep->trusted) {
 		ret = x509_validate_trust(cert,
 					  get_system_or_owner_trusted_keyring());
 		if (!ret)
-- 
1.9.1

