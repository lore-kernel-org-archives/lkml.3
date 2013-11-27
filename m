Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755Ab3K0CAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:00:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834Ab3K0A5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, ben@decadent.org.uk
Subject: [PATCH 3.4 33/39] powerpc/vio: use strcpy in modalias_show
Date: Tue, 26 Nov 2013 16:56:57 -0800
Message-Id: <20131127005621.364799125@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005619.011763867@linuxfoundation.org>
References: <20131127005619.011763867@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prarit Bhargava <prarit@redhat.com>

commit 411cabf79e684171669ad29a0628c400b4431e95 upstream.

Commit e82b89a6f19bae73fb064d1b3dd91fcefbb478f4 used strcat instead of
strcpy which can result in an overflow of newlines on the buffer.

Signed-off-by: Prarit Bhargava
Cc: benh@kernel.crashing.org
Cc: ben@decadent.org.uk
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/vio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1342,12 +1342,12 @@ static ssize_t modalias_show(struct devi
 
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
 


