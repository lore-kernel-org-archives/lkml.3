Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3ASBZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:25:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:57214 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690Ab3ASBWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:22:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Shuah Khan <shuah.khan@hp.com>
Subject: [ 07/16] powerpc: fix wii_memory_fixups() compile error on 3.0.y tree
Date: Fri, 18 Jan 2013 17:21:45 -0800
Message-Id: <20130119012139.569066731@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119012138.680057206@linuxfoundation.org>
References: <20130119012138.680057206@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <shuah.khan@hp.com>

[not upstream as the code involved was removed in the 3.3.0 release]

Fix wii_memory_fixups() the following compile error on 3.0.y tree with
wii_defconfig on 3.0.y tree.

  CC      arch/powerpc/platforms/embedded6xx/wii.o
arch/powerpc/platforms/embedded6xx/wii.c: In function ‘wii_memory_fixups’:
arch/powerpc/platforms/embedded6xx/wii.c:88:2: error: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 2 has type ‘phys_addr_t’ [-Werror=format]
arch/powerpc/platforms/embedded6xx/wii.c:88:2: error: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘phys_addr_t’ [-Werror=format]
arch/powerpc/platforms/embedded6xx/wii.c:90:2: error: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 2 has type ‘phys_addr_t’ [-Werror=format]
arch/powerpc/platforms/embedded6xx/wii.c:90:2: error: format ‘%llx’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘phys_addr_t’ [-Werror=format]
cc1: all warnings being treated as errors
make[2]: *** [arch/powerpc/platforms/embedded6xx/wii.o] Error 1
make[1]: *** [arch/powerpc/platforms/embedded6xx] Error 2
make: *** [arch/powerpc/platforms] Error 2

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/embedded6xx/wii.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/embedded6xx/wii.c
+++ b/arch/powerpc/platforms/embedded6xx/wii.c
@@ -85,9 +85,11 @@ void __init wii_memory_fixups(void)
 	wii_hole_start = p[0].base + p[0].size;
 	wii_hole_size = p[1].base - wii_hole_start;
 
-	pr_info("MEM1: <%08llx %08llx>\n", p[0].base, p[0].size);
+	pr_info("MEM1: <%08llx %08llx>\n",
+		(unsigned long long) p[0].base, (unsigned long long) p[0].size);
 	pr_info("HOLE: <%08lx %08lx>\n", wii_hole_start, wii_hole_size);
-	pr_info("MEM2: <%08llx %08llx>\n", p[1].base, p[1].size);
+	pr_info("MEM2: <%08llx %08llx>\n",
+		(unsigned long long) p[1].base, (unsigned long long) p[1].size);
 
 	p[0].size += wii_hole_size + p[1].size;
 


