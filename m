Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3CDDnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:43:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60951 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755580Ab3CDDnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:04 -0500
Message-Id: <20130304033718.884859870@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:02 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Xi Wang <xi.wang@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 115/153] sysctl: fix null checking in bin_dn_node_address()
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit df1778be1a33edffa51d094eeda87c858ded6560 upstream.

The null check of `strchr() + 1' is broken, which is always non-null,
leading to OOB read.  Instead, check the result of strchr().

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sysctl_binary.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1194,9 +1194,10 @@ static ssize_t bin_dn_node_address(struc
 
 		/* Convert the decnet address to binary */
 		result = -EIO;
-		nodep = strchr(buf, '.') + 1;
+		nodep = strchr(buf, '.');
 		if (!nodep)
 			goto out;
+		++nodep;
 
 		area = simple_strtoul(buf, NULL, 10);
 		node = simple_strtoul(nodep, NULL, 10);


