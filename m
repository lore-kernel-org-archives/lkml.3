Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbaGODDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:03:45 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64396 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbaGODDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:03:40 -0400
Date: Tue, 15 Jul 2014 12:02:23 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] staging: dgap: remove unneeded dgap_err()
Message-ID: <20140715030223.GA14406@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dgap_err() is printing a message with pr_err(),
so all those are replaced.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |  226 ++++++++++++++++++++----------------------
 1 files changed, 108 insertions(+), 118 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 06c55cb..61baee1 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -153,7 +153,6 @@ static void dgap_firmware_reset_port(struct channel_t *ch);
 static int dgap_gettok(char **in);
 static char *dgap_getword(char **in);
 static int dgap_checknode(struct cnode *p);
-static void dgap_err(char *s);
 
 /*
  * Function prototypes from dgap_sysfs.h
@@ -6343,7 +6342,7 @@ static int dgap_parsefile(char **in)
 	/* file must start with a BEGIN */
 	while ((rc = dgap_gettok(in)) != BEGIN) {
 		if (rc == 0) {
-			dgap_err("unexpected EOF");
+			pr_err("dgap: parse: unexpected EOF\n");
 			return -1;
 		}
 	}
@@ -6351,13 +6350,13 @@ static int dgap_parsefile(char **in)
 	for (; ;) {
 		rc = dgap_gettok(in);
 		if (rc == 0) {
-			dgap_err("unexpected EOF");
+			pr_err("dgap: parse: unexpected EOF\n");
 			return -1;
 		}
 
 		switch (rc) {
 		case BEGIN:	/* should only be 1 begin */
-			dgap_err("unexpected config_begin\n");
+			pr_err("dgap: parse: unexpected config_begin\n");
 			return -1;
 
 		case END:
@@ -6369,7 +6368,7 @@ static int dgap_parsefile(char **in)
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 			p = p->next;
@@ -6383,7 +6382,7 @@ static int dgap_parsefile(char **in)
 
 		case APORT2_920P:	/* AccelePort_4 */
 			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_2r_920 string");
+				pr_err("dgap: parse: unexpected Digi_2r_920 string\n");
 				return -1;
 			}
 			p->u.board.type = APORT2_920P;
@@ -6392,7 +6391,7 @@ static int dgap_parsefile(char **in)
 
 		case APORT4_920P:	/* AccelePort_4 */
 			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_4r_920 string");
+				pr_err("dgap: parse: unexpected Digi_4r_920 string\n");
 				return -1;
 			}
 			p->u.board.type = APORT4_920P;
@@ -6401,7 +6400,7 @@ static int dgap_parsefile(char **in)
 
 		case APORT8_920P:	/* AccelePort_8 */
 			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_8r_920 string");
+				pr_err("dgap: parse: unexpected Digi_8r_920 string\n");
 				return -1;
 			}
 			p->u.board.type = APORT8_920P;
@@ -6410,7 +6409,7 @@ static int dgap_parsefile(char **in)
 
 		case PAPORT4:	/* AccelePort_4 PCI */
 			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_4r(PCI) string");
+				pr_err("dgap: parse: unexpected Digi_4r(PCI) string\n");
 				return -1;
 			}
 			p->u.board.type = PAPORT4;
@@ -6419,7 +6418,7 @@ static int dgap_parsefile(char **in)
 
 		case PAPORT8:	/* AccelePort_8 PCI */
 			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_8r string");
+				pr_err("dgap: parse: unexpected Digi_8r string\n");
 				return -1;
 			}
 			p->u.board.type = PAPORT8;
@@ -6428,7 +6427,7 @@ static int dgap_parsefile(char **in)
 
 		case PCX:	/* PCI C/X */
 			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_C/X_(PCI) string");
+				pr_err("dgap: parse: unexpected Digi_C/X_(PCI) string\n");
 				return -1;
 			}
 			p->u.board.type = PCX;
@@ -6441,7 +6440,7 @@ static int dgap_parsefile(char **in)
 
 		case PEPC:	/* PCI EPC/X */
 			if (p->type != BNODE) {
-				dgap_err("unexpected \"Digi_EPC/X_(PCI)\" string");
+				pr_err("dgap: parse: unexpected \"Digi_EPC/X_(PCI)\" string\n");
 				return -1;
 			}
 			p->u.board.type = PEPC;
