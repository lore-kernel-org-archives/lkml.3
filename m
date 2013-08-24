Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab3HXJZL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 05:25:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab3HXJZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 05:25:09 -0400
Date: Sat, 24 Aug 2013 11:25:00 +0200
From: Borislav Petkov <bp@suse.de>
To: x86-ml <x86@kernel.org>
Cc: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] amd64_edac: Correct erratum 505 range
Message-ID: <20130824092500.GA28945@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basically we want to cover all 0x0-0xf models, i.e. Orochi and later.

Cc: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Link: http://lkml.kernel.org/r/20130819192321.GF4165@pd.tnic
Signed-off-by: Borislav Petkov <bp@suse.de>
---

Hey guys,

I've got one more patch which needs to go to tip/x86/ras for 3.12. It
was not worth it IMO to send a pull request for a single patch so please
apply.

Thanks.

 drivers/edac/amd64_edac.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index b86228cce672..6952d432e62b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -206,8 +206,8 @@ static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 bw)
 	if (pvt->fam == 0xf)
 		min_scrubrate = 0x0;
 
-	/* Erratum #505 for F15h Model 0x00 - Model 0x01, Stepping 0 */
-	if (pvt->fam == 0x15 && pvt->model <= 0x01 && pvt->stepping < 0x1)
+	/* Erratum #505 */
+	if (pvt->fam == 0x15 && pvt->model < 0x10)
 		f15h_select_dct(pvt, 0);
 
 	return __amd64_set_scrub_rate(pvt->F3, bw, min_scrubrate);
@@ -219,8 +219,8 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
 	u32 scrubval = 0;
 	int i, retval = -EINVAL;
 
-	/* Erratum #505 for F15h Model 0x00 - Model 0x01, Stepping 0 */
-	if (pvt->fam == 0x15 && pvt->model <= 0x01 && pvt->stepping < 0x1)
+	/* Erratum #505 */
+	if (pvt->fam == 0x15 && pvt->model < 0x10)
 		f15h_select_dct(pvt, 0);
 
 	amd64_read_pci_cfg(pvt->F3, SCRCTRL, &scrubval);
-- 
1.8.4.rc3


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
