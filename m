Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab3CZL5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 07:57:11 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:43146 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab3CZL5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 07:57:08 -0400
Date: Tue, 26 Mar 2013 12:57:07 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Tim Niemeyer <tim.niemeyer@corscience.de>,
        Thomas Weber <thomas.weber@corscience.de>
cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: regarding arm: update ARM_ERRATA_430973 Kconfig
Message-ID: <alpine.DEB.2.01.1303261247320.18121@pmeerw.net>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

regarding your patch against arch/arm/Kconfig:

@@ -1215,7 +1215,7 @@  config ARM_ERRATA_430973
 	depends on CPU_V7
 	help
 	  This option enables the workaround for the 430973 Cortex-A8
-	  (r1p0..r1p2) erratum. If a code sequence containing an ARM/Thumb
+	  (r1p*) erratum. If a code sequence containing an ARM/Thumb
 	  interworking branch is replaced with another code sequence at the
 	  same virtual address, whether due to self-modifying code or virtual
 	  to physical address re-mapping, Cortex-A8 does not recover from the


I am seeing strange segfault/illegal instructions fixed by enabling 
ARM_ERRATA_430973 on a TI OMAP3 DM3730, r3p2 IMHO (see below) 

ARM_ERRATA_430973 is relevant for which processors? have you checked the 
errata list? I had no luck obtaining it yet


cat /proc/cpuinfo 
Processor       : ARMv7 Processor rev 2 (v7l)
BogoMIPS        : 313.29
Features        : swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls 
CPU implementer : 0x41
CPU architecture: 7
CPU variant     : 0x3
CPU part        : 0xc08
CPU revision    : 2

thanks, p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)
