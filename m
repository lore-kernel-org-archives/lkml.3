Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaKRNwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:52:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:36602 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbaKRNwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:52:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,410,1413270000"; 
   d="scan'208";a="609776216"
From: lukasz.anaczkowski@intel.com
To: m.chehab@samsung.com, dougthompson@xmission.com
Cc: bp@alien8.de, linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Snow <jim.m.snow@intel.com>, Jim Snow <jim.snow@intel.com>,
        Lukasz Anaczkowski <lukasz.anaczkowski@intel.com>
Subject: [PATCH 1/2] sb_edac: Fix off-by-one error in number of channels
Date: Tue, 18 Nov 2014 14:51:08 +0100
Message-Id: <1416318669-96322-2-git-send-email-lukasz.anaczkowski@intel.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416318669-96322-1-git-send-email-lukasz.anaczkowski@intel.com>
References: <1416318669-96322-1-git-send-email-lukasz.anaczkowski@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Snow <jim.m.snow@intel.com>

This prevented edac sysfs code from properly handling 6 channels
per memory controller.

Signed-off-by: Jim Snow <jim.snow@intel.com>
Signed-off-by: Lukasz Anaczkowski <lukasz.anaczkowski@intel.com>
---
 drivers/edac/edac_mc_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index a6cd361..670d282 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -372,7 +372,7 @@ static int edac_create_csrow_object(struct mem_ctl_info *mci,
 {
 	int err, chan;
 
-	if (csrow->nr_channels >= EDAC_NR_CHANNELS)
+	if (csrow->nr_channels > EDAC_NR_CHANNELS)
 		return -ENODEV;
 
 	csrow->dev.type = &csrow_attr_type;
-- 
2.0.4

--------------------------------------------------------------------

Intel Technology Poland sp. z o.o.
ul. Slowackiego 173 | 80-298 Gdansk | Sad Rejonowy Gdansk Polnoc | VII Wydzial Gospodarczy Krajowego Rejestru Sadowego - KRS 101882 | NIP 957-07-52-316 | Kapital zakladowy 200.000 PLN.

Ta wiadomosc wraz z zalacznikami jest przeznaczona dla okreslonego adresata i moze zawierac informacje poufne. W razie przypadkowego otrzymania tej wiadomosci, prosimy o powiadomienie nadawcy oraz trwale jej usuniecie; jakiekolwiek
przegladanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). If you are not the intended recipient, please contact the sender and delete all copies; any review or distribution by
others is strictly prohibited.

