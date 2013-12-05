Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab3LEDoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 22:44:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52212 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab3LEDoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 22:44:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC part3 PATCH 1/2] clocksource / arch_timer: Use ACPI GTDT table to initialize arch timer
Date: Thu, 5 Dec 2013 04:43:21 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Jon Masters <jonathan@jonmasters.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <1386088891-2917-1-git-send-email-hanjun.guo@linaro.org> <1386088891-2917-2-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1386088891-2917-2-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312050443.21858.arnd@arndb.de>
X-Provags-ID: V02:K0:BIlZg/Brvb4PAD85cTqygynE3koZye3xQW0abD37rPM
 Cuvdtv64/057TGN30PoVvKiMTtuwlTHCAbcKXsVyrXQKzLJZsT
 +aY68V5WJpQK/uhWlpNUfM83fGyk1in5HC5ooaGrGwBn8BSYhp
 lDJ9cQmH/xUdPFSQe8mV0kNG0htnut12xnO16S+RHFqqwNOm19
 fO80RNLIeM1252CoOzFhx1GgdbwaSUaI+W6Qlkn8UrjtHlT3uS
 aeK5KxXAemgggLFfFu7tRM6k5xcGFUfrUyCprMY4UIqoo+0RkX
 9NqaBxorGErQsW03fgfeJOZfl7L1L0beSSVk+DkIeEBeWt5FmY
 yyEaPla86Zn+XlJFdZjw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 December 2013, Hanjun Guo wrote:

> +#ifdef CONFIG_ACPI
> +void __init arch_timer_acpi_init(void)
> +{
...
> +}
> +#else
> +void __init arch_timer_acpi_init(void) { return; };
> +#endif
>  

The #else clause is broken in combination with 

> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
> index 6d26b40..2654edf 100644
> --- a/include/clocksource/arm_arch_timer.h
> +++ b/include/clocksource/arm_arch_timer.h
> @@ -66,6 +66,11 @@ static inline struct timecounter *arch_timer_get_timecounter(void)
>  	return NULL;
>  }
>  
> +static inline void arch_timer_acpi_init(void)
> +{
> +	return;
> +}
> +
>  #endif
>  

this inline function. Have you build-tested this with CONFIG_ACPI disabled?

	Arnd
