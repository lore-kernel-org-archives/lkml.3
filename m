Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab3DVFIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:08:00 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:38993 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab3DVFH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:07:59 -0400
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, msalter@redhat.com,
        linux-c6x-dev@linux-c6x.org, deller@gmx.de,
        linux-parisc@vger.kernel.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [RFC/PATCH 0/4] dma-mapping: Define dma_{alloc,free}_attrs() for all archs
Date: Mon, 22 Apr 2013 14:07:40 +0900
Message-Id: <1366607260-2852-1-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures that define CONFIG_HAVE_DMA=y, have implementations for
both dma_alloc_attrs() and dma_free_attrs().  All achitectures that do
not define CONFIG_HAVE_DMA also have both of these definitions provided by
dma-mapping-broken.h.

Provide a default definition for the archs that define CONFIG_HAVE_DMA=y,
but have no implementation for dma_{alloc,free}_attrs() by simply calling
dma_{alloc,free}_coherent() and throwing away the attrs argument.

Damian Hobson-Garcia (4):
  Provide default implementation for dma_{alloc,free}_attrs on arm64
  Provide default implementation for dma_{alloc,free}_attrs on c6x
  Provide default implementation for dma_{alloc,free}_attrs on parisc
  Provide default implementation for dma_{alloc,free}_attrs on s390

 arch/arm64/include/asm/dma-mapping.h  |    3 +++
 arch/c6x/include/asm/dma-mapping.h    |    3 +++
 arch/parisc/include/asm/dma-mapping.h |    3 +++
 arch/s390/include/asm/dma-mapping.h   |    3 +++
 4 files changed, 12 insertions(+), 0 deletions(-)

-- 
1.7.5.4

