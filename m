Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbaCYRRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:17:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55594 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbaCYRRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:17:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 04/81] sata_sil: apply MOD15WRITE quirk to TOSHIBA MK2561GSYN
Date: Tue, 25 Mar 2014 10:15:17 -0700
Message-Id: <1395767794-5012-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 9f9c47f00ce99329b1a82e2ac4f70f0fe3db549c upstream.

It's a bit odd to see a newer device showing mod15write; however, the
reported behavior is highly consistent and other factors which could
contribute seem to have been verified well enough.  Also, both
sata_sil itself and the drive are fairly outdated at this point making
the risk of this change fairly low.  It is possible, probably likely,
that other drive models in the same family have the same problem;
however, for now, let's just add the specific model which was tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: matson <lists-matsonpa@luxsci.me>
References: http://lkml.kernel.org/g/201401211912.s0LJCk7F015058@rs103.luxsci.com
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/sata_sil.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index a7b3167..3369d31 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -157,6 +157,7 @@ static const struct sil_drivelist {
 	{ "ST380011ASL",	SIL_QUIRK_MOD15WRITE },
 	{ "ST3120022ASL",	SIL_QUIRK_MOD15WRITE },
 	{ "ST3160021ASL",	SIL_QUIRK_MOD15WRITE },
+	{ "TOSHIBA MK2561GSYN",	SIL_QUIRK_MOD15WRITE },
 	{ "Maxtor 4D060H3",	SIL_QUIRK_UDMA5MAX },
 	{ }
 };
-- 
1.8.3.2

