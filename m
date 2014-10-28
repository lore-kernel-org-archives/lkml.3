Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaJ1RkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:40:19 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:57575 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaJ1RkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:40:17 -0400
Date: Tue, 28 Oct 2014 15:40:09 -0200
From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
        Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>
Subject: [PATCH 0/9] NX crypto driver fixes
Message-ID: <20141028174006.GA15893@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102817-0005-0000-0000-000000E805ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes the follow issues in  NX crypto driver:

  - Bound limit issue that causes a memory crash
  - SHA concurrence issue
  - IV vector fix with the correct bit order
  - NX CCM does not support keys larger than 128 causing
  crashes in fips mode.


Leonidas S. Barbosa (9):
  Moving NX-AES-CBC to be process logic
  Moving NX-AES-CCM to be process logic and sg_list bounds
  Moving limit and bound logic in CTR and fix IV vector
  Moving NX-AES-ECB to be processed logic
  Moving NX-AES-GCM to be processed logic
  Moving NX-AES-XCBC to be processed logic
  Fix SHA concurrence issue and sg limit bounds
  Fixing the limit number of bytes to be processed
  Disable ccm and ccm4309 in fips mod

 drivers/crypto/nx/nx-aes-cbc.c  |   12 +--
 drivers/crypto/nx/nx-aes-ccm.c  |   61 +++++------
 drivers/crypto/nx/nx-aes-ctr.c  |   13 +--
 drivers/crypto/nx/nx-aes-ecb.c  |   12 +--
 drivers/crypto/nx/nx-aes-gcm.c  |   66 +++++++-----
 drivers/crypto/nx/nx-aes-xcbc.c |   81 +++++++++++---
 drivers/crypto/nx/nx-sha256.c   |  208 ++++++++++++++++++-------------------
 drivers/crypto/nx/nx-sha512.c   |  222 ++++++++++++++++++---------------------
 drivers/crypto/nx/nx.c          |  159 +++++++++++++++++++++++-----
 drivers/crypto/nx/nx.h          |    8 +-
 10 files changed, 469 insertions(+), 373 deletions(-)

