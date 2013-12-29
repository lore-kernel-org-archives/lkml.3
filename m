Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab3L2C52 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:57:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55079 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093Ab3L2CJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:59 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Prarit Bhargava" <prarit@redhat.com>,
        benh@kernel.crashing.org, Prarit@decadent.org.uk
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.255279067@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 018/185] powerpc/vio: use strcpy in modalias_show
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Prarit Bhargava <prarit@redhat.com>

commit 411cabf79e684171669ad29a0628c400b4431e95 upstream.

Commit e82b89a6f19bae73fb064d1b3dd91fcefbb478f4 used strcat instead of
strcpy which can result in an overflow of newlines on the buffer.

Signed-off-by: Prarit Bhargava
Cc: benh@kernel.crashing.org
Cc: ben@decadent.org.uk
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/vio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1352,12 +1352,12 @@ static ssize_t modalias_show(struct devi
 
 	dn = dev->of_node;
 	if (!dn) {
-		strcat(buf, "\n");
+		strcpy(buf, "\n");
 		return strlen(buf);
 	}
 	cp = of_get_property(dn, "compatible", NULL);
 	if (!cp) {
-		strcat(buf, "\n");
+		strcpy(buf, "\n");
 		return strlen(buf);
 	}
 

