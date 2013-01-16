Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194Ab3APQME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:12:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36995 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160Ab3APQL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:11:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 222/222] staging: comedi: Kconfig: COMEDI_NI_AT_A2150 should select COMEDI_FC
Date: Wed, 16 Jan 2013 13:57:02 -0200
Message-Id: <1358351822-7675-223-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 34ffb33e09132401872fe79e95c30824ce194d23 upstream.

The 'ni_at_a2150' module links to `cfc_write_to_buffer` in the
'comedi_fc' module, so selecting 'COMEDI_NI_AT_A2150' in the kernel config
needs to also select 'COMEDI_FC'.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/comedi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 3bbe3fd..e1ec629 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -447,6 +447,7 @@ config COMEDI_ADQ12B
 
 config COMEDI_NI_AT_A2150
 	tristate "NI AT-A2150 ISA card support"
+	select COMEDI_FC
 	depends on COMEDI_NI_COMMON
 	depends on VIRT_TO_BUS
 	---help---
-- 
1.7.9.5

