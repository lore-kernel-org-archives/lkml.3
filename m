Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaEVPLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:11:03 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:52739
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750741AbaEVPLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:11:00 -0400
From: Horia Geanta <horia.geanta@freescale.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Lei Xu <Lei.Xu@freescale.com>, Sandeep Malik <Sandeep.Malik@freescale.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC ipsec-next] Non-standard sha256 ICV truncation size
Date: Thu, 22 May 2014 18:10:36 +0300
Message-ID: <1400771437-14096-1-git-send-email-horia.geanta@freescale.com>
X-Mailer: git-send-email 1.8.3.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(164054003)(199002)(189002)(36756003)(87286001)(74662001)(102836001)(74502001)(92566001)(92726001)(86362001)(46102001)(31966008)(83072002)(33646001)(87936001)(77156001)(85852003)(77982001)(93916002)(77096999)(76482001)(50226001)(50986999)(99396002)(62966002)(83322001)(19580395003)(44976005)(79102001)(15975445006)(19580405001)(26826002)(47776003)(64706001)(20776003)(48376002)(15202345003)(50466002)(89996001)(88136002)(80022001)(81542001)(81342001)(4396001)(6806004)(21056001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB383;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:gate-tx3.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 021975AE46
Authentication-Results: spf=fail (sender IP is 192.88.168.1)
 smtp.mailfrom=Horia.Geanta@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am sending this patch as RFC, since the change is likely to create
interoperability issues.
I'd like to get some comments on what should be the correct approach in this
standard vs. de facto setup.

Note that an older commit (which is no longer in git's history, but can be found
here https://archive.org/details/git-history-of-linux) changed truncated ICV size
from 128bit to 96bit:

commit 627d1054055f465603bcfb7ef5c9adc5db9b2a53
Author: Michal Ludvig <michal@logix.cz>
Date:   Fri Jan 9 04:55:59 2004 -0800

    [XFRM]: SHA2-256 should be truncated to 96 bits, not 128.

It seems that initially the sha256 ICV was truncated to 128 bits, but later
changed to 96 bits due to interoperability issues - see comment here:
http://oss.sgi.com/archives/netdev/2004-01/msg00824.html

Note that commit above is from 2004, long before RFC4868 was released (2007).

Thanks,
Horia

Lei Xu (1):
  xfrm: make sha256 icv truncation length RFC-compliant

 net/xfrm/xfrm_algo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.8.3.1

