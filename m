Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3KUMJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:09:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48571 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3KUMJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:09:47 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-4e-528df80a546f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] intel_idle: shrink avn_cstates table and mark it with
 __initdata tag
Date: Thu, 21 Nov 2013 13:09:38 +0100
Message-id: <7374737.rFhOp5HKV7@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jQV2uH71BBlsncFucbXrDbjFryl4m
	i8u75rBZfO49wmhx5vQlVgdWj8V7XjJ5bLnazuLRt2UVo8fnTXIBLFFcNimpOZllqUX6dglc
	GY3vD7IVvGav+D/jHHMD4zG2LkZODgkBE4nni1+zQthiEhfurQeKc3EICUxnlLh/sAvKaWGS
	ODt5BVgHm4CVxMT2VYwgtoiAtsTcnlPMIEXMAh2MEnee/GIHSQgLhEvcaFoFZrMIqEr8vDEb
	rIFXQFPi4eV2MFtUwFNix/aVbBBxQYkfk++xgNjMAvIS+/ZPZYWwtSTW7zzONIGRbxaSsllI
	ymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzg0n0nvYFzVYHGIUYCDUYmH98HT
	niAh1sSy4srcQ4wSHMxKIryRH3uDhHhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJ
	zU5NLUgtgskycXBKNTAume920OCd3/+Fu575/npxkGO3x5KbB+/GiStNf/O/kSFYzlrj7uLH
	z85onnFK91tn8Tzwt9LPfXv45ilvMDebPX8998cXQr/WvtvUWvf6xjlTn4z17358ESvNN1zw
	5VtZyxVNv6c8x5OzZqyc2STJv8D82p5Py95/twq5Nv3g1Y8e2R8XHLl1P0qJpTgj0VCLuag4
	EQAZ+O4jSQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fixup for commit fab04b2 ("intel_idle: Support Intel Atom
Processor C2000 Product Family") which didn't take into account
changes done in commits eba682a ("intel_idle: shrink states tables")
and 00f3e75 ("intel_idle: mark states tables with __initdata tag").

Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/idle/intel_idle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index cbd4e9a..f4bdf72 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -329,7 +329,8 @@ static struct cpuidle_state atom_cstates[] __initdata = {
 	{
 		.enter = NULL }
 };
-static struct cpuidle_state avn_cstates[CPUIDLE_STATE_MAX] = {
+
+static struct cpuidle_state avn_cstates[] __initdata = {
 	{
 		.name = "C1-AVN",
 		.desc = "MWAIT 0x00",
-- 
1.8.2.3


