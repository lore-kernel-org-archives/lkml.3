Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422896Ab3BANOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:14:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:45492 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422847Ab3BANOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:14:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Abdallah Chatila <abdallah.chatila@ericsson.com>
Subject: [ 74/89] x86/Sandy Bridge: Sandy Bridge workaround depends on CONFIG_PCI
Date: Fri,  1 Feb 2013 14:08:29 +0100
Message-Id: <20130201130212.810192524@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit e43b3cec711a61edf047adf6204d542f3a659ef8 upstream.

early_pci_allowed() and read_pci_config_16() are only available if
CONFIG_PCI is defined.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Abdallah Chatila <abdallah.chatila@ericsson.com>

---
 arch/x86/kernel/setup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -616,6 +616,7 @@ static unsigned reserve_low = CONFIG_X86
 
 static bool __init snb_gfx_workaround_needed(void)
 {
+#ifdef CONFIG_PCI
 	int i;
 	u16 vendor, devid;
 	static const u16 snb_ids[] = {
@@ -640,6 +641,7 @@ static bool __init snb_gfx_workaround_ne
 	for (i = 0; i < ARRAY_SIZE(snb_ids); i++)
 		if (devid == snb_ids[i])
 			return true;
+#endif
 
 	return false;
 }


