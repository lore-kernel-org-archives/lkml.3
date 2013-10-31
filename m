Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3JaQmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:42:43 -0400
Received: from [91.220.42.44] ([91.220.42.44]:49367 "EHLO
	service87.mimecast.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751609Ab3JaQmm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:42:42 -0400
Message-ID: <52728881.7000902@arm.com>
Date: Thu, 31 Oct 2013 16:42:41 +0000
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] arm: zynq: platsmp: Fix CPU presence check
References: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com> <1383235819-2552-2-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1383235819-2552-2-git-send-email-soren.brinkmann@xilinx.com>
X-OriginalArrivalTime: 31 Oct 2013 16:42:16.0711 (UTC) FILETIME=[289C2170:01CED658]
X-MC-Unique: 113103116421900601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soren,

On 31/10/13 16:10, Soren Brinkmann wrote:
> From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> 
> Fix an off-by-one error in the logic that checks if a CPU is present.
> The ncores variable is a count of cores while the cpu variable is a
> 0 based index. So if ncores == cpu, cpu is out of range. Fix this
> comparison so non-existent CPUs are not probed.
>

Not entirely related to this patch, I had found that zynq_smp_prepare_cpus is
setting cpu_present_mask which is redundant(CMIIW present == possible). I had
posted a patch[1] to remove that, consider including that in the series if you
think it make sense.

Regards,
Sudeep

[1] http://www.spinics.net/lists/arm-kernel/msg260734.html

> Signed-off-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  arch/arm/mach-zynq/platsmp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
> index 689fbbc3d9c8..2512624e657d 100644
> --- a/arch/arm/mach-zynq/platsmp.c
> +++ b/arch/arm/mach-zynq/platsmp.c
> @@ -39,7 +39,7 @@ int zynq_cpun_start(u32 address, int cpu)
>  	u32 trampoline_code_size = &zynq_secondary_trampoline_end -
>  						&zynq_secondary_trampoline;
>  
> -	if (cpu > ncores) {
> +	if (cpu >= ncores) {
>  		pr_warn("CPU No. is not available in the system\n");
>  		return -1;
>  	}
> 