@@ -6454,7 +6453,7 @@ static int dgap_parsefile(char **in)
 
 		case PPCM:	/* PCI/Xem */
 			if (p->type != BNODE) {
-				dgap_err("unexpected PCI/Xem string");
+				pr_err("dgap: parse: unexpected PCI/Xem string\n");
 				return -1;
 			}
 			p->u.board.type = PPCM;
@@ -6465,17 +6464,17 @@ static int dgap_parsefile(char **in)
 
 		case IO:	/* i/o port */
 			if (p->type != BNODE) {
-				dgap_err("IO port only vaild for boards");
+				pr_err("dgap: parse: IO port only vaild for boards\n");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			p->u.board.portstr = kstrdup(s, GFP_KERNEL);
 			if (kstrtol(s, 0, &p->u.board.port)) {
-				dgap_err("bad number for IO port");
+				pr_err("dgap: parse: bad number for IO port\n");
 				return -1;
 			}
 			p->u.board.v_port = 1;
@@ -6483,17 +6482,17 @@ static int dgap_parsefile(char **in)
 
 		case MEM:	/* memory address */
 			if (p->type != BNODE) {
-				dgap_err("memory address only vaild for boards");
+				pr_err("dgap: parse: memory address only vaild for boards\n");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			p->u.board.addrstr = kstrdup(s, GFP_KERNEL);
 			if (kstrtoul(s, 0, &p->u.board.addr)) {
-				dgap_err("bad number for memory address");
+				pr_err("dgap: parse: bad number for memory address\n");
 				return -1;
 			}
 			p->u.board.v_addr = 1;
@@ -6501,28 +6500,28 @@ static int dgap_parsefile(char **in)
 
 		case PCIINFO:	/* pci information */
 			if (p->type != BNODE) {
-				dgap_err("memory address only vaild for boards");
+				pr_err("dgap: parse: memory address only vaild for boards\n");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			p->u.board.pcibusstr = kstrdup(s, GFP_KERNEL);
 			if (kstrtoul(s, 0, &p->u.board.pcibus)) {
-				dgap_err("bad number for pci bus");
+				pr_err("dgap: parse: bad number for pci bus\n");
 				return -1;
 			}
 			p->u.board.v_pcibus = 1;
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			p->u.board.pcislotstr = kstrdup(s, GFP_KERNEL);
 			if (kstrtoul(s, 0, &p->u.board.pcislot)) {
-				dgap_err("bad number for pci slot");
+				pr_err("dgap: parse: bad number for pci slot\n");
 				return -1;
 			}
 			p->u.board.v_pcislot = 1;
@@ -6530,12 +6529,12 @@ static int dgap_parsefile(char **in)
 
 		case METHOD:
 			if (p->type != BNODE) {
-				dgap_err("install method only vaild for boards");
+				pr_err("dgap: parse: install method only vaild for boards\n");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			p->u.board.method = kstrdup(s, GFP_KERNEL);
@@ -6544,12 +6543,12 @@ static int dgap_parsefile(char **in)
 
 		case STATUS:
 			if (p->type != BNODE) {
-				dgap_err("config status only vaild for boards");
+				pr_err("dgap: parse: config status only vaild for boards\n");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			p->u.board.status = kstrdup(s, GFP_KERNEL);
@@ -6559,38 +6558,38 @@ static int dgap_parsefile(char **in)
 			if (p->type == BNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("dgap: parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.board.nport)) {
-					dgap_err("bad number for number of ports");
+					pr_err("dgap: parse: bad number for number of ports\n");
 					return -1;
 				}
 				p->u.board.v_nport = 1;
 			} else if (p->type == CNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("dgap: parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.conc.nport)) {
-					dgap_err("bad number for number of ports");
+					pr_err("dgap: parse: bad number for number of ports\n");
 					return -1;
 				}
 				p->u.conc.v_nport = 1;
 			} else if (p->type == MNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("dgap: parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.module.nport)) {
-					dgap_err("bad number for number of ports");
+					pr_err("dgap: parse: bad number for number of ports\n");
 					return -1;
 				}
 				p->u.module.v_nport = 1;
 			} else {
-				dgap_err("nports only valid for concentrators or modules");
+				pr_err("dgap: parse: nports only valid for concentrators or modules\n");
 				return -1;
 			}
 			break;
@@ -6598,7 +6597,7 @@ static int dgap_parsefile(char **in)
 		case ID:	/* letter ID used in tty name */
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 
@@ -6611,7 +6610,7 @@ static int dgap_parsefile(char **in)
 				p->u.module.id = kstrdup(s, GFP_KERNEL);
 				p->u.module.v_id = 1;
 			} else {
-				dgap_err("id only valid for concentrators or modules");
+				pr_err("dgap: parse: id only valid for concentrators or modules\n");
 				return -1;
 			}
 			break;
@@ -6620,38 +6619,38 @@ static int dgap_parsefile(char **in)
 			if (p->type == BNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("dgap: parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.board.start)) {
-					dgap_err("bad number for start of tty count");
+					pr_err("dgap: parse: bad number for start of tty count\n");
 					return -1;
 				}
 				p->u.board.v_start = 1;
 			} else if (p->type == CNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("dgap: parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.conc.start)) {
-					dgap_err("bad number for start of tty count");
+					pr_err("dgap: parse: bad number for start of tty count\n");
 					return -1;
 				}
 				p->u.conc.v_start = 1;
 			} else if (p->type == MNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("dgap: parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.module.start)) {
-					dgap_err("bad number for start of tty count");
+					pr_err("dgap: parse: bad number for start of tty count\n");
 					return -1;
 				}
 				p->u.module.v_start = 1;
 			} else {
-				dgap_err("start only valid for concentrators or modules");
+				pr_err("dgap: parse: start only valid for concentrators or modules\n");
 				return -1;
 			}
 			break;
@@ -6662,7 +6661,7 @@ static int dgap_parsefile(char **in)
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 
@@ -6671,12 +6670,12 @@ static int dgap_parsefile(char **in)
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpeced end of file");
+				pr_err("dgap: parse: unexpeced end of file\n");
 				return -1;
 			}
 			p->u.ttyname = kstrdup(s, GFP_KERNEL);
 			if (!p->u.ttyname) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 			break;
@@ -6687,7 +6686,7 @@ static int dgap_parsefile(char **in)
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 
@@ -6696,12 +6695,12 @@ static int dgap_parsefile(char **in)
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpeced end of file");
+				pr_err("dgap: parse: unexpeced end of file\n");
 				return -1;
 			}
 			p->u.cuname = kstrdup(s, GFP_KERNEL);
 			if (!p->u.cuname) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 			break;
@@ -6710,18 +6709,18 @@ static int dgap_parsefile(char **in)
 			if (dgap_checknode(p))
 				return -1;
 			if (!brd) {
-				dgap_err("must specify board before line info");
+				pr_err("dgap: parse: must specify board before line info\n");
 				return -1;
 			}
 			switch (brd->u.board.type) {
 			case PPCM:
-				dgap_err("line not vaild for PC/em");
+				pr_err("dgap: parse: line not vaild for PC/em\n");
 				return -1;
 			}
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 
@@ -6736,13 +6735,13 @@ static int dgap_parsefile(char **in)
 			if (dgap_checknode(p))
 				return -1;
 			if (!line) {
-				dgap_err("must specify line info before concentrator");
+				pr_err("dgap: parse: must specify line info before concentrator\n");
 				return -1;
 			}
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 
@@ -6759,7 +6758,7 @@ static int dgap_parsefile(char **in)
 
 		case CX:	/* c/x type concentrator */
 			if (p->type != CNODE) {
-				dgap_err("cx only valid for concentrators");
+				pr_err("dgap: parse: cx only valid for concentrators\n");
 				return -1;
 			}
 			p->u.conc.type = CX;
@@ -6768,7 +6767,7 @@ static int dgap_parsefile(char **in)
 
 		case EPC:	/* epc type concentrator */
 			if (p->type != CNODE) {
-				dgap_err("cx only valid for concentrators");
+				pr_err("dgap: parse: cx only valid for concentrators\n");
 				return -1;
 			}
 			p->u.conc.type = EPC;
@@ -6779,7 +6778,7 @@ static int dgap_parsefile(char **in)
 			if (dgap_checknode(p))
 				return -1;
 			if (!brd) {
-				dgap_err("must specify board info before EBI modules");
+				pr_err("dgap: parse: must specify board info before EBI modules\n");
 				return -1;
 			}
 			switch (brd->u.board.type) {
@@ -6788,14 +6787,14 @@ static int dgap_parsefile(char **in)
 				break;
 			default:
 				if (!conc) {
-					dgap_err("must specify concentrator info before EBI module");
+					pr_err("dgap: parse: must specify concentrator info before EBI module\n");
 					return -1;
 				}
 			}
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 			p = p->next;
@@ -6810,7 +6809,7 @@ static int dgap_parsefile(char **in)
 
 		case PORTS:	/* ports type EBI module */
 			if (p->type != MNODE) {
-				dgap_err("ports only valid for EBI modules");
+				pr_err("dgap: parse: ports only valid for EBI modules\n");
 				return -1;
 			}
 			p->u.module.type = PORTS;
@@ -6819,7 +6818,7 @@ static int dgap_parsefile(char **in)
 
 		case MODEM:	/* ports type EBI module */
 			if (p->type != MNODE) {
-				dgap_err("modem only valid for modem modules");
+				pr_err("dgap: parse: modem only valid for modem modules\n");
 				return -1;
 			}
 			p->u.module.type = MODEM;
@@ -6830,7 +6829,7 @@ static int dgap_parsefile(char **in)
 			if (p->type == LNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("dgap: parse: unexpected end of file\n");
 					return -1;
 				}
 				p->u.line.cable = kstrdup(s, GFP_KERNEL);
@@ -6842,27 +6841,27 @@ static int dgap_parsefile(char **in)
 			if (p->type == LNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("dgap: parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.line.speed)) {
-					dgap_err("bad number for line speed");
+					pr_err("dgap: parse: bad number for line speed\n");
 					return -1;
 				}
 				p->u.line.v_speed = 1;
 			} else if (p->type == CNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("dgap: parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.conc.speed)) {
-					dgap_err("bad number for line speed");
+					pr_err("dgap: parse: bad number for line speed\n");
 					return -1;
 				}
 				p->u.conc.v_speed = 1;
 			} else {
-				dgap_err("speed valid only for lines or concentrators.");
+				pr_err("dgap: parse: speed valid only for lines or concentrators.\n");
 				return -1;
 			}
 			break;
@@ -6871,7 +6870,7 @@ static int dgap_parsefile(char **in)
 			if (p->type == CNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("dgap: parse: unexpected end of file\n");
 					return -1;
 				}
 				p->u.conc.connect = kstrdup(s, GFP_KERNEL);
@@ -6884,7 +6883,7 @@ static int dgap_parsefile(char **in)
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 
@@ -6893,12 +6892,12 @@ static int dgap_parsefile(char **in)
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpeced end of file");
+				pr_err("dgap: parse: unexpeced end of file\n");
 				return -1;
 			}
 			p->u.printname = kstrdup(s, GFP_KERNEL);
 			if (!p->u.printname) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 			break;
@@ -6909,7 +6908,7 @@ static int dgap_parsefile(char **in)
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 
@@ -6918,11 +6917,11 @@ static int dgap_parsefile(char **in)
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.majornumber)) {
-				dgap_err("bad number for major number");
+				pr_err("dgap: parse: bad number for major number\n");
 				return -1;
 			}
 			break;
