Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaGGJ77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 05:59:59 -0400
Received: from nm26-vm3.bullet.mail.ir2.yahoo.com ([212.82.97.45]:45991 "EHLO
	nm26-vm3.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbaGGJ76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 05:59:58 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2014 05:59:58 EDT
X-Yahoo-Newman-Id: 428594.8254.bm@smtp140.mail.ir2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jtN_VqcVM1mzBlyM8xJTouzyow79RSSTzFz1eBM5LH0F6jL
 DV99h1I57c3f0H_mO0g0BQbMS4TvffeerciUx77SJLCrYLOcK.KWz4wv4JdH
 Q55DqHkPNv.VjCHgT.UKAHqp9sOD5ycnkSnfBg.4ZEz3JrkjBihFbDsI6cqP
 y8e310cUOt0IcfYHYyWUSUJneX61ekPz8qrc_LG4LuXcqc1Ists3_lykGGUU
 cpahZnVl6rxdE_fpbgReIP_OKG.A68wabJWDVjYCfGSO2buxhlrx.ydCKjby
 CXaNXi.9.qQsyFRz4wOSLMK0IBD9E9mJ_bgCokIV9FR9q50_sQACLXrV9nby
 pc_huzvnpCuUQe4sJ1MaCsWO6ReDPTfLNpQWQNLYKvD0DQVd2L.9F0dcSSXV
 PhwKdjALfR7jt.wjzMjSkc.EUZo5AYaKI9wO3fWe_z_BMEsWXbOS3fm7wPbq
 E63VCUZFqGL4bur_4M096bu_56OrxJLCYjLkuCxW_0O9Z1EESlb89BfpvP7j
 M0lXWv2L5e04zCpf32X0HrsHf7hpodk.VTtPmNtNwcuKkO_rcYK43pkDl3iO
 cPbCOl8g40GRDWnaIr19p3TzPM1yNCxxaeb5vkuOfUJ9UndnhUKYjXUxCciP
 3.ZR31GQ_ZA559lltCBwbNFhKevnhKDpKGHReeYGi8H_dar7.pArde57VTKQ
 -
X-Yahoo-SMTP: 1rv77aOswBAZXHe.sKY40dUsriU-
X-Rocket-Received: from localhost.localdomain (kieran@92.27.141.186 with plain [188.125.69.59])
        by smtp140.mail.ir2.yahoo.com with SMTP; 07 Jul 2014 09:53:42 +0000 UTC
From: Kieran Kunhya <kieran@kunhya.com>
To: axboe@kernel.dk
Cc: akpm@linux-foundation.org, jmoyer@redhat.com, rdunlap@infradead.org,
        fabf@skynet.be, minchan@kernel.org, linus.walleij@linaro.org,
        abhansali@stec-inc.com, gnomes@lxorguk.ukuu.org.uk, jkosina@suse.cz,
        linux-kernel@vger.kernel.org, Kieran Kunhya <kieran@kunhya.com>
Subject: [PATCH] Add support for Sony SxS cards
Date: Mon,  7 Jul 2014 10:53:13 +0100
Message-Id: <1404726794-8964-1-git-send-email-kieran@kunhya.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a reverse-engineered read-only driver for Sony SxS cards.
SxS cards are an Expresscard based memory card used in professional cameras.

I've not managed to get block device DMA working for some reason and currently
this driver uses a memcpy. I may well be using the block device DMA API incorrectly.

The block device DMA code can be found here:
https://github.com/kierank/sxs-linux/blob/dma/sxs.c

Any comments on the DMA code would also be appreciated.

Kieran Kunhya (1):
  block: Add support for Sony SxS cards     Signed-off-by: Kieran
    Kunhya <kieran@kunhya.com>

 drivers/block/Kconfig  |    9 +
 drivers/block/Makefile |    1 +
 drivers/block/sxs.c    |  491 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 501 insertions(+)
 create mode 100644 drivers/block/sxs.c

-- 
1.7.9.5

