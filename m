Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab3LEDs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 22:48:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56677 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab3LEDsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 22:48:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC part2 PATCH 8/9] ACPI / ARM64: Update acpi_register_gsi to register with the core IRQ subsystem
Date: Thu, 5 Dec 2013 04:48:09 +0100
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
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org> <1386088753-2850-9-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1386088753-2850-9-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312050448.10312.arnd@arndb.de>
X-Provags-ID: V02:K0:lEsA4+XVEhJ98hg1xNsVg+3Ehd5+7jQUZTzAK1+U+Es
 CmgqUZtkDxXclpkW72wuryD51teBknefmVrmn2vk2Qnl/1NlPr
 Nhz1kS8QH26aeS/H+iMIb+hSFsYTGye4AB7JJrNsfKWA1hdCUP
 v77FLlBhQ2ITzu2kfeuSDyIUsLXWBjFivVSwfNxpZLLUu6XlXv
 jQ8ZZoU7IdD22Q+sQ9xl4LHrdH7mpvrQlfN2wpiJn1DviuKCb5
 CZiF26kp6iuP7itr/9o2i28wTJ6iD6PVjhblSIZbDcBnYsb6wM
 vnKS5qmMfwMDaiTdUo3Hch/YPZ9XudpmDQ4f8LGvvACD/MYJTC
 r/cfkjqH+0m4TgPgWRJ4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 December 2013, Hanjun Guo wrote:
> +       /*
> +        * ACPI have no bindings to indicate SPI or PPI, so we
> +        * use different mappings from DT in ACPI.
> +        *
> +        * For FDT
> +        * PPI interrupt: in the range [0, 15];
> +        * SPI interrupt: in the range [0, 987];
> +        *
> +        * For ACPI, using identity mapping for hwirq:
> +        * PPI interrupt: in the range [16, 31];
> +        * SPI interrupt: in the range [32, 1019];

This difference might cause endless confusion. Can't you register PPI and SPI as
separate IRQ controllers to have the same number space that we normally have?

	Arnd
