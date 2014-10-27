Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaJ0Wt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:49:29 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:38109 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaJ0Wt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:49:27 -0400
MIME-Version: 1.0
In-Reply-To: <1414387308-27148-6-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com> <1414387308-27148-6-git-send-email-jiang.liu@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 27 Oct 2014 16:49:06 -0600
Message-ID: <CAErSpo6hq9+RV9sFe2gZL2mMHTPEDGQDfqP5J=TAZtJsj_1-Pg@mail.gmail.com>
Subject: Re: [Patch v7 05/18] ACPI: Correct return value of acpi_dev_resource_address_space()
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <lenb@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 11:21 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> Change acpi_dev_resource_address_space() to return failure if the
> acpi_resource structure can't be converted to an ACPI address64
> structure, so caller could correctly detect failure.

Fixes: 046d9ce6820e ("ACPI: Move device resources interpretation code
from PNP to ACPI core")

Possible stable candidate?  046d9ce6820e appeared in v3.8.

> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/acpi/resource.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index 2ba8f02ced36..782a0d15c25f 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -200,7 +200,7 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
>
>         status = acpi_resource_to_address64(ares, &addr);
>         if (ACPI_FAILURE(status))
> -               return true;
> +               return false;
>
>         res->start = addr.minimum;
>         res->end = addr.maximum;
> --
> 1.7.10.4
>
