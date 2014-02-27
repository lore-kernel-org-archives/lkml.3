Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaB0CNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:13:18 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53069 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbaB0CNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:13:15 -0500
X-Originating-IP: 50.43.14.201
Date: Wed, 26 Feb 2014 18:13:06 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH] s390: select CONFIG_TTY for use of tty in unconditional
 keyboard driver
Message-ID: <20140227021305.GA23659@thin>
References: <20140226191627.9adf3c8e1548e2016c16557c@canb.auug.org.au>
 <20140226100234.GA23064@thin>
 <20140227100026.1cc909f2722b16b6d11a7b91@canb.auug.org.au>
 <20140226231916.GB17589@jtriplet-mobl1>
 <20140227104211.b2a4a5a1066fcf8ac2640ce3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227104211.b2a4a5a1066fcf8ac2640ce3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unconditionally built keyboard driver, drivers/s390/char/keyboard.c,
requires CONFIG_TTY, so select it from CONFIG_S390 to prevent a build
error.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/s390/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 65a0775..398efa1 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -140,6 +140,7 @@ config S390
 	select OLD_SIGACTION
 	select OLD_SIGSUSPEND3
 	select SYSCTL_EXCEPTION_TRACE
+	select TTY
 	select VIRT_CPU_ACCOUNTING
 	select VIRT_TO_BUS
 
-- 
1.9.0

