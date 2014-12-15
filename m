Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaLOIsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 03:48:17 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:36250 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaLOIsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 03:48:13 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 0/1] arm: Fix fallout from the access_once tree
Date: Mon, 15 Dec 2014 09:48:06 +0100
Message-Id: <1418633287-5019-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121508-0013-0000-0000-00000236CBCB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

the access_once tree in Linux next addresses an issue discussed in
http://marc.info/?i=54611D86.4040306%40de.ibm.com and
http://lwn.net/Articles/624126/

There is one small fallout left for the arm tree with rpc_defconfig:
http://kisskb.ellerman.id.au/kisskb/buildresult/12322985/

font.c:(.text+0x34): undefined reference to `data_access_exceeds_word_size'
font.c:(.text+0x9c): undefined reference to `data_access_exceeds_word_size'
make[3]: *** [arch/arm/boot/compressed/vmlinux] Error 1
make[2]: *** [arch/arm/boot/compressed/vmlinux] Error 2
make[1]: *** [zImage] Error 2
make: *** [sub-make] Error 2

Turns out that arch/arm/boot/compressed/Makefile does use
-Dstatic= which breaks compiler.h (which gets somehow included)

Can you Ack this change (or propose an alternative)
Thanks

Christian


Christian Borntraeger (1):
  arm/rpc: avoid static keyword removal via define

 arch/arm/boot/compressed/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
1.8.5.5

