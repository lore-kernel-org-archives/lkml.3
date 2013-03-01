Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968Ab3CAE6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 23:58:54 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:57174 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAE6x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 23:58:53 -0500
MIME-Version: 1.0
Date: Fri, 1 Mar 2013 12:58:51 +0800
Message-ID: <CA+zQFfmZ49Z-jRCVWcErMTNusqqOGoiMm6JCAK1EpoioBMZmgA@mail.gmail.com>
Subject: [QUESTION] How can I understand ARM_DMA_MEM_BUFFERABLE?
From: =?GB2312?B?0e6/ycfX?= <itrifler@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone:

In the newest linux kernel version3.8, arch/arm/mm/Kconfig, there are
some menu like this:

872 *config ARM_DMA_MEM_BUFFERABLE*

 873         *bool "Use non-cacheable memory for DMA" if (CPU_V6 ||
CPU_V6K) && !CPU_V7*

 874         depends on !(MACH_REALVIEW_PB1176 || REALVIEW_EB_ARM11MP || \

 875                      MACH_REALVIEW_PB11MP)

 876         default y if CPU_V6 || CPU_V6K || CPU_V7

 877         help

 878           Historically, the kernel has used strongly ordered mappings to

 879           provide DMA coherent memory.  With the advent of ARMv7, mapping

 880           memory with differing types results in unpredictable behaviour,

 881           so on these CPUs, this option is forced on.

 882

 883           Multiple mappings with differing attributes is also unpredictable

 884           on ARMv6 CPUs, but since they do not have aggressive speculative

 885           prefetch, no harm appears to occur.

 886
 887           However, drivers may be missing the necessary barriers for ARMv6,

 888           and therefore turning this on may result in unpredictable driver

 889           behaviour.  Therefore, we offer this as an option.

 890
 891           You are recommended say 'Y' here and debug any affected drivers.



 I have three questions:

 1)Does this mean that I cann't get unbuffered DMA buffer on ARM
cortex a8(CPU_V7)?


 2)How can I¡¡allocate unbuffered DMA buffer on linux of cortex a8 platform?

 3)In the upper contex,there are:
   "With the advent of ARMv7, mapping memory with differing types
results in unpredictable    behaviour"
  What does "mapping memory with differing types" really mean?
