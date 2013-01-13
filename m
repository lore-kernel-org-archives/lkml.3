Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3AMRq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:46:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35144 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755710Ab3AMRpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:50 -0500
Message-Id: <20130113174301.050077064@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:20 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Xi Wang <xi.wang@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 25/49] nfs: fix null checking in nfs_get_option_str()
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit e25fbe380c4e3c09afa98bcdcd9d3921443adab8 upstream.

The following null pointer check is broken.

	*option = match_strdup(args);
	return !option;

The pointer `option' must be non-null, and thus `!option' is always false.
Use `!*option' instead.

The bug was introduced in commit c5cb09b6f8 ("Cleanup: Factor out some
cut-and-paste code.").

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index c25cadf8..2e7e8c8 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1152,7 +1152,7 @@ static int nfs_get_option_str(substring_t args[], char **option)
 {
 	kfree(*option);
 	*option = match_strdup(args);
-	return !option;
+	return !*option;
 }
 
 static int nfs_get_option_ul(substring_t args[], unsigned long *option)


