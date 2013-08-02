Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3HBMKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 08:10:04 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:57649 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3HBMKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 08:10:00 -0400
From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH v2 0/2] drivers/crypto/nx: fixes when input data is too large
Date: Fri,  2 Aug 2013 09:09:50 -0300
Message-Id: <1375445392-16237-1-git-send-email-mhcerri@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080212-8936-0000-0000-00000AEA8C89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes two bugs that are triggered when the input data is
too large. The first one is caused by the miscalculation of physical addresses
and the second one by some limits that the co-processor has to the input data.

Changes in v2:
        * Replace Signed-Off-By tags with Reviewed-By tags where it is
	  appropriate.

Marcelo Cerri (2):
  drivers/crypto/nx: fix physical addresses added to sg lists
  drivers/crypto/nx: fix limits to sg lists for SHA-2

 drivers/crypto/nx/nx-sha256.c | 108 +++++++++++++++++++++++-----------------
 drivers/crypto/nx/nx-sha512.c | 113 ++++++++++++++++++++++++------------------
 drivers/crypto/nx/nx.c        |  22 ++++++--
 3 files changed, 148 insertions(+), 95 deletions(-)

-- 
1.7.12

