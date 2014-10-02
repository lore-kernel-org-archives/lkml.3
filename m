Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaJBNdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:33:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbaJBNdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:33:22 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: sam@ravnborg.org, yamada.m@jp.panasonic.com, linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: Do not reference *-n variables in the Makefile
Date: Thu,  2 Oct 2014 15:33:16 +0200
Message-Id: <1412256796-4111-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <20141002221754.3504.AA925319@jp.panasonic.com>
References: <20141002221754.3504.AA925319@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig options are either 'y', 'm', or undefined.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index efbd2cb..106f300 100644
--- a/Makefile
+++ b/Makefile
@@ -868,9 +868,7 @@ vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(net-y) $(net-m) $(libs-y) $(libs-m)))
 
 vmlinux-alldirs	:= $(sort $(vmlinux-dirs) $(patsubst %/,%,$(filter %/, \
-		     $(init-n) $(init-) \
-		     $(core-n) $(core-) $(drivers-n) $(drivers-) \
-		     $(net-n)  $(net-)  $(libs-n)    $(libs-))))
+		     $(init-) $(core-) $(drivers-) $(net-) $(libs-))))
 
 init-y		:= $(patsubst %/, %/built-in.o, $(init-y))
 core-y		:= $(patsubst %/, %/built-in.o, $(core-y))
-- 
1.8.4.5