@@ -6933,7 +6932,7 @@ static int dgap_parsefile(char **in)
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 
@@ -6942,11 +6941,11 @@ static int dgap_parsefile(char **in)
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.altpin)) {
-				dgap_err("bad number for altpin");
+				pr_err("dgap: parse: bad number for altpin\n");
 				return -1;
 			}
 			break;
@@ -6957,18 +6956,18 @@ static int dgap_parsefile(char **in)
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 			p = p->next;
 			p->type = INTRNODE;
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.useintr)) {
-				dgap_err("bad number for useintr");
+				pr_err("dgap: parse: bad number for useintr\n");
 				return -1;
 			}
 			break;
@@ -6979,7 +6978,7 @@ static int dgap_parsefile(char **in)
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 
@@ -6988,11 +6987,11 @@ static int dgap_parsefile(char **in)
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.ttysize)) {
-				dgap_err("bad number for ttysize");
+				pr_err("dgap: parse: bad number for ttysize\n");
 				return -1;
 			}
 			break;
@@ -7003,7 +7002,7 @@ static int dgap_parsefile(char **in)
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 
@@ -7012,11 +7011,11 @@ static int dgap_parsefile(char **in)
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.chsize)) {
-				dgap_err("bad number for chsize");
+				pr_err("dgap: parse: bad number for chsize\n");
 				return -1;
 			}
 			break;
