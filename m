Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3F0Evy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 00:51:54 -0400
Received: from intranet.asianux.com ([58.214.24.6]:7692 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab3F0Evw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 00:51:52 -0400
X-Spam-Score: -100.9
Message-ID: <51CBC4B3.807@asianux.com>
Date: Thu, 27 Jun 2013 12:50:59 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hirokazu Takata <takata@linux-m32r.org>
CC: "dhowells@redhat.com" <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: m32r: include: asm: add "dma-mapping-common.h"
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need add generic "dma-mapping-common.h", or compiling may fail.

The related error (with allmodconfig):

    CC [M]  net/irda/irlan/irlan_eth.o
  drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
  drivers/media/v4l2-core/videobuf2-dma-contig.c:202:2: error: implicit declaration of function ‘dma_mmap_coherent’ [-Werror=implicit-function-declaration]
  drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
  drivers/media/v4l2-core/videobuf2-dma-contig.c:385:2: error: implicit declaration of function ‘dma_get_sgtable’ [-Werror=implicit-function-declaration]


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/m32r/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index bebdc36..fecca22 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -1,5 +1,6 @@
 
 generic-y += clkdev.h
+generic-y += dma-mapping-common.h
 generic-y += exec.h
 generic-y += module.h
 generic-y += trace_clock.h
-- 
1.7.7.6
