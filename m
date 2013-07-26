Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084Ab3GZRI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:08:26 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:33524 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab3GZRIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:08:19 -0400
From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH 0/2] drivers/crypto/nx: fixes when input data is too large
Date: Fri, 26 Jul 2013 14:08:06 -0300
Message-Id: <1374858488-24658-1-git-send-email-mhcerri@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072617-1524-0000-0000-000006DA8AD0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes two bugs that are triggered when the input data is
too large. The first one is caused by the miscalculation of physical addresses
and the second one by some limits that the co-processor has to the input data.

Marcelo Cerri (2):
  drivers/crypto/nx: fix physical addresses added to sg lists
  drivers/crypto/nx: fix limits to sg lists for SHA-2

 drivers/crypto/nx/nx-sha256.c | 108 +++++++++++++++++++++++-----------------
 drivers/crypto/nx/nx-sha512.c | 113 ++++++++++++++++++++++++------------------
 drivers/crypto/nx/nx.c        |  22 ++++++--
 3 files changed, 148 insertions(+), 95 deletions(-)

-- 
1.7.12

