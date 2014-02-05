Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaBEIjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:39:17 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:45113 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaBEIjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:39:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVrkPybrONnw5fZaMZ-vuaq_arrBMZvnRYZ9EnvE8Y4cA@mail.gmail.com>
References: <20140205065243.29445.76593.sendpatchset@w520>
	<20140205065254.29445.77939.sendpatchset@w520>
	<CAMuHMdVrkPybrONnw5fZaMZ-vuaq_arrBMZvnRYZ9EnvE8Y4cA@mail.gmail.com>
Date: Wed, 5 Feb 2014 17:39:13 +0900
Message-ID: <CANqRtoTLdBVj9EF2nsZm2QXc-gCGigB8vfsVJGCjS1Ger0zFTg@mail.gmail.com>
Subject: Re: [PATCH 01/04] PCI: rcar: Register each instance independently
From: Magnus Damm <magnus.damm@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-pci@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Valentine <valentine.barshak@cogentembedded.com>,
        Simon Horman <horms@verge.net.au>, Bjorn Helgaas <bhelgaas@google.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 5:02 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Wed, Feb 5, 2014 at 7:52 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>> +static int rcar_pci_probe(struct platform_device *pdev)
>>  {
>>         struct resource *cfg_res, *mem_res;
>>         struct rcar_pci_priv *priv;
>>         void __iomem *reg;
>> +       struct hw_pci hw;
>>
>>         cfg_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>         reg = devm_ioremap_resource(&pdev->dev, cfg_res);
>> @@ -308,31 +271,26 @@ static int __init rcar_pci_probe(struct
>>         priv->reg = reg;
>>         priv->dev = &pdev->dev;
>>
>> -       return rcar_pci_add_controller(priv);
>> +       memset(&hw, 0, sizeof(hw));
>> +       hw.nr_controllers = 1;
>> +       hw.private_data = (void **)&priv;
>
> This raised a red flag: taking the address of a variable on the stack.
> I know it's correct, as hw.private_data is an array of pointers copied
> by pci_common_init_dev() below.
> But perhaps it's a good idea to turn priv into an array with one element,
> to make this clearer, and avoid the ugly cast?

I simply followed the same style as pci-tegra.c, but I agree that it
can be made prettier. Also, there may be some better way how to
register independent instances, not sure.

Thanks,

/ magnus
