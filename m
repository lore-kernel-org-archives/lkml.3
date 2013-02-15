Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935587Ab3BOHcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:32:18 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:35409 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935388Ab3BOHcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:32:16 -0500
Date: Fri, 15 Feb 2013 08:32:10 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: mc74hc00@gmail.com, linux-watchdog@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@lists.ubuntu.com>
Subject: Re: [v3.8 Regression] watchdog: sp5100_tco: Add SB8x0 chipset support
Message-ID: <20130215073210.GM7867@spo001.leaseweb.com>
References: <511D0BCC.9070208@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PuGuTyElPB9bOcsM"
Content-Disposition: inline
In-Reply-To: <511D0BCC.9070208@canonical.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Joseph,

> A bug was opened against the Ubuntu kernel[0].  It was found that 
> reverting the following commit resolved this bug:
> 
> commit 740fbddf5c3f9ad8b23c5d917ba1cc7e376a5104
> Author: Takahisa Tanaka <mc74hc00@gmail.com>
> Date:   Sun Dec 2 14:33:18 2012 +0900
> 
>     watchdog: sp5100_tco: Add SB8x0 chipset support
> 
> 
> The regression was introduced as of v3.8-rc1.
> 
> I see that you are the author of this patch, so I wanted to run this by 
> you.  I was thinking of requesting a revert for v3.8, but I wanted to 
> get your feedback first.

Please check out the attached patches first (They are allready in linux-next).

Other references:
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176

Kind regards,
Wim.


--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sp5100_tco-fix-indirect_IO.mbox"

>From mc74hc00@gmail.com Mon Jan 14 03:02:20 2013
Return-path: <mc74hc00@gmail.com>
Envelope-to: wim@infomag.iguana.be
Delivery-date: Mon, 14 Jan 2013 03:02:20 +0100
Received: from ylaen.iguana.be ([178.21.116.169])
	by spo001.leaseweb.com with esmtp (Exim 4.50)
	id 1TuZNU-0006Zi-0P
	for wim@infomag.iguana.be; Mon, 14 Jan 2013 03:02:20 +0100
Received: from mail-pb0-f45.google.com (mail-pb0-f45.google.com [209.85.160.45])
	by ylaen.iguana.be (Postfix) with ESMTP id 939FC174278
	for <wim@iguana.be>; Mon, 14 Jan 2013 03:02:19 +0100 (CET)
Received: by mail-pb0-f45.google.com with SMTP id mc8so1875722pbc.32
        for <wim@iguana.be>; Sun, 13 Jan 2013 18:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer;
        bh=Al12X3CF48UZXAYSA0AbzpLWDndmh59rkg9CMqG3eKs=;
        b=BN3M1HJsUrmYnOe3KiT2w9jZTOWHevYNdIbLumjQWul8MbPVI1WDie98dgoG21C18P
         BuaHoo82fmCZBViD0qyuQz0RI0vySln5olsfpBsCKJVWTFDSAAg/kysHmcqOVp6sWpDI
         VPSe22vIVgxiNtqK0BdwGLjyvhQJ7Cgnv/3CrIa4h1HUfP8hKMwy/9V6SCe4VRpt7bOZ
         ZqTxpMfQ95pesNTKJuZEx2vqL5LM2WMVqUhneVR1dG4ceFTbOZ3xF57waoUEszGFlrmq
         0owzHTSi1BVF1wlxEfYXPuSie/gS2Yl9AGqHoaXm3DN3aSXwXbqnIK5VdUi/3Cir7CUK
         zj3Q==
X-Received: by 10.66.83.165 with SMTP id r5mr229452746pay.3.1358128938114;
        Sun, 13 Jan 2013 18:02:18 -0800 (PST)
Received: from localhost (p7204-ipngn2902marunouchi.tokyo.ocn.ne.jp. [180.47.244.204])
        by mx.google.com with ESMTPS id qh4sm7226051pbb.9.2013.01.13.18.02.14
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Sun, 13 Jan 2013 18:02:16 -0800 (PST)
From: Takahisa Tanaka <mc74hc00@gmail.com>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
	Paul Menzel <paulepanter@users.sourceforge.net>,
	Arkadiusz Miskiewicz <arekm@maven.pl>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Nieder <jrnieder@gmail.com>,
	linux-kernel@vger.kernel.org,
	Florian Mickler <florian@mickler.org>,
	Takahisa Tanaka <mc74hc00@gmail.com>
