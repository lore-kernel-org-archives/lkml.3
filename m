Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaGaWP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:15:28 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51788 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751829AbaGaWPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:15:24 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / processor: Make it possible to get local x2apic id via _MAT
Date: Fri, 01 Aug 2014 00:33:58 +0200
Message-ID: <2739917.F5vOHu97Pp@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406604470-4800-1-git-send-email-hanjun.guo@linaro.org>
References: <1406604470-4800-1-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 29, 2014 11:27:50 AM Hanjun Guo wrote:
> Logical processors with APIC ID values of 255 and greater are
> required to have a Processor Device object and must convey the
> processor's APIC information to OSPM using the Processor Local
> X2APIC structure, but not until ACPI 5.1, X2APIC structure was
> not supported in _MAT method.
> 
> _MAT is needed for CPU hotplug and system with more than 255
> CPUs will definitely need X2APIC structure, so add its support
> in map_mat_entry() to make it possible to get local x2apic id
> via _MAT based on ACPI 5.1.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>

Applied, thanks!

> ---
>  drivers/acpi/processor_core.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index 00f48d1..e32321c 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -129,6 +129,8 @@ static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
>  		map_lapic_id(header, acpi_id, &apic_id);
>  	} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
>  		map_lsapic_id(header, type, acpi_id, &apic_id);
> +	} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
> +		map_x2apic_id(header, type, acpi_id, &apic_id);
>  	}
>  
>  exit:
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
