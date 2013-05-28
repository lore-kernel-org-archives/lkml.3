Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab3E1Bg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 21:36:59 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:45764 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab3E1Bg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 21:36:57 -0400
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, msalter@redhat.com,
        linux-c6x-dev@linux-c6x.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH v3 0/3] dma-mapping: Define dma_{alloc,free}_attrs() for all archs
Date: Tue, 28 May 2013 10:36:46 +0900
Message-Id: <1369705006-16298-1-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures that define CONFIG_HAS_DMA=y, have implementations for
both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
not define CONFIG_HAS_DMA also have both of these definitions provided by
dma-mapping-broken.h.

Provide a default definition for the archs that define CONFIG_HAS_DMA=y,
but have no implementation for dma_{alloc,free}_attrs(). 

As I don't have hardware for any of these systems, the patches are only
compile-tested where I could (arm64, s390) and untested for the archs
where I couldn't find a readily available prebuilt cross-compiler (c6x).

Changes from v2
---------------
Correct commit log. CONFIG_HAVE_DMA should be CONFIG_HAS_DMA.
Remove parisc from the patch series as it has already been merged.

Changes from v1
---------------
arm64, s390:
 * Since these archs are using dma_ops, pass appropirate value for attrs to 
   dma_ops->alloc().
 * Indicate that these patches are compile teseted only (I don't have hardware)

c6x:
 * Indicate that this patch is untested (I don't have a cross compiler)

Cheers,
Damian

Damian Hobson-Garcia (3):
  arm64: Provide default implementation for dma_{alloc,free}_attrs
  c6x: Provide default implementation for dma_{alloc,free}_attrs
  s390: Provide default implementation for dma_{alloc,free}_attrs

 arch/arm64/include/asm/dma-mapping.h |   17 +++++++++++------
 arch/c6x/include/asm/dma-mapping.h   |    3 +++
 arch/s390/include/asm/dma-mapping.h  |   17 +++++++++++------
 3 files changed, 25 insertions(+), 12 deletions(-)

-- 
1.7.9.5

