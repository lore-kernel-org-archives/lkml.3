Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3LTPcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:32:43 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:58121 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693Ab3LTPcj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:32:39 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 11
X-BigFish: VPS11(zzbb2dI98dI9371Ic89bh148cI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336hf3eih1155h)
X-WSS-ID: 0MY42ZV-07-F8N-02
X-M-MSG: 
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <linux-next@vger.kernel.org>
CC: Randy Dunlap <rdunlap@infradead.org>, Jim Davis <jim.epost@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH -next] Re: randconfig build error with next-20131210, in drivers/crypto/ccp/ccp-pci.c
Date: Fri, 20 Dec 2013 09:32:32 -0600
Message-ID: <8808826.01Y7Jbimcb@tlendack-t1>
Organization: Advanced Micro Devices, Inc.
User-Agent: KMail/4.11.2 (Linux/3.11.0-13-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <52B34A6D.7010903@infradead.org>
References: <CA+r1ZhhhUWhMqeyS0J7V5j-iYtCk24gszpJFif8hF2cwr5K6hg@mail.gmail.com> <1785749.ip5jsEzFz7@tlendack-t1> <52B34A6D.7010903@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday, December 19, 2013 11:35:09 AM Randy Dunlap wrote:
> On 12/10/13 07:34, Tom Lendacky wrote:
> > 
> > On Tuesday, December 10, 2013 07:21:36 AM Jim Davis wrote:
> >> Building with the attached random configuration file,
> >>
> >> drivers/crypto/ccp/ccp-pci.c: In function ‘ccp_get_msix_irqs’:
> >> drivers/crypto/ccp/ccp-pci.c:44:20: error: array type has incomplete
> >> element type
> >> drivers/crypto/ccp/ccp-pci.c:48:18: error: negative width in bit-field
> >> ‘<anonymous>’
> >> drivers/crypto/ccp/ccp-pci.c:51:2: error: implicit declaration of
> >> function ‘pci_enable_msix’ [-Werror=implicit-function-declaration]
> >> drivers/crypto/ccp/ccp-pci.c:76:2: error: implicit declaration of
> >> function ‘pci_disable_msix’ [-Werror=implicit-function-declaration]
> >> drivers/crypto/ccp/ccp-pci.c:44:20: warning: unused variable
> >> ‘msix_entry’ [-Wunused-variable]
> >> drivers/crypto/ccp/ccp-pci.c: In function ‘ccp_get_msi_irq’:
> >> drivers/crypto/ccp/ccp-pci.c:89:2: error: implicit declaration of
> >> function ‘pci_enable_msi’ [-Werror=implicit-function-declaration]
> >> drivers/crypto/ccp/ccp-pci.c:102:2: error: implicit declaration of
> >> function ‘pci_disable_msi’ [-Werror=implicit-function-declaration]
> >> cc1: some warnings being treated as errors
> >> make[3]: *** [drivers/crypto/ccp/ccp-pci.o] Error 1
> > 
> > Thanks for finding this, I'll update to the Kconfig to add PCI to
> > the 'depends on' statement.
> 
> Tom,
> 
> Can you get this patch and the HW_RANDOM patch merged into linux-next, please?
> linux-next builds are still failing for both of these reasons.

Please consider the following patch that addresses some randconfig
build errors being experienced in the linux-next tree.  This patch
has already been accepted in the cryptodev-2.6 tree with a commit
id of d5aa80952aba9071b50a74c8daf7feb1caa2fd8c.

---
From: Tom Lendacky <thomas.lendacky@amd.com>

crypto: ccp - CCP Kconfig fixes

Update the Kconfig to include PCI on the 'depends on'
and add 'select HW_RANDOM' to insure the necessary PCI
and HW_RANDOM functions are available/included in the
build.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/Kconfig     |    2 +-
 drivers/crypto/ccp/Kconfig |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 4954d75..9dee00f 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -401,7 +401,7 @@ config CRYPTO_DEV_ATMEL_SHA
 
 config CRYPTO_DEV_CCP
 	bool "Support for AMD Cryptographic Coprocessor"
-	depends on X86
+	depends on X86 && PCI
 	default n
 	help
 	  The AMD Cryptographic Coprocessor provides hardware support
diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 335ed5c..7639ffc 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -2,6 +2,7 @@ config CRYPTO_DEV_CCP_DD
 	tristate "Cryptographic Coprocessor device driver"
 	depends on CRYPTO_DEV_CCP
 	default m
+	select HW_RANDOM
 	help
 	  Provides the interface to use the AMD Cryptographic Coprocessor
 	  which can be used to accelerate or offload encryption operations


> 
> thanks,
> 

