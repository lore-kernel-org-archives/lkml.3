Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaCZOeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:34:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26336 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaCZOeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:34:02 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-e7-5332e5575b76
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ata: fix ARASAN CompactFlash PATA driver dependencies
Date: Wed, 26 Mar 2014 15:33:37 +0100
Message-id: <1565826.7Ejj6LS6x7@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jAd3wp0bBBptuGltsenyN1eLYjkdM
	Fpd3zWGzaOjuYbeYM2Mzq8Wv5UcZLVZe/MvswO6xc9Zddo9NqzrZPE5eOMnisXlJvcfTH3uZ
	PT5vkgtgi+KySUnNySxLLdK3S+DK6Ph2kqXgLnvFwa8H2BsYD7N1MXJySAiYSExet5MJwhaT
	uHBvPVCci0NIYBGjxIdDS1khnBYmifVrnzKCVLEJWElMbF8FZosIyEpcmfaQEaSIWeAso8S6
	k7PZQRLCAm4S77ung41lEVCV6Nm0H6yBV0BT4viWJ2A1ogKeEju2r2SDiAtK/Jh8jwXEZhaQ
	l9i3fyorhK0lsX7ncaYJjHyzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5
	mxjBAfxMegfjqgaLQ4wCHIxKPLw77hsFC7EmlhVX5h5ilOBgVhLhFb4BFOJNSaysSi3Kjy8q
	zUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cAopbJDLVMpxyNFetmSNye1npmt
	UG39KWlzQj8mjGfavjJpa4kf3+JmBk+d+olr4u7jHyQXSEqKMdwV3PfzyUn2uLJP0ds0l5ps
	+3xcpbFzdcSjP+zrdtuvVqzsCmh1YNy0RmffzxDj+dYPLZwUu6JWSse8vTJ3ko3J8enzLJU/
	bmJN4644tn6qEktxRqKhFnNRcSIAlyyzwVwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pata_arasan_cf host driver depend on ARCH_SPEAR13XX config
option as ARASAN CompactFlash PATA support is specific to ST
SPEAr13xx SoCs and the driver to work requires suitable device
tree node (or platform device) to be defined.  Additionally
allow the driver build if COMPILE_TEST config option is set.

Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig	2014-03-26 15:09:47.395143062 +0100
+++ b/drivers/ata/Kconfig	2014-03-26 15:21:29.535131088 +0100
@@ -378,6 +378,7 @@ config PATA_AMD
 
 config PATA_ARASAN_CF
 	tristate "ARASAN CompactFlash PATA Controller Support"
+	depends on ARCH_SPEAR13XX || COMPILE_TEST
 	depends on DMADEVICES
 	select DMA_ENGINE
 	help

