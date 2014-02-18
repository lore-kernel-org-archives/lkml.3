Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbaBRPLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:11:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60684 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756297AbaBRPLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:11:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI, PCI, ISA: Fix memory leak when there is no IRQ in the ACPI subsystem.
Date: Tue, 18 Feb 2014 16:26:37 +0100
Message-ID: <1444429.LQSjxavlaG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53033433.7080002@linaro.org>
References: <1392037211-29349-1-git-send-email-tomasz.nowicki@linaro.org> <87065822.vfIc9IskHH@vostro.rjw.lan> <53033433.7080002@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 18, 2014 11:21:39 AM Tomasz Nowicki wrote:
> On 18.02.2014 02:02, Rafael J. Wysocki wrote:
> > On Monday, February 10, 2014 02:00:11 PM Tomasz Nowicki wrote:
> >> Whenever we register ISA interrupt or not, we need to free the IRQ routing
> >> table entry.
> >>
> >> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> >> ---
> >>   drivers/acpi/pci_irq.c |    1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
> >> index b0e31b6..6ec0f36 100644
> >> --- a/drivers/acpi/pci_irq.c
> >> +++ b/drivers/acpi/pci_irq.c
> >> @@ -432,6 +432,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
> >>   #endif
> >>   		dev_warn(&dev->dev, "PCI INT %c: no GSI\n", pin_name(pin));
> >>
> >> +		kfree(entry);
> >
> > If I'm not mistaken, entry is always NULL here, isn't it?
>
> acpi_pci_link_allocate_irq() can return negative gsi even if entry != 
> NULL. For that case we'd have memory leak.

And that's what your changelog should be saying, isn't it?

Queued up for 3.14 and marked for -stable.  I had to rebase it, though, so
please check the result in linux-pm.git/linux-next.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
