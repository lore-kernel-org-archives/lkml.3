Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaFHVok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 17:44:40 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:51598 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbaFHVof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 17:44:35 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lisa Nguyen <lisa@xenapiadmin.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Tugce Sirin <ztugcesirin@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Wenliang Fan <fanwlexca@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Aldo Iljazi <neonsync1@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: bcm: nvm.c:  Cleaning up a array that is filled incompletely  
Date: Sun,  8 Jun 2014 23:45:27 +0200
Message-Id: <1402263928-1961-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I think someone missed the count sizeof type in memcpy.

I'm no expert on this code.
But I wonder if also the the next for loop wrong?
It will fill with 0XFF00000000000000 but it is
not a complete 0XFFFFFFFFFFFFFFFF you're looking for?

So something like:
memset(&Buff[sigOffset], 0xFF, MAX_RW_SIZE * sizeof(PCHAR));

Rickard Strandqvist (1):
  MY_FIL_NAMN Cleaning up a array that is filled incompletely

 drivers/staging/bcm/nvm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.10.4