Subject: [PATCH 1/2] watchdog: sp5100_tco: Fix wrong indirect I/O access for getting value of reserved bits
Date: Mon, 14 Jan 2013 11:01:57 +0900
Message-Id: <1358128918-4415-1-git-send-email-mc74hc00@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Content-Length: 1656
Lines: 42

In case of SB800 or later chipset and re-programming MMIO address(*),
sp5100_tco module may read incorrect value of reserved bit, because the module
reads a value from an incorrect I/O address. However, this bug doesn't cause
a problem, because when re-programming MMIO address, by chance the module
writes zero (this is BIOS's default value) to the low three bits of register.
* In most cases, PC with SB8x0 or later chipset doesn't need to re-programming
  MMIO address, because such PC can enable AcpiMmio and can use 0xfed80b00 for
  watchdog register base address.

This patch fixes this bug.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/sp5100_tco.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index 2b0e000..5dfe86e 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -500,14 +500,15 @@ static unsigned char sp5100_tco_setupdevice(void)
 	/* Restore to the low three bits, if chipset is SB8x0(or later) */
 	if (sp5100_tco_pci->revision >= 0x40) {
 		u8 reserved_bit;
-		reserved_bit = inb(base_addr) & 0x7;
+		outb(base_addr+0, index_reg);
+		reserved_bit = inb(data_reg) & 0x7;
 		val |= (u32)reserved_bit;
 	}
 
 	/* Re-programming the watchdog timer base address */
 	outb(base_addr+0, index_reg);
 	/* Low three bits of BASE are reserved */
-	outb((val >>  0) & 0xf8, data_reg);
+	outb((val >>  0) & 0xff, data_reg);
 	outb(base_addr+1, index_reg);
 	outb((val >>  8) & 0xff, data_reg);
 	outb(base_addr+2, index_reg);
-- 
1.7.11.7



--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sp5100_tco-fix-write.mbox"

>From mc74hc00@gmail.com Mon Jan 14 03:02:31 2013
Return-path: <mc74hc00@gmail.com>
Envelope-to: wim@infomag.iguana.be
Delivery-date: Mon, 14 Jan 2013 03:02:31 +0100
Received: from ylaen.iguana.be ([178.21.116.169])
	by spo001.leaseweb.com with esmtp (Exim 4.50)
	id 1TuZNf-0006Zu-2q
	for wim@infomag.iguana.be; Mon, 14 Jan 2013 03:02:31 +0100
Received: from mail-da0-f51.google.com (mail-da0-f51.google.com [209.85.210.51])
	by ylaen.iguana.be (Postfix) with ESMTP id AEAA3174278
	for <wim@iguana.be>; Mon, 14 Jan 2013 03:02:30 +0100 (CET)
Received: by mail-da0-f51.google.com with SMTP id i30so1585773dad.10
        for <wim@iguana.be>; Sun, 13 Jan 2013 18:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=xr96DHGo9AJimFBvpkiDW9J9bvC1hncA+l9AGfPz2kI=;
        b=jZJA2gZXsnoyhJbUNH0wc16xsOEDDa0p3aqqoOF+QkZ69Tj4qKpV+MObEisJwEqJlH
         FQS2N0o7PIVwMoD4bxB3es1Du10awk91rAqTdq1FPxVzsOfmfxoLbXH78pbK9ZNt2BTn
         f7Cq0kjpK5IAC+rnTz5HLC8X/gC4AbzLNmmhk/7+BNUfbXTPgbwvYMkJ14DOaZBzbzQC
         ZnaU17gsZMecQBjraKjmisAVG6DwXq4amD3n5xZLDc/yqJ//DsUhmd7kCbpXBbyazBLn
         yX4i+278KwYIkYR3DiOIv48SBN24qrXo+WeGhMsR3JIrDKpHhjs1Nqd38+YSF5bcDdsY
         p8cQ==
X-Received: by 10.66.52.102 with SMTP id s6mr228245938pao.6.1358128949874;
        Sun, 13 Jan 2013 18:02:29 -0800 (PST)
Received: from localhost (p7204-ipngn2902marunouchi.tokyo.ocn.ne.jp. [180.47.244.204])
        by mx.google.com with ESMTPS id ug6sm7227632pbc.4.2013.01.13.18.02.26
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Sun, 13 Jan 2013 18:02:28 -0800 (PST)
From: Takahisa Tanaka <mc74hc00@gmail.com>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
	Paul Menzel <paulepanter@users.sourceforge.net>,
	Arkadiusz Miskiewicz <arekm@maven.pl>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Nieder <jrnieder@gmail.com>,
	linux-kernel@vger.kernel.org,
	Florian Mickler <florian@mickler.org>,
	Takahisa Tanaka <mc74hc00@gmail.com>
Subject: [PATCH 2/2] watchdog: sp5100_tco: Write back the original value to reserved bits, instead of zero
Date: Mon, 14 Jan 2013 11:01:58 +0900
Message-Id: <1358128918-4415-2-git-send-email-mc74hc00@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1358128918-4415-1-git-send-email-mc74hc00@gmail.com>
References: <1358128918-4415-1-git-send-email-mc74hc00@gmail.com>
Content-Length: 2279
Lines: 69

In case of SP5100 or SB7x0 chipsets, the sp5100_tco module writes zero to
reserved bits. The module, however, shouldn't depend on specific default
value, and should perform a read-merge-write operation for the reserved
bits.

This patch makes the sp5100_tco module perform a read-merge-write operation
on all the chipset (sp5100, sb7x0, sb8x0 or later).

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/sp5100_tco.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index 5dfe86e..e3b8f75 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -361,7 +361,7 @@ static unsigned char sp5100_tco_setupdevice(void)
 {
 	struct pci_dev *dev = NULL;
 	const char *dev_name = NULL;
-	u32 val;
+	u32 val, tmp_val;
 	u32 index_reg, data_reg, base_addr;
 
 	/* Match the PCI device */
@@ -497,31 +497,19 @@ static unsigned char sp5100_tco_setupdevice(void)
 		pr_debug("Got 0x%04x from resource tree\n", val);
 	}
 
-	/* Restore to the low three bits, if chipset is SB8x0(or later) */
-	if (sp5100_tco_pci->revision >= 0x40) {
-		u8 reserved_bit;
-		outb(base_addr+0, index_reg);
-		reserved_bit = inb(data_reg) & 0x7;
-		val |= (u32)reserved_bit;
-	}
+	/* Restore to the low three bits */
+	outb(base_addr+0, index_reg);
+	tmp_val = val | (inb(data_reg) & 0x7);
 
 	/* Re-programming the watchdog timer base address */
 	outb(base_addr+0, index_reg);
-	/* Low three bits of BASE are reserved */
-	outb((val >>  0) & 0xff, data_reg);
+	outb((tmp_val >>  0) & 0xff, data_reg);
 	outb(base_addr+1, index_reg);
-	outb((val >>  8) & 0xff, data_reg);
+	outb((tmp_val >>  8) & 0xff, data_reg);
 	outb(base_addr+2, index_reg);
-	outb((val >> 16) & 0xff, data_reg);
+	outb((tmp_val >> 16) & 0xff, data_reg);
 	outb(base_addr+3, index_reg);
-	outb((val >> 24) & 0xff, data_reg);
-
-	/*
-	 * Clear unnecessary the low three bits,
-	 * if chipset is SB8x0(or later)
-	 */
-	if (sp5100_tco_pci->revision >= 0x40)
-		val &= ~0x7;
+	outb((tmp_val >> 24) & 0xff, data_reg);
 
 	if (!request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE,
 								   dev_name)) {
-- 
1.7.11.7



--PuGuTyElPB9bOcsM--
