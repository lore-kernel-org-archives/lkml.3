Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbaCTVx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:53:29 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:36118 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757710AbaCTVx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:53:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMGANdiK1NXQ0+a/2dsb2JhbABZgwaCSYERwAeBGRd0gmYcIxiBAiQTh30B0A+OAWSEPwSYRgGKWYdXgy48gSw
Date: Thu, 20 Mar 2014 22:53:25 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] mm/filemap.c: ra_submit inline
Message-Id: <20140320225325.ab266ce4592446e33efd0caf@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

f9acc8c7b35a10 ("readahead: sanify file_ra_state names")
left ra_submit with a single function call.

Add 'inline' to save some stack (suggested by Andrew Morton).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/readahead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 0de2360..ce8de09 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -246,7 +246,7 @@ unsigned long max_sane_readahead(unsigned long nr)
 /*
  * Submit IO for the read-ahead request in file_ra_state.
  */
-unsigned long ra_submit(struct file_ra_state *ra,
+inline unsigned long ra_submit(struct file_ra_state *ra,
 		       struct address_space *mapping, struct file *filp)
 {
 	int actual;
-- 
1.8.4.5
