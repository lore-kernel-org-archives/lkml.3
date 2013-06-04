Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3FDKj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 06:39:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3FDKj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 06:39:27 -0400
Date: Tue, 4 Jun 2013 16:09:10 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: linux-kernel@vger.kernel.org
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Petr Matousek <pmatouse@redhat.com>
Subject: Re: [patch] cciss: info leak in cciss_ioctl32_passthru()
Message-ID: <alpine.LFD.2.03.1306041602160.7145@erqung.pbz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Hello Dan,
===
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6374dc1..34971aa 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1201,6 +1201,7 @@ static int cciss_ioctl32_passthru(struct block_device 
*bdev, fmode_t mode,
  	int err;
  	u32 cp;

+	memset(&arg64, 0, sizeof(arg64));
 	...
===

   This exact same patch was included back in 2010 by Mr Vasiliy Kulikov.

  -> https://git.kernel.org/linus/7ab5118d7c2be650bc936894f159dc1c597badae

But there is no entry/log of its reversal. Any idea why was it removed?

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
