Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965Ab3D3Jdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:33:38 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:52388 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab3D3Jdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:33:37 -0400
Message-ID: <517F8FF4.3050901@atmel.com>
Date: Tue, 30 Apr 2013 11:33:40 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jon Medhurst <tixy@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: linux-next build error (at91) - use of bool in mach/arch.h
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Today I discovered an issue while building linux-next for at91:

  CC      arch/arm/mach-at91/at91sam9260_devices.o
In file included from /home/nferre/dev/lnx_buid_test/arch/arm/mach-at91/at91sam9260_devices.c:12:0:
/home/nferre/dev/lnx_buid_test/arch/arm/include/asm/mach/arch.h:46:2: error: expected specifier-qualifier-list before ‘bool’

It also applies to all non-DT at91 platforms (~ 6 machines).

It seems to be caused by inclusion of commmit
4dbfa9a25367cfa91aec0e56d75a6905d3242cd3 (ARM: Enable selection of 
SMP operations at boot time) and its use of the "bool" type.

In fact, we include asm/mach/arch.h file in our at91xxx_devices.c files and
we include it as the first include directive.

So, I am wondering if the best correction is to add the types.h header file
in the asm/mach/arch.h file, like this:

--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -8,6 +8,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/types.h>
+
 #ifndef __ASSEMBLY__
 
 struct tag;

or if a better option would be to re-arrange the include directives in
various at91xxx_devices.c files?

Thanks, bye,
-- 
Nicolas Ferre
