Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbaE2Uow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:44:52 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:43903 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbaE2Uot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <1401379426-9701-1-git-send-email-galak@codeaurora.org>
References: <1401379426-9701-1-git-send-email-galak@codeaurora.org>
Date: Thu, 29 May 2014 15:44:47 -0500
Message-ID: <CAL_JsqLPFDwtd-QYDqCwx1JVj1Aa8=nof-e0P6R9CZra+fXHfw@mail.gmail.com>
Subject: Re: [PATCH] of: treat PCI config space as IORESOURCE_MEM type
From: Rob Herring <robherring2@gmail.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: Rob Herring <robh+dt@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liviu Dudau <liviu@dudau.co.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:03 AM, Kumar Gala <galak@codeaurora.org> wrote:
> If we have a PCI config space specified in something like a ranges
> property we should treat it as memory type resource.

Config space should not be in ranges[1]. We have some cases that are,
but we don't want new ones.

>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
>  drivers/of/address.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index cb4242a..4e7ee59 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -122,6 +122,9 @@ static unsigned int of_bus_pci_get_flags(const __be32 *addr)
>         u32 w = be32_to_cpup(addr);
>
>         switch((w >> 24) & 0x03) {
> +       case 0x00: /* cfg space */
> +               flags |= IORESOURCE_MEM;
> +               break;

How would you then distinguish actual memory ranges?

Rob

[1] http://www.spinics.net/lists/linux-pci/msg30585.html
