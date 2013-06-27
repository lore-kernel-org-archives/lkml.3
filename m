Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab3F0XrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 19:47:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14069 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3F0XrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 19:47:06 -0400
X-AuditID: cbfee68e-b7f276d000002279-4f-51cccef7efb8
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org,
        "'Gustavo Padovan'" <gustavo.padovan@collabora.co.uk>,
        "'Daniel Drake'" <dsd@laptop.org>,
        "'Marcel Holtmann'" <marcel@holtmann.org>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable]  Bluetooth: btmrvl: fix thread stopping race
Date: Fri, 28 Jun 2013 08:47:02 +0900
Message-id: <002501ce7390$9f7c4750$de74d5f0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkzGCMAAA5gYwAMf3LxAFffBYYAAAIZFQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t8zI93v584EGuz7z2Exf/ZEVotPq1vZ
	LZY0c1tc3jWHzeLbp1+MFgs2PmJ0YPP4+/w6i8f63cvZPQ5dWcvo0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBnz+1kLVvFXnLhwlrmB8S5PFyMnh4SAiUT7y9OsELaYxIV769m6GLk4hASW
	MUqsn3SfEaboZ+9fFojEdEaJNwsXQFX9ZZS42TGRHaSKTUBX4tj6LWCjRAS8JU5N+cUMUsQs
	MJdRYmfrN6BRHEAd3BKrm4NAajgFeCTW/elkBrGFBTwknk66yARiswioSmy7vQpsDq+AnUT7
	igtsELagxI/J91hAbGYBLYn1O48zQdjyEpvXvGUGGS8hoC7x6K8uyFoRgRmMEktOdEPVi0js
	e/GOESQhIfCSXWLr8jfsEMsEJL5NPsQC0SwrsekAM8THkhIHV9xgmcAoMQvJ6llIVs9CsnoW
	khULGFlWMYqmFiQXFCelFxnpFSfmFpfmpesl5+duYoTEbN8OxpsHrA8xJgOtn8gsJZqcD4z5
	vJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwNmlb
	x4V9qdnz79ZGCx7PBTkX77WFPt09d9fkkGWvZ95o+trQLPx/ewb3naTEafZx99gXeT5hrjh3
	YNFnp+v1hTanuXp+zt4eecb3+kRFJqPWNRrxHQJJ8m2O5v3K/jdqHttsSzvGsXOj2MtVFtl+
	MQIcm5VnvX/f+3r+8U+vjbSm+ynW7vf4qsRSnJFoqMVcVJwIANyANizvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jQd3v584EGsw5ymIxf/ZEVotPq1vZ
	LZY0c1tc3jWHzeLbp1+MFgs2PmJ0YPP4+/w6i8f63cvZPQ5dWcvo0bdlFaPH501yAaxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKCmUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz5vezFqzirzhx4SxzA+Ndni5GTg4J
	AROJn71/WSBsMYkL99azdTFycQgJTGeUeLNwAZTzl1HiZsdEdpAqNgFdiWPrt7CC2CIC3hKn
	pvxiBiliFpjLKLGz9RtjFyMHUAe3xOrmIJAaTgEeiXV/OplBbGEBD4mnky4ygdgsAqoS226v
	ApvDK2An0b7iAhuELSjxY/I9sIuYBbQk1u88zgRhy0tsXvOWGWS8hIC6xKO/uiBrRQRmMEos
	OdENVS8ise/FO8YJjEKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/
	dxMjOCE8k9rBuLLB4hCjAAejEg9vY+KZQCHWxLLiytxDjBIczEoivHcWAIV4UxIrq1KL8uOL
	SnNSiw8xJgN9OpFZSjQ5H5is8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQ
	WgSzhYmDU6qB0TCg/fCdmXxr9doec0s/vyUrrf9EIpPhJ/OriBVvVqTds5cqPz8hUks92eTs
	vbSeT6wXCjb/k18azeXdJi0YHMVqcvaL6NZXygZ7lb5JsEeu+7hczXOJRPmrAzIvW2d+EFt0
	yrlwjyGz+NHvTU/y7s2oyfV5ostzQ/jpiR9vjkQeOib79do7BiWW4oxEQy3mouJEAKv639JM	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Daniel Drake <dsd@laptop.org>"

commit ea05fea9042620ac3b8ab9a3e5e4d2ed80c89244 upstream

There is currently a race condition in the btmrvl_remove_card() which
is causing hangs on suspend for OLPC. When the race occurs,
kthread_stop() never returns.

The problem is that btmrvl_service_main_thread() calls kthread_should_stop()
and then does a fair number of things before restarting the loop and
sleeping.

If the thread gets stopped after kthread_should_stop() is checked, but
before the sleep happens, the thread will go to sleep and won't necessarily
be woken up.

Move the kthread_should_stop() check into a race-free place.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/bluetooth/btmrvl_main.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_main.c
b/drivers/bluetooth/btmrvl_main.c
index 3a4343b..9a9f518 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -498,6 +498,10 @@ static int btmrvl_service_main_thread(void *data)
 		add_wait_queue(&thread->wait_q, &wait);
 
 		set_current_state(TASK_INTERRUPTIBLE);
+		if (kthread_should_stop()) {
+			BT_DBG("main_thread: break from main thread");
+			break;
+		}
 
 		if (adapter->wakeup_tries ||
 				((!adapter->int_count) &&
@@ -513,11 +517,6 @@ static int btmrvl_service_main_thread(void *data)
 
 		BT_DBG("main_thread woke up");
 
-		if (kthread_should_stop()) {
-			BT_DBG("main_thread: break from main thread");
-			break;
-		}
-
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		if (adapter->int_count) {
 			adapter->int_count = 0;
-- 
1.7.9.5

