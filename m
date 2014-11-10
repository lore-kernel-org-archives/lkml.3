Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaKJI5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:57:39 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:56099 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaKJI5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:57:38 -0500
Date: Mon, 10 Nov 2014 16:57:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 3.18
Message-ID: <20141110085728.GA6685@gondor.apana.org.au>
References: <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20131203124129.GA12067@gondor.apana.org.au>
 <20131209115705.GA1361@gondor.apana.org.au>
 <20140101061016.GA22579@gondor.apana.org.au>
 <20140203125944.GA31446@gondor.apana.org.au>
 <20140710090314.GA15729@gondor.apana.org.au>
 <20140915113506.GA4736@gondor.apana.org.au>
 <20140924132720.GA31661@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924132720.GA31661@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes these issues:

* Stack corruption in pseries hwrng driver.
* Missing DMA unmap in caam crypto driver.
* NUMA crash in qat crypto driver.
* Buggy mapping of zero-length associated data in qat crypto driver.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Cristian Stoica (1):
      crypto: caam - fix missing dma unmap on error path

Greg Kurz (1):
      hwrng: pseries - port to new read API and fix stack corruption

Tadeusz Struk (2):
      crypto: qat - Prevent dma mapping zero length assoc data
      crypto: qat - Enforce valid numa configuration

 drivers/char/hw_random/pseries-rng.c              |   11 ++++---
 drivers/crypto/caam/key_gen.c                     |   29 +++++++++----------
 drivers/crypto/qat/qat_common/adf_accel_devices.h |    3 +-
 drivers/crypto/qat/qat_common/adf_transport.c     |   12 ++++----
 drivers/crypto/qat/qat_common/qat_algs.c          |    7 +++--
 drivers/crypto/qat/qat_common/qat_crypto.c        |    8 ++++--
 drivers/crypto/qat/qat_dh895xcc/adf_admin.c       |    2 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c         |   32 ++++++++-------------
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c         |    2 +-
 9 files changed, 53 insertions(+), 53 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
