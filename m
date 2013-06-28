Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3F1NrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:47:02 -0400
Received: from smtp.citrix.com ([66.165.176.89]:6000 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab3F1Nqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:46:42 -0400
X-IronPort-AV: E=Sophos;i="4.87,958,1363132800"; 
   d="scan'208";a="34084481"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <xen-devel@lists.xen.org>
CC: Ben Guthro <benjamin.guthro@citrix.com>,
        <tboot-devel@lists.sourceforge.net>, Gang Wei <gang.wei@intel.com>
Subject: [PATCH v5 4/5] x86/tboot: Fail extended mode reduced hardware sleep
Date: Fri, 28 Jun 2013 09:46:23 -0400
Message-ID: <1372427184-6197-5-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372427184-6197-1-git-send-email-benjamin.guthro@citrix.com>
References: <1372427184-6197-1-git-send-email-benjamin.guthro@citrix.com>
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
---
 arch/x86/kernel/tboot.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index d578c9c..57383b2 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -285,6 +285,9 @@ static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control,
 	if (!tboot_enabled())
 		return 0;
 
+	if (extended)
+		return -1;
+
 	tboot_copy_fadt(&acpi_gbl_FADT);
 	tboot->acpi_sinfo.pm1a_cnt_val = pm1a_control;
 	tboot->acpi_sinfo.pm1b_cnt_val = pm1b_control;
-- 
1.7.9.5

