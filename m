Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbaHHMlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 08:41:40 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48035 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbaHHMlf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 08:41:35 -0400
From: Avinash Patil <patila@marvell.com>
To: Hans Wennborg <hans@hanshq.net>, Amitkumar Karwar <akarwar@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Aug 2014 05:40:16 -0700
Subject: RE: [PATCH 07/15] mwifiex: fix decimal printf format specifiers
 prefixed with 0x
Thread-Topic: [PATCH 07/15] mwifiex: fix decimal printf format specifiers
 prefixed with 0x
Thread-Index: Ac+xMYF1q43N4fQhQ/uMw1DeTEdNkwB1Gabd
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC4781147BD8@SC-VEXCH2.marvell.com>
References: <1407300175-32635-1-git-send-email-hans@hanshq.net>
In-Reply-To: <1407300175-32635-1-git-send-email-hans@hanshq.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-08_03:2014-08-08,2014-08-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408080150
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

>The prefix suggests the number should be printed in hex, so use the %x specifier to do that.

Acked-by: Avinash Patil <patila@marvell.com>

Thanks,
Avinash.

________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Hans Wennborg [hans@hanshq.net]
Sent: Wednesday, August 06, 2014 10:12 AM
To: Amitkumar Karwar; linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: Hans Wennborg
Subject: [PATCH 07/15] mwifiex: fix decimal printf format specifiers prefixed with 0x

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e2e6bf1..2856f0e 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -246,7 +246,7 @@ mwifiex_cfg80211_remain_on_channel(struct wiphy *wiphy,
        }

        if (priv->roc_cfg.cookie) {
-               wiphy_dbg(wiphy, "info: ongoing ROC, cookie = 0x%llu\n",
+               wiphy_dbg(wiphy, "info: ongoing ROC, cookie = 0x%llx\n",
                          priv->roc_cfg.cookie);
                return -EBUSY;
        }
--
2.0.0.526.g5318336

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
