Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaLEWqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:46:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaLEWpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Cowgill <James.Cowgill@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>, Huacai Chen <chenhc@lemote.com>,
        linux-mips@linux-mips.org, Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.17 005/122] MIPS: Loongson3: Fix __node_distances undefined error
Date: Fri,  5 Dec 2014 14:42:59 -0800
Message-Id: <20141205223306.348443973@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Cowgill <James.Cowgill@imgtec.com>

commit 21255dad9dffa4407cab866f5561cb9568f7f7d8 upstream.

export the __node_distances symbol in the loongson3 numa code to fix the
build error:

  Building modules, stage 2.
  MODPOST 221 modules
ERROR: "__node_distances" [drivers/block/nvme.ko] undefined!
scripts/Makefile.modpost:90: recipe for target '__modpost' failed

when building the kernel with:
 CONFIG_CPU_LOONGSON3=y
 CONFIG_NUMA=y
 CONFIG_BLK_DEV_NVME=m

Signed-off-by: James Cowgill <James.Cowgill@imgtec.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Reviewed-by: Huacai Chen <chenhc@lemote.com>
Cc: linux-mips@linux-mips.org
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Patchwork: https://patchwork.linux-mips.org/patch/8444/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/loongson/loongson-3/numa.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/loongson/loongson-3/numa.c
+++ b/arch/mips/loongson/loongson-3/numa.c
@@ -33,6 +33,7 @@
 
 static struct node_data prealloc__node_data[MAX_NUMNODES];
 unsigned char __node_distances[MAX_NUMNODES][MAX_NUMNODES];
+EXPORT_SYMBOL(__node_distances);
 struct node_data *__node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(__node_data);
 


