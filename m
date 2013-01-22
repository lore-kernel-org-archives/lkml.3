Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3AVRfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:35:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52263 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab3AVRfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:35:42 -0500
Date: Tue, 22 Jan 2013 18:38:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: rjw@sisk.pl, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Leonid Isaev <lisaev@umail.iu.edu>
Subject: Re: [PATCH] Add module aliases for acpi-cpufreq
Message-ID: <20130122173835.GB6431@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Matthew Garrett <matthew.garrett@nebula.com>, rjw@sisk.pl,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	cpufreq@vger.kernel.org, Leonid Isaev <lisaev@umail.iu.edu>
References: <1358872944-7676-1-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1358872944-7676-1-git-send-email-matthew.garrett@nebula.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 11:42:24AM -0500, Matthew Garrett wrote:
> The acpi core will call request_module("acpi-cpufreq") on subsystem init,
> but this will fail if the module isn't available at that stage of boot.
> Add some module aliases to ensure that udev can load the module on Intel
> and AMD systems with the appropriate feature bits - I /think/ that this
> will also work on VIA systems, but haven't verified that.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

Let's add some more tags:

Link: http://lkml.kernel.org/r/1448223.sdUJnNSRz4@vostro.rjw.lan
Tested-by: Leonid Isaev <lisaev@umail.iu.edu>
Acked-by: Borislav Petkov <bp@suse.de>

Rafael, this is all yours. :-)

Thanks.

> ---
>  drivers/cpufreq/acpi-cpufreq.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
> index 0d048f6..7b0d49d 100644
> --- a/drivers/cpufreq/acpi-cpufreq.c
> +++ b/drivers/cpufreq/acpi-cpufreq.c
> @@ -1030,4 +1030,11 @@ MODULE_PARM_DESC(acpi_pstate_strict,
>  late_initcall(acpi_cpufreq_init);
>  module_exit(acpi_cpufreq_exit);
>  
> +static const struct x86_cpu_id acpi_cpufreq_ids[] = {
> +	X86_FEATURE_MATCH(X86_FEATURE_ACPI),
> +	X86_FEATURE_MATCH(X86_FEATURE_HW_PSTATE),
> +	{}
> +};
> +MODULE_DEVICE_TABLE(x86cpu, acpi_cpufreq_ids);
> +
>  MODULE_ALIAS("acpi");
> -- 
> 1.8.0.2
> 
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
