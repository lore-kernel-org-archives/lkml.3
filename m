Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab3AQMsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:48:04 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:43294 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab3AQMsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:48:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: "Gopalakrishnan, Aravind" <Aravind.Gopalakrishnan@amd.com>,
        Andre Przywara <andre@andrep.de>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas <linuxuser330250@gmx.net>
Subject: Re: [PATCH] powernow-k8: Add a kconfig dependency on acpi-cpufreq
Date: Thu, 17 Jan 2013 13:53:55 +0100
Message-ID: <7359167.GTsCEtNASI@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130117115844.GB3853@pd.tnic>
References: <1357780161-30581-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <20130117115436.GA3853@pd.tnic> <20130117115844.GB3853@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 17, 2013 12:58:44 PM Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> Date: Thu, 17 Jan 2013 12:44:20 +0100
> Subject: [PATCH] powernow-k8: Add a kconfig dependency on acpi-cpufreq
> 
> Andreas reports in https://bugzilla.kernel.org/show_bug.cgi?id=51741
> that with his Gentoo config, acpi-cpufreq wasn't enabled and powernow-k8
> couldn't handoff properly to acpi-cpufreq leading to running without
> P-state support (i.e., cores are constantly in P0).
> 
> To alleaviate that, we need to make powernow-k8 depend on acpi-cpufreq
> so that acpi-cpufreq is always present.

OK

Do we need that in -stable?

Rafael


> Cc: Andre Przywara <andre@andrep.de>
> Reported-by: Andreas <linuxuser330250@gmx.net>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  drivers/cpufreq/Kconfig.x86 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
> index 934854ae5eb4..7227cd734042 100644
> --- a/drivers/cpufreq/Kconfig.x86
> +++ b/drivers/cpufreq/Kconfig.x86
> @@ -106,7 +106,7 @@ config X86_POWERNOW_K7_ACPI
>  config X86_POWERNOW_K8
>  	tristate "AMD Opteron/Athlon64 PowerNow!"
>  	select CPU_FREQ_TABLE
> -	depends on ACPI && ACPI_PROCESSOR
> +	depends on ACPI && ACPI_PROCESSOR && X86_ACPI_CPUFREQ
>  	help
>  	  This adds the CPUFreq driver for K8/early Opteron/Athlon64 processors.
>  	  Support for K10 and newer processors is now in acpi-cpufreq.
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
