Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbaGYOYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:24:23 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:53974 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753196AbaGYOYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:24:20 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>, paul@pwsan.com,
        Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, arm@kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 4/5] [SCSI] Do not use platform_bus as a parent
Date: Fri, 25 Jul 2014 15:23:52 +0100
Message-Id: <1406298233-27876-4-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The host devices without a parent were "forcefully adopted"
by platform bus. This patch removes this assignment. In
effect the dev_dev may be NULL now, which means ISA.

Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---

This patch is a part of effort to remove references to platform_bus
and make it static.

James, could you please have a look and advice if the change is
correct? Would you happen to know the "real reasons" behind
using the root platform_bus device a parent?

 drivers/scsi/hosts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3cbb57a..0c7389f 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -218,7 +218,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto fail;
 
 	if (!shost->shost_gendev.parent)
-		shost->shost_gendev.parent = dev ? dev : &platform_bus;
+		shost->shost_gendev.parent = dev;
 	if (!dma_dev)
 		dma_dev = shost->shost_gendev.parent;
 
-- 
1.9.1

