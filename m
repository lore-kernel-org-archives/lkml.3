Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbaCDUFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:05:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259AbaCDUF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, matson <lists-matsonpa@luxsci.me>
Subject: [PATCH 3.10 59/97] sata_sil: apply MOD15WRITE quirk to TOSHIBA MK2561GSYN
Date: Tue,  4 Mar 2014 12:04:12 -0800
Message-Id: <20140304200347.958176069@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/sata_sil.c |    1 +
 1 file changed, 1 insertion(+)

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


