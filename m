Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbaCDVF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:05:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbaCDUDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.13 102/172] powerpc/powernv: Fix opal_xscom_{read,write} prototype
Date: Tue,  4 Mar 2014 12:03:06 -0800
Message-Id: <20140304200302.981286696@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 2f3f38e4d3d03dd4125cc9a1f49ab3cc91d8d670 upstream.

The OPAL firmware functions opal_xscom_read and opal_xscom_write
take a 64-bit argument for the XSCOM (PCB) address in order to
support the indirect mode on P8.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/opal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/opal.h
+++ b/arch/powerpc/include/asm/opal.h
@@ -720,8 +720,8 @@ int64_t opal_pci_next_error(uint64_t phb
 int64_t opal_pci_poll(uint64_t phb_id);
 int64_t opal_return_cpu(void);
 
-int64_t opal_xscom_read(uint32_t gcid, uint32_t pcb_addr, __be64 *val);
-int64_t opal_xscom_write(uint32_t gcid, uint32_t pcb_addr, uint64_t val);
+int64_t opal_xscom_read(uint32_t gcid, uint64_t pcb_addr, __be64 *val);
+int64_t opal_xscom_write(uint32_t gcid, uint64_t pcb_addr, uint64_t val);
 
 int64_t opal_lpc_write(uint32_t chip_id, enum OpalLPCAddressType addr_type,
 		       uint32_t addr, uint32_t data, uint32_t sz);


