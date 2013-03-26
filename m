Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab3CZWsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:48:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab3CZWod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        CQ Tang <cq.tang@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 81/98] x86-64: Fix the failure case in copy_user_handle_tail()
Date: Tue, 26 Mar 2013 15:43:10 -0700
Message-Id: <20130326224250.885203973@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: CQ Tang <cq.tang@intel.com>

commit 66db3feb486c01349f767b98ebb10b0c3d2d021b upstream.

The increment of "to" in copy_user_handle_tail() will have incremented
before a failure has been noted.  This causes us to skip a byte in the
failure case.

Only do the increment when assured there is no failure.

Signed-off-by: CQ Tang <cq.tang@intel.com>
Link: http://lkml.kernel.org/r/20130318150221.8439.993.stgit@phlsvslse11.ph.intel.com
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/lib/usercopy_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -74,10 +74,10 @@ copy_user_handle_tail(char *to, char *fr
 	char c;
 	unsigned zero_len;
 
-	for (; len; --len) {
+	for (; len; --len, to++) {
 		if (__get_user_nocheck(c, from++, sizeof(char)))
 			break;
-		if (__put_user_nocheck(c, to++, sizeof(char)))
+		if (__put_user_nocheck(c, to, sizeof(char)))
 			break;
 	}
 


