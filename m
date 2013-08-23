Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3HWUBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:01:40 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:53168 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab3HWUBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:01:37 -0400
From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH 00/10] Series of fixes for NX driver
Date: Fri, 23 Aug 2013 17:01:04 -0300
Message-Id: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082320-2362-0000-0000-00000B92FEC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches contains fixes in several algorithms implemented
by the NX driver. The patches can be separated in three different
categories:

 - Changes to split the data in several hyper calls to respect the
   limits of data that the co-processador can handle. This affects
   all AES modes.
 - Fixes in how the driver handle zero length messages. This affects
   XCBC and GCM.
 - Fixes for SHA-2 when chunks bigger than the block size are provided.

Fionnuala Gunter (2):
  crypto: nx - fix limits to sg lists for AES-XCBC
  crypto: nx - fix limits to sg lists for AES-CCM

Marcelo Cerri (8):
  crypto: nx - add offset to nx_build_sg_lists()
  crypto: nx - fix limits to sg lists for AES-ECB
  crypto: nx - fix limits to sg lists for AES-CBC
  crypto: nx - fix limits to sg lists for AES-CTR
  crypto: nx - fix limits to sg lists for AES-GCM
  crypto: nx - fix XCBC for zero length messages
  crypto: nx - fix GCM for zero length messages
  crypto: nx - fix SHA-2 for chunks bigger than block size

 drivers/crypto/nx/nx-aes-cbc.c  |  50 ++++---
 drivers/crypto/nx/nx-aes-ccm.c  | 297 +++++++++++++++++++++++++++++-----------
 drivers/crypto/nx/nx-aes-ctr.c  |  50 ++++---
 drivers/crypto/nx/nx-aes-ecb.c  |  48 ++++---
 drivers/crypto/nx/nx-aes-gcm.c  | 292 ++++++++++++++++++++++++++++++---------
 drivers/crypto/nx/nx-aes-xcbc.c | 191 +++++++++++++++++++-------
 drivers/crypto/nx/nx-sha256.c   |   2 +-
 drivers/crypto/nx/nx-sha512.c   |   2 +-
 drivers/crypto/nx/nx.c          |   9 +-
 drivers/crypto/nx/nx.h          |   2 +-
 10 files changed, 683 insertions(+), 260 deletions(-)

-- 
1.7.12

