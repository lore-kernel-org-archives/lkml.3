Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaFKXkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 19:40:33 -0400
Received: from mout.web.de ([212.227.17.12]:58798 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbaFKXkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:40:32 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCH 0/2 net-next] bridge: fix bugs introduced by last multicast patchset
Date: Thu, 12 Jun 2014 01:41:22 +0200
Message-Id: <1402530084-15061-1-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:bl34miK7N/s3Y/1TCP3/3CvKghNVHoFdTFlSU6Vln6J0rGSz9ZQ
 8iHKdLhtI+hw0s4GNyZu8RYR3pJdMzWUXKnIz6ZjuzYA0gAW7AnS7eUIWrhv2L06PoA1Q3x
 KbMyjBUmQWGUw5QRQm45qF9MzvAHNdGGkhrIC3Jf7jSzIUVuCDi18520yN+5A55bkWitfw+
 qDr8+21OJqaQFXZXnPizg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once my last patchset got applied, I got slapped by an automatic smatch
and build bot. Here are two patches fixing the according issues, a potential
null pointer dereference and a compile error when compiling without IPv6.

[PATCH 1/2] is probably not the ideal solution - the assignment of the
group and max_delay is still a mess and has subtle differences between
IGMPv2, IGMPv3, MLDv1 and MLDv2. That should probably be fixed $later.
But for now, I think the easier fix might be better, restoring the
behaviour before my "adhere to querier mechanism" patch and therefore
keeping things bisect'able.

Cheers, Linus
