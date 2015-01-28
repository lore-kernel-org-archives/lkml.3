Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbbA1CKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:10:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759895AbbA1B2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 3.18 33/61] ARM: mvebu: completely disable hardware I/O coherency
Date: Tue, 27 Jan 2015 17:26:45 -0800
Message-Id: <20150128012640.523026252@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 8f1e8ee28660018a935c7576b9af8ffe1feab54c upstream.

The current hardware I/O coherency is known to cause problems with DMA
coherent buffers, as it still requires explicit I/O synchronization
barriers, which is not compatible with the semantics expected by the
Linux DMA coherent buffers API.

So, in order to have enough time to validate a new solution based on
automatic I/O synchronization barriers, this commit disables hardware
I/O coherency entirely. Future patches will re-enable it.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-mvebu/coherency.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-mvebu/coherency.c
+++ b/arch/arm/mach-mvebu/coherency.c
@@ -398,9 +398,14 @@ static int coherency_type(void)
 	return type;
 }
 
+/*
+ * As a precaution, we currently completely disable hardware I/O
+ * coherency, until enough testing is done with automatic I/O
+ * synchronization barriers to validate that it is a proper solution.
+ */
 int coherency_available(void)
 {
-	return coherency_type() != COHERENCY_FABRIC_TYPE_NONE;
+	return false;
 }
 
 int __init coherency_init(void)


