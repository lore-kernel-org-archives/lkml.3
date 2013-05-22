Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3EVHOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:14:04 -0400
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:47904 "EHLO lnfm1.sai.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab3EVHOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:14:01 -0400
Date: Wed, 22 May 2013 11:13:38 +0400 (MSK)
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        linux-serial@vger.kernel.org
Subject: [PATCH] tty: mxser: Fix build warning introduced by dfc7b837c7f9
 (Re: linux-next: build warning after merge of the tty.current tree)
In-Reply-To: <20130522133722.d52b827e455275dfdecf12dd@canb.auug.org.au>
Message-ID: <alpine.LRH.2.00.1305221109110.10829@lnfm1.sai.msu.ru>
References: <20130522133722.d52b827e455275dfdecf12dd@canb.auug.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matwey V. Kornilov <matwey@sai.msu.ru>

Fix build warning at mxser.c introduced by dfc7b837c7f9

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index f97b196..4c4a236 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -1674,15 +1674,15 @@ static int mxser_ioctl(struct tty_struct *tty,
  		return mxser_ioctl_special(cmd, argp);

  	if (cmd == MOXA_SET_OP_MODE || cmd == MOXA_GET_OP_MODE) {
-		if (info->board->chip_flag != MOXA_MUST_MU860_HWID)
-			return -EFAULT;
-
  		int p;
  		unsigned long opmode;
  		static unsigned char ModeMask[] = { 0xfc, 0xf3, 0xcf, 0x3f };
  		int shiftbit;
  		unsigned char val, mask;

+		if (info->board->chip_flag != MOXA_MUST_MU860_HWID)
+			return -EFAULT;
+
  		p = tty->index % 4;
  		if (cmd == MOXA_SET_OP_MODE) {
  			if (get_user(opmode, (int __user *) argp))

