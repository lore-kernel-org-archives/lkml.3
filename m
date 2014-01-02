Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbaABRYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:24:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40328 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbaABRHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:07:51 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 54/91] staging: comedi: amplc_pc263: correct insn_bits result
Date: Thu,  2 Jan 2014 09:04:29 -0800
Message-Id: <1388682306-30859-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 97f4289ad08cffe55de06d4ac4f89ac540450aee upstream.

[Split from original patch subject: "staging: comedi: drivers: use
comedi_dio_update_state() for simple cases"]

Also, fix a bug in the amplc_pc263 and amplc_pci263 drivers where the
current state is not returned in data[1].

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/comedi/drivers/amplc_pc263.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index dfbff77..53b2ad9 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -192,6 +192,9 @@ static int pc263_do_insn_bits(struct comedi_device *dev,
 		outb(s->state & 0xFF, dev->iobase);
 		outb(s->state >> 8, dev->iobase + 1);
 	}
+
+	data[1] = s->state;
+
 	return insn->n;
 }
 
-- 
1.8.3.2

