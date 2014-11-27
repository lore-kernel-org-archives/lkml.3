Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbaK0XP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:15:56 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:54049 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaK0XPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:15:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Kevin Cernekee <cernekee@gmail.com>, grant.likely@linaro.org,
        kbuild-all@01.org, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hirokazu Takata <takata@linux-m32r.org>
Subject: Re: [PATCH V2 2/2] m32r: Add missing big-endian I/O accessors
Date: Fri, 28 Nov 2014 00:15:08 +0100
Message-ID: <3737870.23qKxazWvK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141127222034.GB16647@wfg-t540p.sh.intel.com>
References: <1417112193-14400-1-git-send-email-cernekee@gmail.com> <1417112193-14400-2-git-send-email-cernekee@gmail.com> <20141127222034.GB16647@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:fnO+R3Rn/d7owJUiuojt5og8mWYbsKonpcrn0qgmJBC
 DU3LWgeKWAb+k2XVPcMEYoamM3Vk7HaD6TDbYqZHJf0NIewVEm
 k6BDHGFr9FScTm1c2ZR1GTS+RLV8wyDGmRBLvZnuDM68ERazQB
 pc28GZ8wfr270G9Ny8YiwvOt4ZVsorr/ljNxGs//3AT4hW/+Us
 cUOqC/jvpuRdGmvo5KzKQSi2RQC0SWBwqSpb1rNBfLwl/wZcJj
 xJ7jDvdiqVOGuba/1MZTcXddYO4lANE0yC9FhRQx0/ADv6VcP+
 aP0RqOsS2yhjZWIvloFGf+/xx/4esaoON/Uf7WRPlH1KNSh1L1
 tXwPmQ0H1tII0MFL07gI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 14:20:34 Fengguang Wu wrote:
> Add CC to Hirokazu.
> 
> > Side note for Fengguang: both with and without my patches, m32r modules
> > fail to link using the make.cross script on Ubuntu 14.10:
>  
> Yes, the memory_start/memory_end link errors are really old m32r
> specific errors. The config file that can trigger this error is
> m32r-m32104ut_defconfig.

These should be trivial to fix:

diff --git a/arch/m32r/kernel/setup.c b/arch/m32r/kernel/setup.c
index 0392112a5d70..a5ecef7188ba 100644
--- a/arch/m32r/kernel/setup.c
+++ b/arch/m32r/kernel/setup.c
@@ -81,7 +81,10 @@ static struct resource code_resource = {
 };
 
 unsigned long memory_start;
+EXPORT_SYMBOL(memory_start);
+
 unsigned long memory_end;
+EXPORT_SYMBOL(memory_end);
 
 void __init setup_arch(char **);
 int get_cpuinfo(char *);

	Arnd
