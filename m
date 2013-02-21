Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3BUIsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:48:06 -0500
Received: from mailsit.unilogicnetworks.net ([62.133.206.125]:43493 "EHLO
	mail.unilogicnetworks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab3BUIsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:48:04 -0500
X-Greylist: delayed 1857 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2013 03:48:04 EST
Message-ID: <5125D800.4090509@unilogicnetworks.net>
Date: Thu, 21 Feb 2013 09:17:04 +0100
From: Pascal de Bruijn <pascal@unilogicnetworks.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Expand Dell OptiPlex 760 reboot quirk
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different DMI_BOARD_NAME's are affected by this reboot issue as well,
so we want to expand the quirk coverage by removing the DMI_BOARD_NAME
match.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=54051
BugLink: https://bugs.launchpad.net/bugs/488319

Signed-off-by: Pascal de Bruijn <pascal@unilogicnetworks.net>
---
  arch/x86/kernel/reboot.c |    1 -
  1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 76fa1e9..33b6362 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -299,7 +299,6 @@ static struct dmi_system_id __initdata 
reboot_dmi_table[] = {
  		.matches = {
  			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
  			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 760"),
-			DMI_MATCH(DMI_BOARD_NAME, "0G919G"),
  		},
  	},
  	{	/* Handle problems with rebooting on Dell 2400's */
-- 
1.7.9.5

