Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab3LCMlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:41:39 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:35812 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3LCMlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:41:36 -0500
Date: Tue, 3 Dec 2013 20:41:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 3.13
Message-ID: <20131203124129.GA12067@gondor.apana.org.au>
References: <20100903060055.GA28915@gondor.apana.org.au>
 <20100903110722.GA31826@gondor.apana.org.au>
 <20101215115035.GA25248@gondor.apana.org.au>
 <20110216053911.GA10999@gondor.apana.org.au>
 <20110328071322.GA6569@gondor.apana.org.au>
 <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130328082841.GA7425@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a number of crashes triggered by a previous
crypto self-test update.  It also fixes a build problem in the
caam driver, as well as a concurrency issue in s390.  Finally
there is a pair of fixes to bugs in the crypto scatterwalk code
and authenc that may lead to crashes.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Gerald Schaefer (1):
      crypto: s390 - Fix aes-xts parameter corruption

Horia Geanta (5):
      crypto: talitos - corrrectly handle zero-length assoc data
      crypto: ccm - Fix handling of zero plaintext when computing mac
      crypto: caam - fix aead sglen for case 'dst != src'
      crypto: talitos - fix aead sglen for case 'dst != src'
      crypto: testmgr - fix sglen in test_aead for case 'dst != src'

Michael Neuling (1):
      crypto: caam - Add missing Job Ring include

Tom Lendacky (2):
      crypto: authenc - Find proper IV address in ablkcipher callback
      crypto: scatterwalk - Set the chain pointer indication bit

 arch/s390/crypto/aes_s390.c   |   31 ++++++++++--------
 crypto/authenc.c              |    7 ++--
 crypto/ccm.c                  |    3 +-
 crypto/tcrypt.c               |    4 ++
 crypto/testmgr.c              |   26 +++++++--------
 drivers/crypto/caam/caamalg.c |   51 +++++++++++++++++-------------
 drivers/crypto/caam/jr.c      |    1 +
 drivers/crypto/talitos.c      |   68 +++++++++++++++++++++++-----------------
 include/crypto/scatterwalk.h  |    1 +
 9 files changed, 109 insertions(+), 83 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
