Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaB1B1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 20:27:46 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:32926 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaB1B1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 20:27:44 -0500
X-Originating-IP: 172.56.33.66
Date: Thu, 27 Feb 2014 17:27:34 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH] cris: Make ETRAX_ARCH_V10 select TTY for use in debugport
Message-ID: <20140228012732.GA9890@thin>
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

arch/cris/arch-v10/kernel/debugport.c, compiled in unconditionally with
ETRAX_ARCH_V10, requires TTY, so select TTY to avoid a build failure.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/cris/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index ed0fcdf..7cb90a5 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -138,6 +138,7 @@ config ETRAX_ARCH_V10
        bool
        default y if ETRAX100LX || ETRAX100LX_V2
        default n if !(ETRAX100LX || ETRAX100LX_V2)
+       select TTY
 
 config ETRAX_ARCH_V32
        bool
-- 
1.9.0

