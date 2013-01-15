Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab3AOWc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:32:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:42942 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417Ab3AOWcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 142/221] staging: comedi: Kconfig: COMEDI_NI_AT_A2150 should select COMEDI_FC
Date: Tue, 15 Jan 2013 10:51:09 -0800
Message-Id: <20130115185008.320656704@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 34ffb33e09132401872fe79e95c30824ce194d23 upstream.

The 'ni_at_a2150' module links to `cfc_write_to_buffer` in the
'comedi_fc' module, so selecting 'COMEDI_NI_AT_A2150' in the kernel config
needs to also select 'COMEDI_FC'.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -444,6 +444,7 @@ config COMEDI_ADQ12B
 
 config COMEDI_NI_AT_A2150
 	tristate "NI AT-A2150 ISA card support"
+	select COMEDI_FC
 	depends on VIRT_TO_BUS
 	---help---
 	  Enable support for National Instruments AT-A2150 cards


