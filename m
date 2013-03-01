Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3CAUBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:01:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab3CATqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 21/46] sysctl: fix null checking in bin_dn_node_address()
Date: Fri,  1 Mar 2013 11:45:09 -0800
Message-Id: <20130301194434.479738435@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit df1778be1a33edffa51d094eeda87c858ded6560 upstream.

The null check of `strchr() + 1' is broken, which is always non-null,
leading to OOB read.  Instead, check the result of strchr().

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


