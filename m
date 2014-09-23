Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaIWHqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:46:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4949 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754315AbaIWHoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:44:55 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <wim@iguana.be>, <linux@roeck-us.net>
CC: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH v2 0/2] watchdog: dw_wdt: one bug fix and restart handler support
Date: Tue, 23 Sep 2014 15:42:10 +0800
Message-ID: <1411458132-5410-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-23_03:2014-09-23,2014-09-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1409230081
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are intend to improve dw_wdt in the following two aspects:

Firstly, the TOP_INIT, ie bit 4-7 of the WDOG_TIMEOUT_RANGE_REG_OFFSET register
may be zero at reset on some HW, so the timeout period may be very short, thus
we will see immediate system reset after openning the watchdog. Fix this
problem by also initialising the TOP_INIT when setting TOP.

Secondly, the WDT can also be used to reboot the system with the help of
recently introduced restart handler.

Tested on Marvell BG2Q DMP board.

Changes since v1:
  - add some wait to let the reset catch, suggested by Guenter Roeck
  - setting TOP_INIT as well when setting TOP in function dw_wdt_set_top to
    fix the reboot soon issue.

Jisheng Zhang (2):
  watchdog: dw_wdt: initialise TOP_INIT in dw_wdt_set_top()
  watchdog: dw_wdt: add restart handler support

 drivers/watchdog/dw_wdt.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

-- 
2.1.0

