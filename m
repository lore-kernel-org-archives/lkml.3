Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbaHHWC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:02:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933027AbaHHVgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fan Du <fan.du@windriver.com>, Tobias Brunner <tobias@strongswan.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 3.14 01/39] xfrm: Fix installation of AH IPsec SAs
Date: Fri,  8 Aug 2014 14:34:47 -0700
Message-Id: <20140808213355.038291001@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213354.980430919@linuxfoundation.org>
References: <20140808213354.980430919@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Brunner <tobias@strongswan.org>

[ Upstream commit a0e5ef53aac8e5049f9344857d8ec5237d31e58b ]

The SPI check introduced in ea9884b3acf3311c8a11db67bfab21773f6f82ba
was intended for IPComp SAs but actually prevented AH SAs from getting
installed (depending on the SPI).

Fixes: ea9884b3acf3 ("xfrm: check user specified spi for IPComp")
Cc: Fan Du <fan.du@windriver.com>
Signed-off-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -176,9 +176,7 @@ static int verify_newsa_info(struct xfrm
 		    attrs[XFRMA_ALG_AEAD]	||
 		    attrs[XFRMA_ALG_CRYPT]	||
 		    attrs[XFRMA_ALG_COMP]	||
-		    attrs[XFRMA_TFCPAD]		||
-		    (ntohl(p->id.spi) >= 0x10000))
-
+		    attrs[XFRMA_TFCPAD])
 			goto out;
 		break;
 
@@ -206,7 +204,8 @@ static int verify_newsa_info(struct xfrm
 		    attrs[XFRMA_ALG_AUTH]	||
 		    attrs[XFRMA_ALG_AUTH_TRUNC]	||
 		    attrs[XFRMA_ALG_CRYPT]	||
-		    attrs[XFRMA_TFCPAD])
+		    attrs[XFRMA_TFCPAD]		||
+		    (ntohl(p->id.spi) >= 0x10000))
 			goto out;
 		break;
 


