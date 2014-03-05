Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbaCEBtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:49:20 -0500
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:46889 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754729AbaCEBtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:49:14 -0500
MIME-Version: 1.0
In-Reply-To: <1393948204-11555-6-git-send-email-Liviu.Dudau@arm.com>
References: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com>
	<1393948204-11555-6-git-send-email-Liviu.Dudau@arm.com>
Date: Tue, 4 Mar 2014 17:49:13 -0800
Message-ID: <CACoXjcmKKObSFignRWZAuOmmvfFtLf5O04Y5romJ=c6a9Jriqg@mail.gmail.com>
Subject: Re: [PATCH v5 5/7] pci: Use parent domain number when allocating
 child busses.
From: Tanmay Inamdar <tinamdar@apm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 4, 2014 at 7:50 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> pci_alloc_child_bus() uses the newly allocated child bus to figure
> out the domain number that is going to use for setting the device
> name. A better option is to use the parent bus domain number.
>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 26237a0..a12cda5 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -677,7 +677,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>          * now as the parent is not properly set up yet.
>          */
>         child->dev.class = &pcibus_class;
> -       dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(child), busnr);
> +       dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(parent), busnr);
>
>         /*
>          * Set up the primary, secondary and subordinate
> --
> 1.9.0
>

This patch is not required after the fix in pci_domain_nr for arm64.
