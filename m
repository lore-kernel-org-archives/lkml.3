Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3A2RBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 12:01:32 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:19501 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab3A2RBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 12:01:30 -0500
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@driverdev.osuosl.org>
CC: <dan.carpenter@oracle.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH] staging:ozwpan: Fix following warning.
Date: Tue, 29 Jan 2013 17:00:55 +0000
Message-ID: <1359478855-12507-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <5107F9D0.1070909@atmel.com>
References: <5107F9D0.1070909@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch ae926051d7eb: "staging: ozwpan: Added USB HCD
implementation" from Feb 20, 2012, leads to the following warning:
drivers/staging/ozwpan/ozhcd.c:1094 oz_hcd_heartbeat()
	 warn: what is this condition about? 'ep->buffered_units * 50'

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index b2d77df..9154f33 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -1091,7 +1091,7 @@ int oz_hcd_heartbeat(void *hport)
 	list_for_each(e, &port->isoc_in_ep) {
 		struct oz_endpoint *ep = ep_from_link(e);
 		if (ep->flags & OZ_F_EP_BUFFERING) {
-			if (ep->buffered_units * OZ_IN_BUFFERING_UNITS) {
+			if (ep->buffered_units >= OZ_IN_BUFFERING_UNITS) {
 				ep->flags &= ~OZ_F_EP_BUFFERING;
 				ep->credit = 0;
 				oz_event_log(OZ_EVT_EP_CREDIT,
-- 
1.7.5.4

