Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbaGVVJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:09:04 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:62276 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbaGVVI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:08:59 -0400
MIME-Version: 1.0
In-Reply-To: <1406020813-9176-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1406020813-9176-1-git-send-email-tomasz.nowicki@linaro.org>
Date: Tue, 22 Jul 2014 14:08:58 -0700
Message-ID: <CA+8MBb+KuKaeXr5p97xWZKJB7T-NAooi-kXQTaPx0QnO53-oCQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] APEI: Make APEI architecture independent.
From: Tony Luck <tony.luck@gmail.com>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        Borislav Petkov <bp@suse.de>, rric@kernel.org,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        X86-ML <x86@kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-acpi@lists.linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 2:20 AM, Tomasz Nowicki
<tomasz.nowicki@linaro.org> wrote:
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
> - treat NMI notification as GHES architecture - HAVE_ACPI_APEI_NMI
> - group and wrap around #ifdef CONFIG_HAVE_ACPI_APEI_NMI code which
>   is used only for NMI path
> - identify architectural boxes and abstract it accordingly (tlb flush and MCE)
> - rework ioremap for both IRQ and NMI context
>
> NMI code is kept in ghes.c file since NMI and IRQ context are tightly coupled.
>
> Note, these patches introduce no functional changes for x86. The NMI notification
> feature is hard selected for x86. Architectures that want to use this
> feature should also provide NMI code infrastructure.

Looks OK to me. I've thrown this series into a topic branch of the ras
git tree named "apei".  When I push it to kernel.org in a few minutes
the build test robots will pounce and try all sorts of randconfig builds.
They'll send you (and me) e-mails if they find any corner cases.

-Tony
