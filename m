Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbaGZTwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:52:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbaGZTNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Karim Scheik <karim.scheik@prisma-solutions.at>,
        Nikolay Aleksandrov <nikolay@redhat.com>
Subject: [PATCH 3.14 58/87] bonding: fix ad_select module param check
Date: Sat, 26 Jul 2014 12:02:32 -0700
Message-Id: <20140726190216.506713647@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@redhat.com>

[ Upstream commit 548d28bd0eac840d122b691279ce9f4ce6ecbfb6 ]

Obvious copy/paste error when I converted the ad_select to the new
option API. "lacp_rate" there should be "ad_select" so we can get the
proper value.

CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: David S. Miller <davem@davemloft.net>

Fixes: 9e5f5eebe765 ("bonding: convert ad_select to use the new option
API")
Reported-by: Karim Scheik <karim.scheik@prisma-solutions.at>
Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4068,7 +4068,7 @@ static int bond_check_params(struct bond
 	}
 
 	if (ad_select) {
-		bond_opt_initstr(&newval, lacp_rate);
+		bond_opt_initstr(&newval, ad_select);
 		valptr = bond_opt_parse(bond_opt_get(BOND_OPT_AD_SELECT),
 					&newval);
 		if (!valptr) {


