Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab3IBMBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 08:01:36 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52159 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757929Ab3IBMBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 08:01:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v2 0/6] Remove the duplicated _MAT evaluation and simplify _acpi_map_lsapic()
Date: Mon, 02 Sep 2013 14:12:22 +0200
Message-ID: <1961453.53nfG0bXEh@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1378094259-5922-1-git-send-email-hanjun.guo@linaro.org>
References: <1378094259-5922-1-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 02, 2013 11:57:33 AM Hanjun Guo wrote:
> v1->v2: Return specific error value instead of just return -1, and
> correct some grammar mistake in changelog.
> 
> For cpu hot add, evaluate _MAT or parse MADT will did twice to get
> APIC id:
> acpi_processor_add()
> 	acpi_processor_get_info()
> 		acpi_get_cpuid() will evaluate _MAT or parse MADT;
>         acpi_processor_hotadd_init()
>                 acpi_map_lsapic() will evaluate _MAT again;
> 
> This patch set introduces apic_id in struct processor to save parsed
> APIC id, and use it to remove the duplicated _MAT evaluation.
> 
> Further more, the new logical cpu number will be generated in
> acpi_register_lapic(), this can be returned to remove the cpumask
> allocation and operation to simplify _acpi_map_lsapic().
> 
> There are also some cleanups for the ACPI processor dirver code.

I like the series, so I've queued it up for 3.13.

Thanks,
Rafael


> Hanjun Guo (2):
>   ACPI / processor: remove unnecessary if (!pr) check
>   ACPI / processor: Remove outdated comments
> 
> Jiang Liu (4):
>   ACPI / processor: Introduce apic_id in struct processor to save
>     parsed APIC id
>   ACPI / processor: use apic_id and remove duplicated _MAT evaluation
>   x86 / ACPI: simplify _acpi_map_lsapic()
>   ACPI / processor: remove some dead code in acpi_processor_get_info()
> 
>  arch/ia64/kernel/acpi.c       |   38 ++----------------
>  arch/x86/include/asm/mpspec.h |    2 +-
>  arch/x86/kernel/acpi/boot.c   |   88 +++++++++--------------------------------
>  arch/x86/kernel/apic/apic.c   |    8 ++--
>  drivers/acpi/acpi_processor.c |   22 +++--------
>  drivers/acpi/processor_core.c |   26 +++++++++---
>  include/acpi/processor.h      |    3 ++
>  include/linux/acpi.h          |    2 +-
>  8 files changed, 60 insertions(+), 129 deletions(-)
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
