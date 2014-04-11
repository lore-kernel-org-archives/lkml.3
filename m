Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbaDKIdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:33:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12284 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaDKIdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:33:00 -0400
X-AuditID: cbfee690-b7f266d00000287c-b3-5347a8b749cb
Date: Fri, 11 Apr 2014 08:32:55 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] MIPS: Octeon: Add PCIe2 support in arch_setup_msi_irq()
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20140411082738059@eunb.song
Msgkey: 20140411082738059@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140411082738059@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <17481866.160581397205174247.JavaMail.weblogic@epv6ml10>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsVy+t8zTd3tK9yDDY7elbW4vGsOmwOjx+dN
	cgGMUQ2MNolFyRmZZakKqXnJ+SmZeem2SqEhbroWSgoZ+cUltkrRRgbGekamJnpGJuZ6lgax
	VkamSgp5ibmptkoVulC9SgpFyQVAtbmVxUADclL1oOJ6xal5KQ5Z+aUgl+gVJ+YWl+al6yXn
	5yoplCXmlAKNUNJPmMqYcbzjBHPBL96Krc0nWRsYT/B2MXJyCAmoSLT8/84IYksImEg0bL3D
	BmGLSVy4tx7I5gKqWcYo0TTrLTtM0Yq9fVCJ+YwSz89vA0uwCKhKTD+0mwXEZhPQlvhx4Coz
	iC0s4CFx7NRlsBoRARmJpZ+ugG1jFnCXePvpODPEFfISk09D1PAKCEqcnPmEBWKZksS/E8sY
	IeLKEhcvfGeCiEtIzJp+gRXC5pWY0f4Uql5OYtrXNcwQtrTE+VkbGGG+Wfz9MVScX+LY7R1A
	czjAep/cD4YZs3vzF6jnBSSmnjkI1aou0bPpONTvfBJrFr6FWiUocfpaNzNM7/0tc5kg3lKU
	mNL9kB3C1pL48mMfG7q3eAVcJCY9+ck6gVF5FpLULCTts5C0I6tZwMiyilE0tSC5oDgpvcgE
	ObY3MUIS4YQdjPcOWB9i3M8IjJOJzFKiyfnAVJpXEm9obGZkYWpiamxkbmlGobCJqYWFiRFV
	hJXEedUeJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYCwX6soTqzrXYzBRiNvT8Fdd4Stu
	kaeTWV4cjd1WMvfq8jPNjiIXL99qP5lxY3G+CZvKj18zWu4W/7bQsrCd/LWcu9RkOZvbpd7r
	JwSmRmrbHPSuL94f6GH3pUktd7f374/nlflfM7DO7Nd4N687RHGXjflFLeNL0n1Hfp+0uFyw
	Q/9pzIOcQ0osxRmJhlrMRcWJAFj8Jiz3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2TN3tK9yDDT7vlrK4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	Gcc7TjAX/OKt2Np8krWB8QRvFyMnh5CAikTL/++MILaEgInEir19bBC2mMSFe+uBbC6gmvmM
	Es/Pb2MHSbAIqEpMP7SbBcRmE9CW+HHgKjOILSzgIXHs1GWwGhEBGYmln66ADWUWcJd4++k4
	M8QyeYnJpyFqeAUEJU7OfMICsUxJ4t+JZYwQcWWJixe+M0HEJSRmTb/ACmHzSsxofwpVLycx
	7esaZghbWuL8rA2MMEcv/v4YKs4vcez2DqA5HGC9T+4Hw4zZvfkL1I8CElPPHIRqVZfo2XSc
	HcLmk1iz8C3UKkGJ09e6mWF672+ZywTxlqLElO6H7BC2lsSXH/vY0L3FK+AiMenJT9YJjHKz
	kKRmIWmfhaQdWc0CRpZVjKKpBckFxUnpFUZ6xYm5xaV56XrJ+bmbGMEp6tmiHYz/zlsfYhTg
	YFTi4T1wyS1YiDWxrLgy9xCjBAezkgjvs2XuwUK8KYmVValF+fFFpTmpxYcYk4EROJFZSjQ5
	H5g+80riDY0NjA0NLc0NTA2NLEgTVhLnlb+VFCQkkJ5YkpqdmlqQWgSzhYmDU6qBUdZz9czt
	++7pNzx5lqR77/46l0kKYqKxzzl/3/grHr+Dw+a7h0jMfbnvoW53+k92zNr88bBo27s9VffV
	r66a9EVvmlbGtOk9u86u/a4Zavus6GxceuZjy7B7yzaWHvvfpW33WjbQly9ImHvGy93Rp69P
	/axVaB5Vo/Ro1auV6is7pV7IbpaZ9EWJpTgj0VCLuag4EQAD3LGAlQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3B8XILO001438


In arch_setup_msi_irq(), there is no case for PCIe2. So board which have PCIe2 functionality
fails to boot with "Kernel panic - not syncing: arch_setup_msi_irq: Invalid octeon_dma_bar_type"
message. This patch solve this problem.

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/mips/pci/msi-octeon.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/mips/pci/msi-octeon.c b/arch/mips/pci/msi-octeon.c
index 2b91b0e..ab0c5d1 100644
--- a/arch/mips/pci/msi-octeon.c
+++ b/arch/mips/pci/msi-octeon.c
@@ -15,6 +15,7 @@
 #include <asm/octeon/cvmx-npi-defs.h>
 #include <asm/octeon/cvmx-pci-defs.h>
 #include <asm/octeon/cvmx-npei-defs.h>
+#include <asm/octeon/cvmx-sli-defs.h>
 #include <asm/octeon/cvmx-pexp-defs.h>
 #include <asm/octeon/pci-octeon.h>
 
@@ -162,6 +163,11 @@ msi_irq_allocated:
 		msg.address_lo = (0 + CVMX_NPEI_PCIE_MSI_RCV) & 0xffffffff;
 		msg.address_hi = (0 + CVMX_NPEI_PCIE_MSI_RCV) >> 32;
 		break;
+	case OCTEON_DMA_BAR_TYPE_PCIE2:
+		/* When using PCIe2, Bar 0 is based at 0 */
+		msg.address_lo = (0 + CVMX_SLI_PCIE_MSI_RCV) & 0xffffffff;
+		msg.address_hi = (0 + CVMX_SLI_PCIE_MSI_RCV) >> 32;
+		break;
 	default:
 		panic("arch_setup_msi_irq: Invalid octeon_dma_bar_type");
 	}
-- 
1.7.0.1
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
