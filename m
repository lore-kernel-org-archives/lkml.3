Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaAQOM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:12:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52421 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaAQOMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:12:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [PATCH 09/20] ARM64 / ACPI: Implement core functions for parsing MADT table
Date: Fri, 17 Jan 2014 15:12:42 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, Charles.Garcia-Tobin@arm.com
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-10-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1389961514-13562-10-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401171512.42850.arnd@arndb.de>
X-Provags-ID: V02:K0:hUDM2AY7vyR1OpfbJKb1gBkBIW2cUHQ+Kgwpb1tuDNE
 WjycbH6wnIC0n3TJKddaoC4734m6vulseYpI/9HiWBEnKshC5v
 ckJAOuqQZHa2Zumhu0Hya+7cvxpu0UpRc//ojdmx6pYAJ0ny0z
 qQQd+OYDKRcS35xvC9KhQ8n0cTmuKnUBaQZ5Ix+1dFt5P1Goe+
 +53Th9sfOqCRbhJDfiUr1UAfgfVzsAzRbBXAerq00UwwrEEIwM
 LDARXW0/jgjeLHEyzRD53n0YqmeBFaCHnhXYzpr0ROCIEGRs57
 Qg6T1oOVpe/L1nIAq1lnPL5zsuVaCBT1fruzt7CG1em41CJvDj
 ZDadilkfNK+EkTUYoI1o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 January 2014, Hanjun Guo wrote:
>  
> +/*
> + * Local interrupt controller address,
> + * GIC cpu interface base address on ARM/ARM64
> + */
> +static u64 acpi_lapic_addr __initdata;

If it's cpu local, don't you need more than one address to support SMP?
Also, the variable appears to be write-only.

> +#define BAD_MADT_ENTRY(entry, end) (					\
> +	(!entry) || (unsigned long)entry + sizeof(*entry) > end ||	\
> +	((struct acpi_subtable_header *)entry)->length < sizeof(*entry))
> +

Better make this an inline function.

> +static int __init
> +acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
> +{
> +	struct acpi_madt_generic_interrupt *processor = NULL;
> +
> +	processor = (struct acpi_madt_generic_interrupt *)header;

You don't need the initialization in the first line when you write to the
variable before reading it. Same in the other functions.

	Arnd
