Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbaFLIeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:34:16 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:46527 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbaFLIeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:34:12 -0400
Message-ID: <5399660F.1020800@linaro.org>
Date: Thu, 12 Jun 2014 10:34:23 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de
CC: linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v2 0/5] APEI: Make APEI architecture independent.
References: <1401262770-25343-1-git-send-email-tomasz.nowicki@linaro.org>
In-Reply-To: <1401262770-25343-1-git-send-email-tomasz.nowicki@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to kindly remind and request for comments on this patches.

Regards,
Tomasz

On 28.05.2014 09:39, Tomasz Nowicki wrote:
> APEI is currently implemented so that it depends on x86 hardware.
> The primary dependency is that GHES uses the x86 NMI for hardware
> error notification and MCE for memory error handling. These patches
> remove that dependency.
>
> Other APEI features such as error reporting via external IRQ, error
> serialization, or error injection, do not require changes to use them
> on non-x86 architectures.
>
> The following patch set eliminates the APEI Kconfig x86 dependency
> by making these changes:
> - treat NMI notification as GHES feature - CONFIG_ACPI_APEI_NMI
> - reorganize GHES notification type init/deinitialization
>    so that we can decide in run time whether NMI is supported or not
> - identify architectural boxes and abstract it accordingly (NMI and MCE)
> - rework ioremap for both IRQ and NMI context
>
> NMI code is kept in ghes.c file since NMI and IRQ context are tightly coupled.
>
> Note, these patches introduce no functional changes for x86. The NMI notification
> feature is selected for x86 by default. Architectures that want to use this
> feature should also provide NMI code infrastructure.
>
> V1->V2
> - address Borislav comment
> - abstract arch-specific calls instead of wrapping into the #ifdef
>
> Tomasz Nowicki (5):
>    apei, mce: Factor out APEI architecture specific MCE calls.
>    acpi, apei, ghes: Introduce ACPI_APEI_NMI to make NMI error
>      notification a GHES feature.
>    acpi, apei, ghes: Introduce more generic mechanism to init/deinit
>      GHES error notifications.
>    apei, ghes, nmi: Factor out NMI arch-specific calls.
>    acpi, apei, ghes: Factor out ioremap virtual memory for IRQ and NMI
>      context.
>
>   arch/x86/kernel/acpi/Makefile |    1 +
>   arch/x86/kernel/acpi/apei.c   |   87 ++++++++++++
>   drivers/acpi/apei/Kconfig     |   10 +-
>   drivers/acpi/apei/apei-base.c |   32 +++++
>   drivers/acpi/apei/ghes.c      |  301 +++++++++++++++++++++++++----------------
>   drivers/acpi/apei/hest.c      |   26 +---
>   include/acpi/apei.h           |   11 ++
>   7 files changed, 328 insertions(+), 140 deletions(-)
>   create mode 100644 arch/x86/kernel/acpi/apei.c
>
