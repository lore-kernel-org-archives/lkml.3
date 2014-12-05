Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbaLEXxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:53:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaLEWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.17 002/122] MIPS: lib: memcpy: Restore NOP on delay slot before returning to caller
Date: Fri,  5 Dec 2014 14:42:56 -0800
Message-Id: <20141205223305.902282340@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit 51b1029d9966060c6ad02030e6f251425b4f06c1 upstream.

Commit cf62a8b8134dd3 ("MIPS: lib: memcpy: Use macro to build the
copy_user code") switched to a macro in order to build the memcpy
symbols in preparation for the EVA support. However, this commit
also removed the NOP instruction after the 'jr ra' when returning
back to the caller. This had no visible side-effects since the next
instruction was a load to the t0 register which was already in the
clobbered list, but it may have undesired effects in the future
if some other code is introduced in between the .Ldone and
the .Ll_exc_copy labels.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/8512/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/lib/memcpy.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/lib/memcpy.S
+++ b/arch/mips/lib/memcpy.S
@@ -503,6 +503,7 @@
 	STOREB(t0, NBYTES-2(dst), .Ls_exc_p1\@)
 .Ldone\@:
 	jr	ra
+	 nop
 	.if __memcpy == 1
 	END(memcpy)
 	.set __memcpy, 0


