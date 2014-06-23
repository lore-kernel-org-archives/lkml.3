Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaFWHNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:13:21 -0400
Received: from mail.eperm.de ([89.247.134.16]:39149 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaFWHNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:13:20 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: kbuild test robot <fengguang.wu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: kbuild@01.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rafael Aquini <aquini@redhat.com>
Subject: [PATCH v2] DRBG: simplify ordering of linked list in drbg_ctr_df
Date: Mon, 23 Jun 2014 09:10:11 +0200
Message-ID: <5069712.neqH4zuI9U@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.8-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch superseeds and replaces the initial fix submitted with [1].
After careful analysis of the code, the anticipated NULL pointer
deference is caught in drbg_ctr_update which only invokes drbg_ctr_df
when addtl is not NULL.

This patch is tested with CAVS testing and the test set provided in [2].

[1] https://lkml.org/lkml/2014/6/21/70
[2] http://www.chronox.de/drbg.html

Stephan Mueller (1):
  DRBG: simplify ordering of linked list in drbg_ctr_df

 crypto/drbg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
1.9.3


