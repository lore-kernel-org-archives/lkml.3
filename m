Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbaJ3PFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:05:09 -0400
Received: from 3.mo68.mail-out.ovh.net ([46.105.58.60]:45342 "EHLO
	mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757013AbaJ3PFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:05:06 -0400
X-Greylist: delayed 105205 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2014 11:05:06 EDT
From: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Subject: [PATCH] serial: 8250_dw: get index of serial line from DT aliases
Date: Thu, 30 Oct 2014 15:58:49 +0100
Message-Id: <1414681129-10578-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 2.1.0
X-Ovh-Tracer-Id: 6023564503345135734
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-01-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrfeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrfeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get index of serial line from device tree using function of_alias_get_id().
If no alias is found, the 8250 core takes care of incrementing the line number.

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
 drivers/tty/serial/8250/8250_dw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index beea6ca..5416355 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -293,6 +293,11 @@ static int dw8250_probe_of(struct uart_port *p,
 	if (!of_property_read_u32(np, "reg-shift", &val))
 		p->regshift = val;
 
+	/* get index of serial line, if found in DT aliases */
+	val = of_alias_get_id(np, "serial");
+	if (val >= 0)
+		p->line = val;
+
 	/* clock got configured through clk api, all done */
 	if (p->uartclk)
 		return 0;
-- 
2.1.0

