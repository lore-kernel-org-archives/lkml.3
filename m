Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3I3NLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:11:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13029 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3I3NLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:11:53 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-5a-524978986579
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] powerpc/legacy_serial: fix incorrect placement of __initdata
 tag
Date: Mon, 30 Sep 2013 15:11:42 +0200
Message-id: <35419229.o6Cv8JYbpg@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t9jQd0ZFZ5BBiuXyFh8aGpltjjb9Ibd
	4vKuOWwWv7//Y7VYc2QxuwOrR8+bFlaP8zMWMnrM3dXH6NG3ZRWjx+dNcgGsUVw2Kak5mWWp
	Rfp2CVwZ21eUFyxmr9j98AJLA+NMti5GTg4JAROJZYtmsULYYhIX7q0HinNxCAlMZ5T4++IL
	C4TTwiSx9MgPdpAqNgEriYntqxhBbBEBU4mWhk52kCJmgX5GiW3Tj4CNEhYIlnj6YCZYA4uA
	qsTrD2uZQGxeAS2J1z2TwGpEBTwlPk1aygwRF5T4MfkeC4jNLCAvsW//VFYIW0ti/c7jTBMY
	+WYhKZuFpGwWkrIFjMyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYJD9JnUDsaVDRaHGAU4
	GJV4eCcs9wgSYk0sK67MPcQowcGsJMIrXuYZJMSbklhZlVqUH19UmpNafIhRmoNFSZz3QKt1
	oJBAemJJanZqakFqEUyWiYNTqoFR5UGyV+lRvb0qn5ex3pz1j0vcQ8bsYIjT6olX58ZmLbNh
	2SYnIMnrbBy/gOFq7Jcl/Kl/Q56ofGqJYbPPOiKfWLJCMmSWllDbYtYWTi7fgifTF3zo987Z
	Zzvxa92yqCDu/de+Cas2aqiVPgtyb8woZnu0PHr1bM/9JvFmYYfjOsNrtxstvaPEUpyRaKjF
	XFScCACfL/JUTQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/powerpc/kernel/legacy_serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index 22e88dd..40bd7bd 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -35,7 +35,7 @@ static struct legacy_serial_info {
 	phys_addr_t			taddr;
 } legacy_serial_infos[MAX_LEGACY_SERIAL_PORTS];
 
-static struct __initdata of_device_id legacy_serial_parents[] = {
+static struct of_device_id legacy_serial_parents[] __initdata = {
 	{.type = "soc",},
 	{.type = "tsi-bridge",},
 	{.type = "opb", },
-- 
1.8.2.3


