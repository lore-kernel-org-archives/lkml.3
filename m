Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaDCQTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:19:08 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:55959 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbaDCQTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:19:02 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 0/9] Add Qualcomm crypto driver
Date: Thu,  3 Apr 2014 19:17:57 +0300
Message-Id: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patch set implements support for Qualcomm
crypto hardware accelerator driver. It registers itself
to the crypto subsystem and adds the following operations
for encryption/decription - AES with ECB CBC CTR XTS modes,
DES with ECB CBC modes, and 3DES ECB CBC modes.
For hashing and MAC it adds support for sha1 sha256,
hmac(sha1) hmac(sha256).

The version of the driver is reworked by me and it is based
on Codeaurora's qcrypto driver. The proposed version has many
coding style fixes, re-factored files, separated by
functionality. I wanted to make the driver more readable and
easier for review, hope I done well. I'll appreciate any review
comments which will help me to make this code clear and ready
for mainline kernel.

regards,
Stan

Stanimir Varbanov (9):
  crypto: qce: Add core driver implementation
  crypto: qce: Add register defines
  crypto: qce: Add dma and sg helpers
  crypto: qce: Add ablkcipher algorithms
  crypto: qce: Adds sha and hmac transforms
  crypto: qce: Adds infrastructure to setup the crypto block
  crypto: qce: Adds Makefile to build the driver
  crypto: qce: Build Qualcomm qce driver
  ARM: DT: qcom: Add Qualcomm crypto driver binding document

 .../devicetree/bindings/crypto/qcom-qce.txt        |  25 +
 drivers/crypto/Kconfig                             |  10 +
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/qce/Makefile                        |   6 +
 drivers/crypto/qce/ablkcipher.c                    | 397 ++++++++++++++
 drivers/crypto/qce/cipher.h                        |  62 +++
 drivers/crypto/qce/common.c                        | 424 +++++++++++++++
 drivers/crypto/qce/common.h                        | 111 ++++
 drivers/crypto/qce/core.c                          | 333 ++++++++++++
 drivers/crypto/qce/core.h                          |  69 +++
 drivers/crypto/qce/dma.c                           | 201 +++++++
 drivers/crypto/qce/dma.h                           |  57 ++
 drivers/crypto/qce/regs-v5.h                       | 327 +++++++++++
 drivers/crypto/qce/sha.c                           | 595 +++++++++++++++++++++
 drivers/crypto/qce/sha.h                           |  74 +++
 15 files changed, 2692 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/qcom-qce.txt
 create mode 100644 drivers/crypto/qce/Makefile
 create mode 100644 drivers/crypto/qce/ablkcipher.c
 create mode 100644 drivers/crypto/qce/cipher.h
 create mode 100644 drivers/crypto/qce/common.c
 create mode 100644 drivers/crypto/qce/common.h
 create mode 100644 drivers/crypto/qce/core.c
 create mode 100644 drivers/crypto/qce/core.h
 create mode 100644 drivers/crypto/qce/dma.c
 create mode 100644 drivers/crypto/qce/dma.h
 create mode 100644 drivers/crypto/qce/regs-v5.h
 create mode 100644 drivers/crypto/qce/sha.c
 create mode 100644 drivers/crypto/qce/sha.h

-- 
1.8.4.4

