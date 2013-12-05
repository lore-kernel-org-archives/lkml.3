Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab3LEDix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 22:38:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64589 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab3LEDiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 22:38:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC part1 PATCH 5/7] ARM64 / ACPI: Introduce arm_core.c and its related head file
Date: Thu, 5 Dec 2013 04:38:04 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linaro-kernel@lists.linaro.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Al Stone <al.stone@linaro.org>, patches@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <1386088611-2801-6-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1386088611-2801-6-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312050438.05117.arnd@arndb.de>
X-Provags-ID: V02:K0:vmIyr1JDoVe0wwp2cT3VS0TBzw4hbxun/3uQ1uE/B/M
 tgK4UACrwVfDwXaZSoopDSI9GGXTIh+Yc958d2fM16sNnqiWwB
 fBbEYaECTjOOkXPNzhXQXUs0XhcgL8XtNTvmuYwJFayIIf5oPE
 lXv3qiIZq3YFV9B+4Oao5TcyOXSMolL+jUzaBKggJQcUN6jkZa
 od7Fr5wpdP76pLqijGVc3pEapV/mgfZWQarKHsSQODEdiRKpRk
 L0OaSHE62p9CxT6i+0gq3ot3U55M+vAS7S/lULA6PEOJu8TVUu
 f9jz74CSTZcKUzsvTbUpVFfkxDjkaD0p7WSzBMwYPPYjb2/HXO
 zQ+csaH0DMIHVd6e/PYQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 December 2013, Hanjun Guo wrote:
> +static unsigned int gsi_to_irq(unsigned int gsi)
> +{
> +       int irq = irq_create_mapping(NULL, gsi);
> +
> +       return irq;
> +}

I think this could use a comment regarding your plans for IRQ domains.

Do you expect that all ACPI systems would have only a single GIC IRQ
controller and a single domain, or do you plan to add irqdomain code
later?

	Arnd
