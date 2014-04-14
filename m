Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaDNJVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:21:55 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:61073 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbaDNJVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:21:53 -0400
Date: Mon, 14 Apr 2014 11:21:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, toshi.kani@hp.com, riel@redhat.com,
        gong.chen@linux.intel.com, andi@firstfloor.org, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 5/5] acpi_processor: do not mark present at boot but
 not onlined CPU as onlined
Message-ID: <20140414092147.GD19771@gmail.com>
References: <1397150061-29735-1-git-send-email-imammedo@redhat.com>
 <1397150061-29735-6-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397150061-29735-6-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Igor Mammedov <imammedo@redhat.com> wrote:

> acpi_processor_add() assumes that present at boot CPUs
> are always onlined, it is not so if a CPU failed to become
> onlined. As result acpi_processor_add() will mark such CPU
> device as onlined in sysfs and following attempts to
> online/offline it using /sys/device/system/cpu/cpuX/online
> attribute will fail.
> 
> Do not poke into device internals in acpi_processor_add()
> and touch "struct device { .offline }" attribute, since
> for CPUs onlined at boot it's set by:
>   topology_init() -> arch_register_cpu() -> register_cpu()
> before ACPI device tree is parsed, and for hotplugged
> CPUs it's set when userspace onlines CPU via sysfs.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  drivers/acpi/acpi_processor.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)

Can this fix be moved first too, or does it have undesirable side 
effects on unmodified kernels?

Thanks,

	Ingo
