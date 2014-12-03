Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaLCOeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:34:12 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:61528 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaLCOeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:34:09 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: Kevin Hilman <khilman@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>,
        Alexander Kochetkov <al.kochet@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 0/5] i2c: omap: new fixes 2
Date: Wed,  3 Dec 2014 18:33:57 +0400
Message-Id: <1417617242-16869-1-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pacth series intended for fixing problem reported
by Tony Lindgren <tony@atomide.com> here[1]

One of first four patched could fix the problem.
Last patch provide event trace so I could resolve problem.
It could be applied using 'git am' or 'patch -p1 ...'

Patches are rebased on branch 'i2c/for-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
(6e79807443cba7397cd855ed29d6faba51d4c893)

Tony, could you check, does the series fix the problem reported[1]?
If yes, could you bisect and point commit that solve.
If no, could you provide trace output (with or without the patches
from series).
If no, could you check does i2c-omap.c from commit ca1f8da9ac5ce6e63d8f6933f83fabc1f3f961f4.
(the commit before my changes to kernel) work for you?

Thank you.

Regards,
Alexander.

[1] http://www.spinics.net/lists/linux-i2c/msg17811.html

Alexander Kochetkov (5):
  i2c: omap: ack only reported events
  i2c: omap: simplify i462 errata handling for NACK and AL cases
  i2c: omap: move STP generation logic into ISR thread
  i2c: omap: reimpelement STP hack via 2-phases transfer
  i2c: omap: add trace

 drivers/i2c/busses/i2c-omap.c |  162 ++++++++++++++++++++++++-----------------
 1 file changed, 95 insertions(+), 67 deletions(-)

-- 
1.7.9.5

