Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3GQC7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 22:59:09 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40798 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3GQC7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 22:59:04 -0400
Message-ID: <B8F447E4405F4B7B9B9723556DB3B008@chingDT>
Reply-To: =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
From: =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
To: "linux-scsi" <linux-scsi@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] arcmsr: Fix command throttling for ARC188x series adapters
Date: Wed, 17 Jul 2013 10:59:32 +0800
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_002B_01CE82DC.B79B5730"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Antivirus: avast! (VPS 130716-1, 2013/07/17), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_002B_01CE82DC.B79B5730
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit

From: Chingching2048@areca.com.tw

Fix command throttling for ARC188x series adapters.
Signed-off-by: Chingching2048@areca.com.tw
---

------=_NextPart_000_002B_01CE82DC.B79B5730
Content-Type: application/octet-stream;
	name="patch2"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch2"

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2013-05-07 19:12:12.000000000 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2013-05-16 04:20:04.000000000 =
+0800=0A=
@@ -2461,12 +2461,12 @@ arcmsr_hbaC_postqueue_isr(struct Adapter=0A=
 			? true : false;=0A=
 		/* check if command done with no error */=0A=
 		arcmsr_drain_donequeue(acb, ccb, error);=0A=
+		throttling++;=0A=
 		if (throttling =3D=3D ARCMSR_HBC_ISR_THROTTLING_LEVEL) {=0A=
 			writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,=0A=
 				&phbcmu->inbound_doorbell);=0A=
-			continue;=0A=
+			throttling =3D 0;=0A=
 		}=0A=
-		throttling++;=0A=
 	} while (readl(&phbcmu->host_int_status) &=0A=
 	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR);=0A=
 }=0A=

------=_NextPart_000_002B_01CE82DC.B79B5730--

