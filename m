Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbaEFED2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 00:03:28 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53484 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaEFED0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 00:03:26 -0400
From: David Matlack <dmatlack@google.com>
To: gregkh@linuxfoundation.org
Cc: liodot@gmail.com, charrer@alacritech.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, David Matlack <dmatlack@google.com>
Subject: [PATCH 0/7] staging: slicoss: bug fixes to stabilize driver
Date: Mon,  5 May 2014 21:02:30 -0700
Message-Id: <1399348957-16663-1-git-send-email-dmatlack@google.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series fixes multiple small but critical bugs in
the slicoss driver that can cause kernel oopses, panics, and lots of
memory leaking.

The intent of this patch series is to provide the ground work so that
proper work (NAPI, locking re-design, ... see TODO) can be done.

All patches were tested on the "Mojave" (single port, PCI) card.

David Matlack (7):
  staging: slicoss: fix use-after-free in slic_entry_probe
  staging: slicoss: fix multiple free-after-free in slic_entry_remove
  staging: slicoss: remove unused members of struct adapter
  staging: slicoss: remove gratuitous debug infrastructure
  staging: slicoss: fix dma memory leak
  staging: slicoss: fix 64-bit isr address bug
  staging: slicoss: fix use-after-free bug in slic_entry_remove

 drivers/staging/slicoss/TODO      |   1 -
 drivers/staging/slicoss/slic.h    |   5 -
 drivers/staging/slicoss/slicoss.c | 487 ++------------------------------------
 3 files changed, 16 insertions(+), 477 deletions(-)

-- 
1.9.2

