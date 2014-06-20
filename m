Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934554AbaFTPlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:41:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228AbaFTPlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:41:42 -0400
Date: Fri, 20 Jun 2014 11:41:37 -0400
From: Kyle McMartin <kyle@redhat.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH trivial] checkstack.pl: port to AArch64
Message-ID: <20140620154137.GW5166@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AArch64 stores the frame pointer and return pointer, and decrements the
stack. Also remove my (no longer valid) email address.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/scripts/checkstack.pl
+++ b/scripts/checkstack.pl
@@ -13,7 +13,7 @@
 #	Random bits by Matt Mackall <mpm@selenic.com>
 #	M68k port by Geert Uytterhoeven and Andreas Schwab
 #	AVR32 port by Haavard Skinnemoen (Atmel)
-#	PARISC port by Kyle McMartin <kyle@parisc-linux.org>
+#	AArch64, PARISC ports by Kyle McMartin
 #	sparc port by Martin Habets <errandir_news@mph.eclipse.co.uk>
 #
 #	Usage:
@@ -45,7 +45,10 @@ my (@stack, $re, $dre, $x, $xs, $funcre);
 	$x	= "[0-9a-f]";	# hex character
 	$xs	= "[0-9a-f ]";	# hex character or space
 	$funcre = qr/^$x* <(.*)>:$/;
-	if ($arch eq 'arm') {
+	if ($arch eq 'aarch64') {
+		#ffffffc0006325cc:       a9bb7bfd        stp     x29, x30, [sp,#-80]!
+		$re = qr/^.*stp.*sp,\#-([0-9]{1,8})\]\!/o;
+	} elsif ($arch eq 'arm') {
 		#c0008ffc:	e24dd064	sub	sp, sp, #100	; 0x64
 		$re = qr/.*sub.*sp, sp, #(([0-9]{2}|[3-9])[0-9]{2})/o;
 	} elsif ($arch eq 'avr32') {
