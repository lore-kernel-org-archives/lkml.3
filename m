Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3LEUlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:41:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51703 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3LEUlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:41:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [RFC part1 PATCH 5/7] ARM64 / ACPI: Introduce arm_core.c and its related head file
Date: Thu, 5 Dec 2013 21:40:42 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
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
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <201312050438.05117.arnd@arndb.de> <52A084EB.5010103@linaro.org>
In-Reply-To: <52A084EB.5010103@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201312052140.42269.arnd@arndb.de>
X-Provags-ID: V02:K0:M6y8Yc8XZNpYlHtYek3ez89PU4TEAEGOdWPWIjPK0ev
 QPpwWDT3yvs9V8AGCEYIHNZLn7jid9G4ld/GjWNB+bdEnDdGLy
 dPI+p3HKwJRkpqoHEAEVL0mKQe3aAoPYPm6Rm42udlAqXcgu7z
 fCt6DAUpU3DdrMdomDutosDPJfE5rSvNSN+LFk7xh1yYGVyJOd
 tUdjSPYVKHTW0bZkWGIBL7aMAHffVGEs/bGVNY1f5PYFDtEMjU
 WtLk5vM3JmqXTXoFLlpbVdhY1RNWP61OBOuUSaozRoY08J1jVg
 Bnov9m8GLG1bHGY7HWmmqaNhz8SCkndMzin6KeMBeYtUUIsaCR
 z3FGxOra4ZHRuHCmIEWg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 December 2013, Hanjun Guo wrote:
> On 2013年12月05日 11:38, Arnd Bergmann wrote:
> > On Tuesday 03 December 2013, Hanjun Guo wrote:
> >> +static unsigned int gsi_to_irq(unsigned int gsi)
> >> +{
> >> +       int irq = irq_create_mapping(NULL, gsi);
> >> +
> >> +       return irq;
> >> +}
> > I think this could use a comment regarding your plans for IRQ domains.
> >
> > Do you expect that all ACPI systems would have only a single GIC IRQ
> > controller and a single domain, or do you plan to add irqdomain code
> > later?
> 
> we added irqdomain code in the part2 patch set, is that the code ok
> with you?

I don't see where it gets added. Do you mean "[RFC part2 PATCH 8/9] ACPI /
ARM64: Update acpi_register_gsi to register with the core IRQ subsystem"?
That still just uses a single domain.

When we talked about ACPI support at Linaro connect, someone mentioned
that the ACPI spec does have the concept of IRQ domains, but it seems
they are not implemented by Linux.

How do you get a mapping for an IRQ on a secondary irqchip such as
a GPIO extender?

	Arnd
