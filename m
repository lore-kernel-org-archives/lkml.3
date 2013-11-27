Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab3K0C5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:57:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758901Ab3K0C5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:57:32 -0500
Date: Tue, 26 Nov 2013 21:57:24 -0500
From: Dave Jones <davej@redhat.com>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: staging: comedi: Fix boolean/logical and mix-up.
Message-ID: <20131127025724.GA18860@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hartley Sweeten <HartleyS@visionengravers.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20131107062754.93B2D660F4A@gitolite.kernel.org>
 <20131108200659.GA2101@redhat.com>
 <DC148C5AA1CEBA4E87973D432B1C2D8817E08AC5@P3PWEX4MB008.ex4.secureserver.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8817E08AC5@P3PWEX4MB008.ex4.secureserver.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced in commit b3ff824a81e8.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
index d041b714db29..2baaf1db6fbf 100644
--- a/drivers/staging/comedi/drivers/pcl730.c
+++ b/drivers/staging/comedi/drivers/pcl730.c
@@ -173,11 +173,11 @@ static int pcl730_do_insn_bits(struct comedi_device *dev,
 	if (mask) {
 		if (mask & 0x00ff)
 			outb(s->state & 0xff, dev->iobase + reg);
-		if ((mask & 0xff00) & (s->n_chan > 8))
+		if ((mask & 0xff00) && (s->n_chan > 8))
 			outb((s->state >> 8) & 0xff, dev->iobase + reg + 1);
-		if ((mask & 0xff0000) & (s->n_chan > 16))
+		if ((mask & 0xff0000) && (s->n_chan > 16))
 			outb((s->state >> 16) & 0xff, dev->iobase + reg + 2);
-		if ((mask & 0xff000000) & (s->n_chan > 24))
+		if ((mask & 0xff000000) && (s->n_chan > 24))
 			outb((s->state >> 24) & 0xff, dev->iobase + reg + 3);
 	}
 
