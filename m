Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab3FJWLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:11:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab3FJWLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:11:19 -0400
Date: Mon, 10 Jun 2013 15:11:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, Russ Anderson <rja@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v11 resend 10/11] arm, change reboot_mode to use enum
 reboot_mode
Message-Id: <20130610151112.26c71baa4127ed931d913215@linux-foundation.org>
In-Reply-To: <1370519244-49918-11-git-send-email-holt@sgi.com>
References: <1370519244-49918-1-git-send-email-holt@sgi.com>
	<1370519244-49918-11-git-send-email-holt@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Jun 2013 06:47:23 -0500 Robin Holt <holt@sgi.com> wrote:

> Preparing to move the parsing of reboot= to generic kernel code
> forces the change in reboot_mode handling to use the enum.
> 
> ...
>
>  125 files changed, 282 insertions(+), 166 deletions(-)

That's a big patch.  The potential for ARM breakage is high.  I spotted
one glitch:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: arm-change-reboot_mode-to-use-enum-reboot_mode-fix

fix arch/arm/mach-socfpga/socfpga.c

Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-socfpga/socfpga.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-socfpga/socfpga.c~arm-change-reboot_mode-to-use-enum-reboot_mode-fix arch/arm/mach-socfpga/socfpga.c
--- a/arch/arm/mach-socfpga/socfpga.c~arm-change-reboot_mode-to-use-enum-reboot_mode-fix
+++ a/arch/arm/mach-socfpga/socfpga.c
@@ -97,7 +97,7 @@ static void socfpga_cyclone5_restart(enu
 
 	temp = readl(rst_manager_base_addr + SOCFPGA_RSTMGR_CTRL);
 
-	if (mode == 'h')
+	if (mode == REBOOT_HARD)
 		temp |= RSTMGR_CTRL_SWCOLDRSTREQ;
 	else
 		temp |= RSTMGR_CTRL_SWWARMRSTREQ;
_

