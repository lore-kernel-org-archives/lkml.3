Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab3EGED7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:03:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8035 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760341Ab3EGD6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:54 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=AB216oD2IGAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_WC_M6a3ZY4A:10 a=DfNHnWVPAAAA:8 a=danhDmx_AAAA:8 a=pGLkceISAAAA:8 a=mK_AVkanAAAA:8 a=vmLDa1wCAAAA:8 a=VwQbUJbxAAAA:8 a=cq5IILDZAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=lBRciGGoxdUA:10 a=MSl-tDqOz04A:10 a=9xyTavCNlvEA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035847.818086055@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
        <netdev@vger.kernel.org>, Tim Gardner <tim.gardner@canonical.com>
Subject: [041/126] rt2x00: rt2x00pci_regbusy_read() - only print register access
 failure once
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0041-rt2x00-rt2x00pci_regbusy_read-only-print-register-ac.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Tim Gardner <tim.gardner@canonical.com>

[ Upstream commit 83589b30f1e1dc9898986293c9336b8ce1705dec ]

BugLink: http://bugs.launchpad.net/bugs/1128840

It appears that when this register read fails it never recovers, so
I think there is no need to repeat the same error message ad infinitum.

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/rt2x00/rt2x00pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index a0c8cae..b1c673e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -52,8 +52,8 @@ int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
-	ERROR(rt2x00dev, "Indirect register access failed: "
-	      "offset=0x%.08x, value=0x%.08x\n", offset, *reg);
+	printk_once(KERN_ERR "%s() Indirect register access failed: "
+	      "offset=0x%.08x, value=0x%.08x\n", __func__, offset, *reg);
 	*reg = ~0;
 
 	return 0;
-- 
1.7.10.4


