Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaI2Oiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:38:46 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:52988 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaI2Oip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:38:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: suravee.suthikulpanit@amd.com
Cc: will.deacon@arm.com, liviu.dudau@arm.com, marc.zyngier@arm.com,
        mark.rutland@arm.com, catalin.marinas@arm.com, jason@lakedaemon.net,
        tglx@linutronix.de, robh+dt@kernel.org, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [RFC 3/4] arm64: Do not call enable PCI resources when specify PCI_PROBE_ONLY
Date: Mon, 29 Sep 2014 16:38:09 +0200
Message-ID: <4139946.HEULtVYyUh@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411937610-22125-4-git-send-email-suravee.suthikulpanit@amd.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <1411937610-22125-4-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:AYEE30SyKzDK2H8euu5subMO/pyO4ww3+Z7Ih7EKU/F
 POvH7VYQyM1lNQ4h4O5sAm5l+GVtY52NXsNalJQ4sx6JBpcWsp
 uAN3xIhCGjnpO/Qib84Z6HD15Y0BcE5lyUlfDNkbwe1qgFwp/x
 /GgtNPz8g7hBhsWSL+g1ySahX6XLo7p9uYRPyXG3O3ZKXIxfK+
 5wlt7s1rxSRgIC7Az1R8gJfB3PfonkE9KmFyrxS6ABZvJKBkTD
 if2CtxDO/dlgAdt/QYy6AcGJEzY8Xb+W6y8VxULpxixRW3+5AA
 RMWf851/8S+OAygS+XXlfuvd6p9PWZO+byBpxv/eNBy+/aaMqz
 w7gIe8CQlYa/5dJntFC0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 September 2014 15:53:29 suravee.suthikulpanit@amd.com wrote:
> diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
> index ce5836c..7fd4d2b 100644
> --- a/arch/arm64/kernel/pci.c
> +++ b/arch/arm64/kernel/pci.c
> @@ -68,3 +68,11 @@ void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent)
>         bus->domain_nr = domain;
>  }
>  #endif
> +
> +int pcibios_enable_device(struct pci_dev *dev, int mask)
> +{
> +       if (pci_has_flag(PCI_PROBE_ONLY))
> +               return 0;
> +
> +       return pci_enable_resources(dev, mask);
> +}

This doesn't look arm64 specific to me, and there is already a generic
pcibios_enable_device() function in drivers/pci/pci.c. Would it
be possible to move the check for PCI_PROBE_ONLY there without breaking
other architectures?

If that works, please do so.

	Arnd
