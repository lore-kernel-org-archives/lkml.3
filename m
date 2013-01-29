Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab3A2Nps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:45:48 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:44396 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3A2Npn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:45:43 -0500
Message-ID: <5107D263.4090606@synopsys.com>
Date: Tue, 29 Jan 2013 19:15:07 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>
Subject: Re: [PATCH v3 02/71] ARC: Build system: Makefiles, Kconfig, Linker
 script
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com> <1359024639-21915-3-git-send-email-vgupta@synopsys.com> <51061AD0.4020200@synopsys.com> <20130128184419.GA24853@merkur.ravnborg.org>
In-Reply-To: <20130128184419.GA24853@merkur.ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2013 12:14 AM, Sam Ravnborg wrote:
> On Mon, Jan 28, 2013 at 11:59:36AM +0530, Vineet Gupta wrote:
>> Hi Sam,
>>
>> On Thursday 24 January 2013 04:20 PM, Vineet Gupta wrote:
>>> Arnd in his review pointed out that arch Kconfig organisation has several
>>> deficiencies:
>>>
>>> * Build time entries for things which can be runtime extracted from DT
>>>   (e.g. SDRAM size, core clk frequency..)
>>> * Not multi-platform-image-build friendly (choice .. endchoice constructs)
>>> * cpu variants support (750/770) is exclusive.
>>>
>>> The first 2 have been fixed in subsequent patches.
>>> Due to the nature of the 750 and 770, it is not possible to build for
>>> both together, w/o special runtime glue code which would hurt
>>> performance.
>>>
>>> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Cc: Sam Ravnborg <sam@ravnborg.org>
> Looks good - all former comments addressed, and nothing were jumping
> into my eyes now.
> Many existing architectures looks worse from the build stuff perspective...
>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
>
> 	Sam

Thx Sam. I have a following one liner change to the version you reviewed. Will it
be OK to add your ACK despite that or do I need to send the updated patch for you
to take a look again.

-Vineet

------------------------->8-----------------------
diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index 3fecd6f..b41e786 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -8,6 +8,7 @@
 
 menuconfig ARC_PLAT_FPGA_LEGACY
     bool "\"Legacy\" ARC FPGA dev Boards"
+    select ISS_SMP_EXTN if SMP
     help
       Support for ARC development boards, provided by Synopsys.
       These are based on FPGA or ISS. e.g.
@@ -19,7 +20,6 @@ if ARC_PLAT_FPGA_LEGACY
 
 config ARC_BOARD_ANGEL4
     bool "ARC Angel4"
-    select ISS_SMP_EXTN if SMP
     default y
     help
       ARC Angel4 FPGA Ref Platform (Xilinx Virtex Based)
------------------------->8-----------------------

