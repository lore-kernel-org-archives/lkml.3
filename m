Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbaG3B57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:57:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbaG3BuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:50:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 3.15 07/37] xtensa: fix sysmem reservation at the end of existing block
Date: Tue, 29 Jul 2014 18:48:43 -0700
Message-Id: <20140730014827.989477337@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
References: <20140730014827.565626091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit be6ae382dc153da51cf066c8dd523aa955f02531 upstream.

When sysmem reservation occurs exactly at the end of an existing block
that block is deleted, because it is incorrectly included in the range
of memblocks to remove. Fix that by skipping such block.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -191,7 +191,7 @@ int __init mem_reserve(unsigned long sta
 		return -EINVAL;
 	}
 
-	if (it && start - it->start < bank_sz) {
+	if (it && start - it->start <= bank_sz) {
 		if (start == it->start) {
 			if (end - it->start < bank_sz) {
 				it->start = end;