@@ -7027,7 +7026,7 @@ static int dgap_parsefile(char **in)
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 
@@ -7036,11 +7035,11 @@ static int dgap_parsefile(char **in)
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.bssize)) {
-				dgap_err("bad number for bssize");
+				pr_err("dgap: parse: bad number for bssize\n");
 				return -1;
 			}
 			break;
@@ -7051,7 +7050,7 @@ static int dgap_parsefile(char **in)
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 
@@ -7060,11 +7059,11 @@ static int dgap_parsefile(char **in)
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.unsize)) {
-				dgap_err("bad number for schedsize");
+				pr_err("dgap: parse: bad number for schedsize\n");
 				return -1;
 			}
 			break;
@@ -7075,7 +7074,7 @@ static int dgap_parsefile(char **in)
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 
@@ -7084,11 +7083,11 @@ static int dgap_parsefile(char **in)
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.f2size)) {
-				dgap_err("bad number for f2200size");
+				pr_err("dgap: parse: bad number for f2200size\n");
 				return -1;
 			}
 			break;
@@ -7099,7 +7098,7 @@ static int dgap_parsefile(char **in)
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
 			if (!p->next) {
-				dgap_err("out of memory");
+				pr_err("dgap: parse: out of memory\n");
 				return -1;
 			}
 
