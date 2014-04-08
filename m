Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbaDHKm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 06:42:26 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:54608 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756141AbaDHKmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 06:42:25 -0400
Message-ID: <1396953743.26620.23.camel@x220>
Subject: Re: [PATCH] ARC: Remove ISS_SMP_EXTN entirely
From: Paul Bolle <pebolle@tiscali.nl>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 08 Apr 2014 12:42:23 +0200
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230751AC602@IN01WEMBXA.internal.synopsys.com>
References: <1396947368.26620.2.camel@x220>
	 <C2D7FE5348E1B147BCA15975FBA230751AC602@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2014 10:42:23.0272 (UTC) FILETIME=[39991280:01CF5317]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vineet,

On Tue, 2014-04-08 at 09:18 +0000, Vineet Gupta wrote:
> There's obvious bitrot here - however this code is not dead yet !
> I have a unpushed fix which uses this Kconfig item.
> 
> diff --git a/arch/arc/plat-arcfpga/Makefile b/arch/arc/plat-arcfpga/Makefile
> index a44e22ebc1b7..4d1bddc34b5b 100644
> --- a/arch/arc/plat-arcfpga/Makefile
> +++ b/arch/arc/plat-arcfpga/Makefile
> @@ -9,4 +9,4 @@
>  KBUILD_CFLAGS  += -Iarch/arc/plat-arcfpga/include
>  
>  obj-y := platform.o irq.o
> -obj-$(CONFIG_SMP)              += smp.o
> +obj-$(CONFIG_ISS_SMP_EXTN)             += smp.o

I just realized that this means you're only using ISS_SMP_EXTN as an
alias for SMP, aren't you? Ie, smp.o will now be built if both
ARC_PLAT_FPGA_LEGACY and SMP are set. That will not change by this
patch.

So unless you're planning to do something else too if ISS_SMP_EXTN is
set there seems to be little value in using this symbol like that.


Paul Bolle

