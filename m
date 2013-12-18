Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3LRVLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:11:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3LRVJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:09:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 3.4 28/31] staging: comedi: ssv_dnp: use comedi_dio_update_state()
Date: Wed, 18 Dec 2013 13:08:36 -0800
Message-Id: <20131218210523.579088418@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218210522.790152625@linuxfoundation.org>
References: <20131218210522.790152625@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: H Hartley Sweeten <hsweeten@visionengravers.com>

commit f6b316bcd8c421acd6fa5a6e18b4c846ecb9d965 upstream.

Use comedi_dio_update_state() to handle the boilerplate code to update
the subdevice s->state.

Also, fix a bug where the state of the channels is returned in data[0].
The comedi core expects it to be returned in data[1].

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/ssv_dnp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -251,11 +251,11 @@ static int dnp_dio_insn_bits(struct come
 
 	/* on return, data[1] contains the value of the digital input lines. */
 	outb(PADR, CSCIR);
-	data[0] = inb(CSCDR);
+	data[1] = inb(CSCDR);
 	outb(PBDR, CSCIR);
-	data[0] += inb(CSCDR) << 8;
+	data[1] += inb(CSCDR) << 8;
 	outb(PCDR, CSCIR);
-	data[0] += ((inb(CSCDR) & 0xF0) << 12);
+	data[1] += ((inb(CSCDR) & 0xF0) << 12);
 
 	return 2;
 


