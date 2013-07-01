Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3GALtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 07:49:10 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:14022 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab3GALtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 07:49:07 -0400
X-IronPort-AV: E=Sophos;i="4.87,974,1363132800"; 
   d="scan'208";a="32763353"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <xen-devel@lists.xen.org>
CC: Ben Guthro <benjamin.guthro@citrix.com>,
        <tboot-devel@lists.sourceforge.net>, Gang Wei <gang.wei@intel.com>
Subject: [PATCH v6 4/5] x86/tboot: Fail extended mode reduced hardware sleep
Date: Mon, 1 Jul 2013 07:48:52 -0400
Message-ID: <1372679333-8473-5-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372679333-8473-1-git-send-email-benjamin.guthro@citrix.com>
References: <1372679333-8473-1-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As tboot currently does not support the reduced hardware sleep
interface, fail this extended call.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
Cc: tboot-devel@lists.sourceforge.net
Cc: Gang Wei <gang.wei@intel.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/tboot.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index d578c9c..76c284f 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -285,6 +285,12 @@ static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control,
 	if (!tboot_enabled())
 		return 0;
 
+	if (extended)
+	if (WARN(extended,"tboot is not able to suspend on platforms with"
+	    " reduced hardware sleep (ACPIv5). Please contact"
+	    " tboot-devel@lists.sourceforge.net mailing list."))
+		return -1;
+
 	tboot_copy_fadt(&acpi_gbl_FADT);
 	tboot->acpi_sinfo.pm1a_cnt_val = pm1a_control;
 	tboot->acpi_sinfo.pm1b_cnt_val = pm1b_control;
-- 
1.7.9.5

