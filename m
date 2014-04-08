Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbaDHJYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 05:24:44 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:36068 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbaDHJYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:24:43 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARC: Remove ISS_SMP_EXTN entirely
Thread-Topic: [PATCH] ARC: Remove ISS_SMP_EXTN entirely
Thread-Index: AQHPUwhlTEyJveja0ESkki83qvmg4A==
Date: Tue, 8 Apr 2014 09:18:04 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751AC602@IN01WEMBXA.internal.synopsys.com>
References: <1396947368.26620.2.camel@x220>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.197.213]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tuesday 08 April 2014 02:26 PM, Paul Bolle wrote:
> The Kconfig symbol ARC_HAS_COH_RTSC was removed in v3.13. The Kconfig
> entry for ISS_SMP_EXTN still had a select for that symbol. That select
> was just removed in commit d345ea2892ae ("ARC: Remove
> ARC_HAS_COH_RTSC").
>
> But selecting ARC_HAS_COH_RTSC was the only thing ISS_SMP_EXTN ever
> did. That means that since v3.13 setting ISS_SMP_EXTN was effectively a
> nop anyhow. So ISS_SMP_EXTN can as well be removed entirely.

There's obvious bitrot here - however this code is not dead yet !
I have a unpushed fix which uses this Kconfig item.

diff --git a/arch/arc/plat-arcfpga/Makefile b/arch/arc/plat-arcfpga/Makefile
index a44e22ebc1b7..4d1bddc34b5b 100644
--- a/arch/arc/plat-arcfpga/Makefile
+++ b/arch/arc/plat-arcfpga/Makefile
@@ -9,4 +9,4 @@
 KBUILD_CFLAGS  += -Iarch/arc/plat-arcfpga/include
 
 obj-y := platform.o irq.o
-obj-$(CONFIG_SMP)              += smp.o
+obj-$(CONFIG_ISS_SMP_EXTN)             += smp.o

-Vineet
