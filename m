Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbaE2EgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:36:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417AbaE2Efv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 130/140] bonding: fix out of range parameters for bond_intmax_tbl
Date: Wed, 28 May 2014 21:34:29 -0700
Message-Id: <20140529043106.089565558@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@redhat.com>

[ Upstream commit 81c708068dfedece038e07d818ba68333d8d885d ]

I've missed to add a NULL entry to the bond_intmax_tbl when I introduced
it with the conversion of arp_interval so add it now.

CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>

Fixes: 7bdb04ed0dbf ("bonding: convert arp_interval to use the new option API")
Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Acked-by: Veaceslav Falico <vfalico@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_options.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -70,6 +70,7 @@ static struct bond_opt_value bond_fail_o
 static struct bond_opt_value bond_intmax_tbl[] = {
 	{ "off",     0,       BOND_VALFLAG_DEFAULT},
 	{ "maxval",  INT_MAX, BOND_VALFLAG_MAX},
+	{ NULL,      -1,      0}
 };
 
 static struct bond_opt_value bond_lacp_rate_tbl[] = {


