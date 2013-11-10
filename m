Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab3KJM1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 07:27:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36878 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab3KJM1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 07:27:01 -0500
Date: Sun, 10 Nov 2013 13:26:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] A minor amd64_edac fix for 3.13
Message-ID: <20131110122638.GA17775@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull this one minor thing which has been lying around since
forever... (at least it feels like it - I almost forgot about it :-)).

Thanks.

--
The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_for_3.13

for you to fetch changes up to c3e511e4c4d9cb962976f63d37816ff8e8efacc5:

  amd64_edac: Remove superfluous condition check. (2013-09-19 09:55:20 +0200)

----------------------------------------------------------------
A minor correctness fix.

----------------------------------------------------------------
Aravind Gopalakrishnan (1):
      amd64_edac: Remove superfluous condition check.

 drivers/edac/amd64_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 3c9e4e98c651..bbd1913ce27c 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1576,7 +1576,7 @@ static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 					     num_dcts_intlv, dct_sel);
 
 	/* Verify we stay within the MAX number of channels allowed */
-	if (channel > 4 || channel < 0)
+	if (channel > 4)
 		return -EINVAL;
 
 	leg_mmio_hole = (u8) (dct_cont_base_reg >> 1 & BIT(0));

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