@@ -7108,11 +7107,11 @@ static int dgap_parsefile(char **in)
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("dgap: parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.vpixsize)) {
-				dgap_err("bad number for vpixsize");
+				pr_err("dgap: parse: bad number for vpixsize\n");
 				return -1;
 			}
 			break;
@@ -7169,7 +7168,7 @@ static int dgap_gettok(char **in)
 			if (!strcmp(w, t->string))
 				return t->token;
 		}
-		dgap_err("board !!type not specified");
+		pr_err("dgap: parse: board !!type not specified\n");
 		return 1;
 	} else {
 		while ((w = dgap_getword(in))) {
@@ -7213,15 +7212,6 @@ static char *dgap_getword(char **in)
 }
 
 /*
- * print an error message, giving the line number in the file where
- * the error occurred.
- */
-static void dgap_err(char *s)
-{
-	pr_err("dgap: parse: %s\n", s);
-}
-
-/*
  * dgap_checknode: see if all the necessary info has been supplied for a node
  * before creating the next node.
  */
@@ -7230,7 +7220,7 @@ static int dgap_checknode(struct cnode *p)
 	switch (p->type) {
 	case BNODE:
 		if (p->u.board.v_type == 0) {
-			dgap_err("board type !not specified");
+			pr_err("dgap: parse: board type !not specified\n");
 			return 1;
 		}
 
@@ -7238,41 +7228,41 @@ static int dgap_checknode(struct cnode *p)
 
 	case LNODE:
 		if (p->u.line.v_speed == 0) {
-			dgap_err("line speed not specified");
+			pr_err("dgap: parse: line speed not specified\n");
 			return 1;
 		}
 		return 0;
 
 	case CNODE:
 		if (p->u.conc.v_type == 0) {
-			dgap_err("concentrator type not specified");
+			pr_err("dgap: parse: concentrator type not specified\n");
 			return 1;
 		}
 		if (p->u.conc.v_speed == 0) {
-			dgap_err("concentrator line speed not specified");
+			pr_err("dgap: parse: concentrator line speed not specified\n");
 			return 1;
 		}
 		if (p->u.conc.v_nport == 0) {
-			dgap_err("number of ports on concentrator not specified");
+			pr_err("dgap: parse: number of ports on concentrator not specified\n");
 			return 1;
 		}
 		if (p->u.conc.v_id == 0) {
-			dgap_err("concentrator id letter not specified");
+			pr_err("dgap: parse: concentrator id letter not specified\n");
 			return 1;
 		}
 		return 0;
 
 	case MNODE:
 		if (p->u.module.v_type == 0) {
-			dgap_err("EBI module type not specified");
+			pr_err("dgap: parse: EBI module type not specified\n");
 			return 1;
 		}
 		if (p->u.module.v_nport == 0) {
-			dgap_err("number of ports on EBI module not specified");
+			pr_err("dgap: parse: number of ports on EBI module not specified\n");
 			return 1;
 		}
 		if (p->u.module.v_id == 0) {
-			dgap_err("EBI module id letter not specified");
+			pr_err("dgap: parse: EBI module id letter not specified\n");
 			return 1;
 		}
 		return 0;
-- 
1.7.1

