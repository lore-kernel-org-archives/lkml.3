Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab3BCO7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:59:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34645 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600Ab3BCO63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:29 -0500
Message-Id: <20130203144654.453841821@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [ 118/128] staging: comedi: Kconfig: COMEDI_NI_AT_A2150 should  select COMEDI_FC
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 34ffb33e09132401872fe79e95c30824ce194d23 upstream.

The 'ni_at_a2150' module links to `cfc_write_to_buffer` in the
'comedi_fc' module, so selecting 'COMEDI_NI_AT_A2150' in the kernel
config needs to also select 'COMEDI_FC'.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 20008a4..727b207d 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -424,6 +424,7 @@ config COMEDI_ADQ12B
 
 config COMEDI_NI_AT_A2150
 	tristate "NI AT-A2150 ISA card support"
+	select COMEDI_FC
 	depends on COMEDI_NI_COMMON
 	depends on VIRT_TO_BUS
 	default N


