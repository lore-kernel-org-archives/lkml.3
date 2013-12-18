Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3LRVWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:22:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab3LRVOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 3.12 100/118] staging: comedi: drivers: use comedi_dio_update_state() for simple cases
Date: Wed, 18 Dec 2013 13:12:17 -0800
Message-Id: <20131218211222.279721691@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: H Hartley Sweeten <hsweeten@visionengravers.com>

commit 97f4289ad08cffe55de06d4ac4f89ac540450aee upstream.

[Split from original patch subject: "staging: comedi: drivers: use
comedi_dio_update_state() for simple cases"]

Use comedi_dio_update_state() to handle the boilerplate code to update
the subdevice s->state for simple cases where the hardware is updated
when any channel is modified.

Also, fix a bug in the amplc_pc263 and amplc_pci263 drivers where the
current state is not returned in data[1].

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/amplc_pc263.c  |    3 +++
 drivers/staging/comedi/drivers/amplc_pci263.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -68,6 +68,9 @@ static int pc263_do_insn_bits(struct com
 		outb(s->state & 0xFF, dev->iobase);
 		outb(s->state >> 8, dev->iobase + 1);
 	}
+
+	data[1] = s->state;
+
 	return insn->n;
 }
 
--- a/drivers/staging/comedi/drivers/amplc_pci263.c
+++ b/drivers/staging/comedi/drivers/amplc_pci263.c
@@ -55,6 +55,9 @@ static int pci263_do_insn_bits(struct co
 		outb(s->state & 0xFF, dev->iobase);
 		outb(s->state >> 8, dev->iobase + 1);
 	}
+
+	data[1] = s->state;
+
 	return insn->n;
 }
 


