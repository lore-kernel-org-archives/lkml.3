Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbaGXNo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:44:26 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:50601 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758894AbaGXNoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:44:24 -0400
Date: Thu, 24 Jul 2014 10:44:18 -0300
From: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mhcerri@linux.vnet.ibm.com, fin@linux.vnet.ibm.com
Subject: [PATCH 0/8] NX crypto driver reestructure
Message-ID: <20140724134414.GA22921@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072413-1820-0000-0000-0000011B7EA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This set of patches deals with the reescruture of NX driver replacing the
use of spinlocks, that assure crypto context concurrency, by a copy of crypto 
ctx to another region of memory in order to be used by the current algorithm.
As this region of memory tends to be used constantly also was added a kmemcache
chunk avoiding the cost of constant allocations.


Leonidas Da Silva Barbosa (8):
  Adding nx_copy_ctx and kmemcache to handle with crypto context
  Replacing spinlocks by nx_copy_ctx on NX-AES-CBC
  Replacing spinlocks by nx_copy_ctx on NX-AES-CCM
  Replacing spinlocks by nx_copy_ctx on NX-AES-CTR
  Replacing spinlocks by nx_copy_ctx on NX-AES-ECB
  Replacing spinlocks by nx_copy_ctx on NX-AES-GCM
  Replacing spinlocks by nx_copy_ctx on NX-AES-XCBC
  Replacing spinlocks by nx_copy_ctx on NX-SHA256 and NX-SHA512

 drivers/crypto/nx/nx-aes-cbc.c  |   20 +++++++----
 drivers/crypto/nx/nx-aes-ccm.c  |   42 ++++++++++++++---------
 drivers/crypto/nx/nx-aes-ctr.c  |   20 +++++++----
 drivers/crypto/nx/nx-aes-ecb.c  |   20 +++++++----
 drivers/crypto/nx/nx-aes-gcm.c  |   64 +++++++++++++++++++----------------
 drivers/crypto/nx/nx-aes-xcbc.c |   51 ++++++++++++++++------------
 drivers/crypto/nx/nx-sha256.c   |   70 ++++++++++++++++++++++++---------------
 drivers/crypto/nx/nx-sha512.c   |   70 ++++++++++++++++++++++++---------------
 drivers/crypto/nx/nx.c          |   45 ++++++++++++++++++++++++-
 drivers/crypto/nx/nx.h          |    8 +++--
 10 files changed, 259 insertions(+), 151 deletions(-)

