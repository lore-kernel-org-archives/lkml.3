Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaJCJKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:10:07 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27255 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaJCJKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:10:04 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-f5-542e67e9fc7a
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, dhowells@redhat.com,
        jmorris@namei.org, rusty@rustcorp.com.au, keyrings@linux-nfs.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 0/4] KEYS fixes
Date: Fri, 03 Oct 2014 12:09:53 +0300
Message-id: <cover.1412327306.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t/xq7ov0/VCDO7/ZrO49Xcvs8W7pt8s
	Fl+W1lmsW7+YyWL2rocsFi9nzGO3uLxrDpvFh55HbBY3p11gsfi0YhKzA5fHzll32T2mnVjG
	4vHg0GYWj90LPjN59HxP9ni/7yqbx4oNJ5g9+rasYvT4vEkugDOKyyYlNSezLLVI3y6BK+PR
	/f1MBZ/YKvY8X8bawLiFtYuRk0NCwETi+/MzLBC2mMSFe+vZuhi5OIQEljJKvO+5zw7hdDJJ
	7Fx7gRmkik1AT2JD8w+whIjAUUaJaWeug41iFkiX+DSpFyjBwSEsIC/x/5wySJhFQFXi2KOz
	TCA2r4ClxKn2Q1Db5CROHpvMOoGRewEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkED7
	uoNx6TGrQ4wCHIxKPLwfbuiGCLEmlhVX5h5ilOBgVhLhPR2nFyLEm5JYWZValB9fVJqTWnyI
	kYmDU6qBMf/ToXf67h8Kud59Z6pwFdkc6tbBsHLuivR1F42X5XuVsx5hnVvapjupqKh+9tzw
	nkt6t2QXmx2wCi1Nj/e5lffCrV7iA9vDo7xvzjRUfl09S2D9jBCV8D0i2tseZZybeyp0zYIX
	NlsiPoq2Vpr/5qjPEr93487hmV/1T4ot0OFQ3qG268rrh0osxRmJhlrMRcWJANh41IgSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reported yesterday problems with new KEYS.
Module signature verification is broken, integrity subsystem verification is
broken, kernel oopses.

Here is few fixes.

- Dmitry

Dmitry Kasatkin (4):
  KEYS: handle error code encoded in pointer
  KEYS: provide pure subject key identifier (fingerprint) as key id
  module: search the key only by keyid
  integrity: do zero padding of the key id

 crypto/asymmetric_keys/asymmetric_type.c  | 27 ++++++++++++++++++++++++---
 crypto/asymmetric_keys/x509_cert_parser.c |  6 ++++++
 crypto/asymmetric_keys/x509_parser.h      |  1 +
 crypto/asymmetric_keys/x509_public_key.c  |  2 ++
 include/keys/asymmetric-type.h            |  2 +-
 kernel/module_signing.c                   | 16 +++++-----------
 security/integrity/digsig_asymmetric.c    |  2 +-
 7 files changed, 40 insertions(+), 16 deletions(-)

-- 
1.9.1

