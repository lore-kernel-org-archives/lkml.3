Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935521Ab3E3QUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:20:11 -0400
Received: from smtp.citrix.com ([66.165.176.89]:64500 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934203Ab3E3QS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:18:59 -0400
X-IronPort-AV: E=Sophos;i="4.87,772,1363132800"; 
   d="scan'208";a="28290762"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <Stefano.Stabellini@eu.citrix.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <Ian.Campbell@citrix.com>,
        <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH RFC 1/6] [HACK!] arm64/xen: create links to arch/arm include files and Xen code
Date: Thu, 30 May 2013 17:18:28 +0100
Message-ID: <1369930713-6063-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305301705500.4799@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305301705500.4799@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of Xen support for ARM is common between ARMv7 and ARMv8.
Create links to the code under arch/arm (bleah).

Other, probably better alternatives:

- move the code to a different location, maybe the header files to
include/xen/arm and the code to drivers/xen/arm (still pretty ugly)?

- create a copy of the code to arch/arm64 (even worse);

Please advice on how you would like me to move forward on this.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm64/include/asm/xen   |    1 +
 arch/arm64/xen/enlighten.c   |    1 +
 arch/arm64/xen/grant-table.c |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)
 create mode 120000 arch/arm64/include/asm/xen
 create mode 120000 arch/arm64/xen/enlighten.c
 create mode 120000 arch/arm64/xen/grant-table.c

diff --git a/arch/arm64/include/asm/xen b/arch/arm64/include/asm/xen
new file mode 120000
index 0000000..c27d6980
--- /dev/null
+++ b/arch/arm64/include/asm/xen
@@ -0,0 +1 @@
+../../../arm/include/asm/xen
\ No newline at end of file
diff --git a/arch/arm64/xen/enlighten.c b/arch/arm64/xen/enlighten.c
new file mode 120000
index 0000000..cb31b7c
--- /dev/null
+++ b/arch/arm64/xen/enlighten.c
@@ -0,0 +1 @@
+../../arm/xen/enlighten.c
\ No newline at end of file
diff --git a/arch/arm64/xen/grant-table.c b/arch/arm64/xen/grant-table.c
new file mode 120000
index 0000000..5494f6c
--- /dev/null
+++ b/arch/arm64/xen/grant-table.c
@@ -0,0 +1 @@
+../../arm/xen/grant-table.c
\ No newline at end of file
-- 
1.7.2.5

