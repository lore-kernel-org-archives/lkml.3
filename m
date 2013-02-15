Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935644Ab3BOIxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 03:53:39 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16807 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab3BOIxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 03:53:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 15 Feb 2013 00:51:47 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-tegra@vger.kernel.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Michal Marek <mmarek@suse.cz>, Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 1/2] Makefile: Add arch/arch/$(hdr-arch)/boot in header include path
Date: Fri, 15 Feb 2013 10:52:38 +0200
Message-ID: <1360918364-27960-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a new feature dtc+cpp, DT can introduces some definitions in its
header files for their own. Some of those DT info can be used in
kernel source as well, instead of having the duplicate info in kernel
headers. This patch allows kernel source to include those DT
headers. For example:

+ #include <dts/tegra20-car.h>

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 0b4bf62..7f54cdb 100644
--- a/Makefile
+++ b/Makefile
@@ -364,7 +364,7 @@ LINUXINCLUDE    := \
 		-I$(srctree)/arch/$(hdr-arch)/include \
 		-Iarch/$(hdr-arch)/include/generated \
 		$(if $(KBUILD_SRC), -I$(srctree)/include) \
-		-Iinclude \
+		-Iinclude -Iarch/$(hdr-arch)/boot \
 		$(USERINCLUDE)
 
 KBUILD_CPPFLAGS := -D__KERNEL__
-- 
1.7.9.5

