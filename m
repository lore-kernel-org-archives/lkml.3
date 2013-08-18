Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab3HRUyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:54:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641Ab3HRUdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 16/34] powerpc/numa: Avoid stupid uninitialized warning from gcc
Date: Sun, 18 Aug 2013 13:34:29 -0700
Message-Id: <20130818203300.798270113@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit aa709f3bc92c6daaf177cd7e3446da2ef64426c6 upstream.

Newer gcc are being a bit blind here (it's pretty obvious we don't
reach the code path using the array if we haven't initialized the
pointer) but none of that is performance critical so let's just
silence it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -639,7 +639,7 @@ static void __init parse_drconf_memory(s
 	unsigned int n, rc, ranges, is_kexec_kdump = 0;
 	unsigned long lmb_size, base, size, sz;
 	int nid;
-	struct assoc_arrays aa;
+	struct assoc_arrays aa = { .arrays = NULL };
 
 	n = of_get_drconf_memory(memory, &dm);
 	if (!n)


