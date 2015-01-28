Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934221AbbA1CON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:14:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759870AbbA1B2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Kordik <kordikmarek@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 3.18 21/61] x86/PCI: Clip bridge windows to fit in upstream windows
Date: Tue, 27 Jan 2015 17:26:33 -0800
Message-Id: <20150128012639.348288159@linuxfoundation.org>
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

From: Yinghai Lu <yinghai@kernel.org>

commit 851b09369255a91e77f56d83e3643439ac5b209a upstream.

Every PCI-PCI bridge window should fit inside an upstream bridge window
because orphaned address space is unreachable from the primary side of the
upstream bridge.  If we inherit invalid bridge windows that overlap an
upstream window from firmware, clip them to fit and update the bridge
accordingly.

[bhelgaas: changelog]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
Reported-by: Marek Kordik <kordikmarek@gmail.com>
Tested-by: Marek Kordik <kordikmarek@gmail.com>
Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/pci/i386.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -216,7 +216,7 @@ static void pcibios_allocate_bridge_reso
 			continue;
 		if (r->parent)	/* Already allocated */
 			continue;
-		if (!r->start || pci_claim_resource(dev, idx) < 0) {
+		if (!r->start || pci_claim_bridge_resource(dev, idx) < 0) {
 			/*
 			 * Something is wrong with the region.
 			 * Invalidate the resource to prevent


