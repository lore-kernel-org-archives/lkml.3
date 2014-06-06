Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaFFK37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:29:59 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:46400 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaFFK36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:29:58 -0400
Message-ID: <539197C6.8090203@linux.vnet.ibm.com>
Date: Fri, 06 Jun 2014 15:58:22 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2/2] powerpc/powernv : Disable subcore for UP configs
References: <1402050065-18007-1-git-send-email-shreyas@linux.vnet.ibm.com> <1402050171-18270-1-git-send-email-shreyas@linux.vnet.ibm.com>
In-Reply-To: <1402050171-18270-1-git-send-email-shreyas@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060610-4790-0000-0000-000001DFD7B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 03:52 PM, Shreyas B. Prabhu wrote:
> Build throws following errors when CONFIG_SMP=n
> arch/powerpc/platforms/powernv/subcore.c: In function ‘cpu_update_split_mode’:
> arch/powerpc/platforms/powernv/subcore.c:274:15: error: ‘setup_max_cpus’ undeclared (first use in this function)
> arch/powerpc/platforms/powernv/subcore.c:285:5: error: lvalue required as left operand of assignment
> 
> 'setup_max_cpus' variable is relevant only on SMP, so there is no point
> working around it for UP. Furthermore, subcore itself is relevant only
> on SMP and hence the better solution is to exclude subcore.o and
> subcore-asm.o for UP builds.
> 
> Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
> Changes in v2:
> Excluding subcore-asm.o which is part of the subcore feature for UP configs.
> 
>  arch/powerpc/platforms/powernv/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/powernv/Makefile b/arch/powerpc/platforms/powernv/Makefile
> index 4ad0d34..d55891f 100644
> --- a/arch/powerpc/platforms/powernv/Makefile
> +++ b/arch/powerpc/platforms/powernv/Makefile
> @@ -1,9 +1,9 @@
>  obj-y			+= setup.o opal-takeover.o opal-wrappers.o opal.o opal-async.o
>  obj-y			+= opal-rtc.o opal-nvram.o opal-lpc.o opal-flash.o
>  obj-y			+= rng.o opal-elog.o opal-dump.o opal-sysparam.o opal-sensor.o
> -obj-y			+= opal-msglog.o subcore.o subcore-asm.o
> +obj-y			+= opal-msglog.o
> 
> -obj-$(CONFIG_SMP)	+= smp.o
> +obj-$(CONFIG_SMP)	+= smp.o subcore.o subcore-asm.o
>  obj-$(CONFIG_PCI)	+= pci.o pci-p5ioc2.o pci-ioda.o
>  obj-$(CONFIG_EEH)	+= eeh-ioda.o eeh-powernv.o
>  obj-$(CONFIG_PPC_SCOM)	+= opal-xscom.o
> 

