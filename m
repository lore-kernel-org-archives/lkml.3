Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030232Ab3HIB7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:59:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967747Ab3HIB73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 081/102] s390: add support for IBM zBC12 machine
Date: Thu,  8 Aug 2013 18:57:57 -0700
Message-Id: <20130809015029.323154441@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 594712276e737961d30e11eae80d403b2b3815df upstream.

Just add the new model number where appropiate.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/Kconfig         |    7 ++++---
 arch/s390/kernel/setup.c  |    1 +
 arch/s390/mm/init.c       |    1 +
 arch/s390/oprofile/init.c |    2 +-
 4 files changed, 7 insertions(+), 4 deletions(-)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -227,11 +227,12 @@ config MARCH_Z196
 	  not work on older machines.
 
 config MARCH_ZEC12
-	bool "IBM zEC12"
+	bool "IBM zBC12 and zEC12"
 	select HAVE_MARCH_ZEC12_FEATURES if 64BIT
 	help
-	  Select this to enable optimizations for IBM zEC12 (2827 series). The
-	  kernel will be slightly faster but will not work on older machines.
+	  Select this to enable optimizations for IBM zBC12 and zEC12 (2828 and
+	  2827 series). The kernel will be slightly faster but will not work on
+	  older machines.
 
 endchoice
 
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -998,6 +998,7 @@ static void __init setup_hwcaps(void)
 		strcpy(elf_platform, "z196");
 		break;
 	case 0x2827:
+	case 0x2828:
 		strcpy(elf_platform, "zEC12");
 		break;
 	}
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -69,6 +69,7 @@ static void __init setup_zero_pages(void
 		order = 2;
 		break;
 	case 0x2827:	/* zEC12 */
+	case 0x2828:	/* zEC12 */
 	default:
 		order = 5;
 		break;
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -440,7 +440,7 @@ static int oprofile_hwsampler_init(struc
 		switch (id.machine) {
 		case 0x2097: case 0x2098: ops->cpu_type = "s390/z10"; break;
 		case 0x2817: case 0x2818: ops->cpu_type = "s390/z196"; break;
-		case 0x2827:              ops->cpu_type = "s390/zEC12"; break;
+		case 0x2827: case 0x2828: ops->cpu_type = "s390/zEC12"; break;
 		default: return -ENODEV;
 		}
 	}


