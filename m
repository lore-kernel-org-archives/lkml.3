Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3ILR3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:29:53 -0400
Received: from smtprelay0009.hostedemail.com ([216.40.44.9]:58083 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755490Ab3ILR3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:29:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:2:41:146:355:379:541:599:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:2198:2199:2393:2525:2560:2563:2682:2685:2689:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4117:4250:4321:4605:5007:6119:7652:7903:7904:8985:9025:10004:10848:11026:11232:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,C
X-HE-Tag: heart83_8fd7fb50f270b
X-Filterd-Recvd-Size: 6332
Message-ID: <1379006986.1944.3.camel@joe-AO722>
Subject: Re: [PATCH] dma: use %pa to print dma_addr_t
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Olof Johansson <olof@lixom.net>, Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 12 Sep 2013 10:29:46 -0700
In-Reply-To: <5231F45C.3020500@infradead.org>
References: <1378960710-15648-1-git-send-email-olof@lixom.net>
	 <5231F45C.3020500@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 10:05 -0700, Randy Dunlap wrote:
> On 09/11/13 21:38, Olof Johansson wrote:
> > This resolves some warnings seen when building with CONFIG_ARM_LPAE=y, since
> > dma_addr_t might then be 64-bit:
> > 
> >   drivers/dma/imx-sdma.c:1092:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
> >   drivers/dma/imx-sdma.c:1166:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
> >   drivers/dma/imx-dma.c:579:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
> >   drivers/dma/imx-dma.c:579:3: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
> >   drivers/dma/imx-dma.c:593:4: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat=]
> >   drivers/dma/imx-dma.c:603:4: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat=]
> >   drivers/dma/imx-dma.c:930:2: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
> >   drivers/dma/imx-dma.c:930:2: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
> >   drivers/dma/imx-dma.c:960:2: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
> >   drivers/dma/imx-dma.c:960:2: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
> >   drivers/dma/ipu/ipu_idmac.c:1235:2: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
> 
> 
> I've been tempted to make similar patches, but CONFIG_PHYS_ADDR_T_64BIT
> and CONFIG_ARCH_DMA_ADDR_T_64BIT are independent AFAICT,
> and %pa is for physical addresses, not necessarily DMA addresses.
> 
> Am I confused?

No.

https://lkml.org/lkml/2013/6/1/202

No.  If a dma_addr_t is really needed, then maybe
something like this:

---

 Documentation/printk-formats.txt | 11 +++++++++--
 lib/vsprintf.c                   | 33 +++++++++++++++++++++++++++------
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 445ad74..6f4eb32 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -55,14 +55,21 @@ Struct Resources:
 	For printing struct resources. The 'R' and 'r' specifiers result in a
 	printed resource with ('R') or without ('r') a decoded flags member.
 
-Physical addresses:
+Physical addresses types phys_addr_t:
 
-	%pa	0x01234567 or 0x0123456789abcdef
+	%pa[p]	0x01234567 or 0x0123456789abcdef
 
 	For printing a phys_addr_t type (and its derivatives, such as
 	resource_size_t) which can vary based on build options, regardless of
 	the width of the CPU data path. Passed by reference.
 
+DMA addresses types dma_addr_t:
+
+	%pad	0x01234567 or 0x0123456789abcdef
+
+	For printing a dma_addr_t type which can vary based on build options,
+	regardless of the width of the CPU data path. Passed by reference.
+
 Raw buffer as a hex string:
 	%*ph	00 01 02  ...  3f
 	%*phC	00:01:02: ... :3f
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 43c2ea0..4df18bc 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1154,6 +1154,30 @@ char *netdev_feature_string(char *buf, char *end, const u8 *addr,
 	return number(buf, end, *(const netdev_features_t *)addr, spec);
 }
 
+static noinline_for_stack
+char *address_val(char *buf, char *end, const void *addr,
+		  struct printf_spec spec, const char *fmt)
+{
+	unsigned long long num;
+
+	spec.flags |= SPECIAL | SMALL | ZEROPAD;
+	spec.base = 16;
+
+	switch (fmt[1]) {
+	case 'd':
+		num = *(const dma_addr_t *)addr;
+		spec.field_width = sizeof(dma_addr_t) * 2 + 2;
+		break;
+	case 'p':
+	default:
+		num = *(const phys_addr_t *)addr;
+		spec.field_width = sizeof(phys_addr_t) * 2 + 2;
+		break;
+	}
+
+	return number(buf, end, num, spec);
+}
+
 int kptr_restrict __read_mostly;
 
 /*
@@ -1217,7 +1241,8 @@ int kptr_restrict __read_mostly;
  *              N no separator
  *            The maximum supported length is 64 bytes of the input. Consider
  *            to use print_hex_dump() for the larger input.
- * - 'a' For a phys_addr_t type and its derivative types (passed by reference)
+ * - 'a[pd]' For address types phys_addr_t, dma_addr_t and derivatives
+ *           (default assumed to be phys_addr_t, passed by reference)
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1324,11 +1349,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		}
 		break;
 	case 'a':
-		spec.flags |= SPECIAL | SMALL | ZEROPAD;
-		spec.field_width = sizeof(phys_addr_t) * 2 + 2;
-		spec.base = 16;
-		return number(buf, end,
-			      (unsigned long long) *((phys_addr_t *)ptr), spec);
+		return address_val(buf, end, ptr, spec, fmt);
 	case 'd':
 		return dentry_name(buf, end, ptr, spec, fmt);
 	case 'D':


