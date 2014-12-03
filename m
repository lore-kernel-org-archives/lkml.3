Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaLCPLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:11:25 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33102 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaLCPLX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:11:23 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Question about patch "i2c: omap: resize fifos before each message"
Date: Wed, 3 Dec 2014 18:11:18 +0300
Message-Id: <A20987D6-DEEC-488D-9655-36A4D186599B@gmail.com>
Cc: Kevin Hilman <khilman@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
To: Felipe Balbi <balbi@ti.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

Question about the patch[1].

I want to change the code in a way to not touch fifo thresholds for each message.
Because:
1. dev->threshold is valid only with checking of transfer direction.
   So, if last transfer was transmission and ISR get RRDY interrupt from slave receiver,
   then dev->threshold is invalid. We must read threshold value from BUF register, to
   process correctly.
2. I want to avoid changing fifos before message submission, because IP can start receiving
   message in a slave mode (race).
3. dev->threshold is changed in range 1-fifo_size/2. So instead of RDR we get RRDY and
   for messages larger then fifo_size/2 we still get RRDY and RDR.

Felipe, do you have in mind why do you want to avoid RDR and XDR events?
Something about errata?

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/i2c/busses/i2c-omap.c?id=dd74548ddece4b9d68e5528287a272fa552c81d0

