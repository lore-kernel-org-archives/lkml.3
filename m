Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbbAJCjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:39:54 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:43352 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbbAJCf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:28 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 01/16] frv: add struct pci_ops member names to initialization
Date: Fri,  9 Jan 2015 20:34:35 -0600
Message-Id: <1420857290-8373-2-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420857290-8373-1-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some instances of pci_ops initialization rely on the read/write members'
location in the struct. This is fragile and may break when adding new
members to the beginning of the struct.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/mb93090-mb00/pci-vdk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
index efa5d65..b073f4d 100644
--- a/arch/frv/mb93090-mb00/pci-vdk.c
+++ b/arch/frv/mb93090-mb00/pci-vdk.c
@@ -168,8 +168,8 @@ static int pci_frv_write_config(struct pci_bus *bus, unsigned int devfn, int whe
 }
 
 static struct pci_ops pci_direct_frv = {
-	pci_frv_read_config,
-	pci_frv_write_config,
+	.read = pci_frv_read_config,
+	.write = pci_frv_write_config,
 };
 
 /*
-- 
2.1.0

