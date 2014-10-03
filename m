Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbaJCXa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:30:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393AbaJCWD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Scott Robinson <scott.robinson55@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.16 322/357] media: cx18: fix kernel oops with tda8290 tuner
Date: Fri,  3 Oct 2014 14:31:48 -0700
Message-Id: <20141003212943.137994188@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 6a03dc92cc2edfa2257502557b9f714893987383 upstream.

This was caused by an uninitialized setup.config field.

Based on a suggestion from Devin Heitmueller.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Thanks-to: Devin Heitmueller <dheitmueller@kernellabs.com>
Reported-by: Scott Robinson <scott.robinson55@gmail.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/cx18/cx18-driver.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -1091,6 +1091,7 @@ static int cx18_probe(struct pci_dev *pc
 		setup.addr = ADDR_UNSET;
 		setup.type = cx->options.tuner;
 		setup.mode_mask = T_ANALOG_TV;  /* matches TV tuners */
+		setup.config = NULL;
 		if (cx->options.radio > 0)
 			setup.mode_mask |= T_RADIO;
 		setup.tuner_callback = (setup.type == TUNER_XC2028) ?


