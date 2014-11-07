Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaKGQQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:16:47 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:53599 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaKGQQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:16:45 -0500
MIME-Version: 1.0
In-Reply-To: <545B5D15.6030705@kapsi.fi>
References: <1414599796-30597-1-git-send-email-tomeu.vizoso@collabora.com>
 <1414599796-30597-11-git-send-email-tomeu.vizoso@collabora.com>
 <545B29AA.8030006@nvidia.com> <545B5D15.6030705@kapsi.fi>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Fri, 7 Nov 2014 17:16:23 +0100
X-Google-Sender-Auth: P1S1p4WOwpG4J6iq1AF76sAxYJw
Message-ID: <CAAObsKDW3zcgmFZ1BPLeqV7AwvKbWmPh6fEvhB=4q7r_f5KtSg@mail.gmail.com>
Subject: Re: [PATCH v3 10/13] memory: tegra: Add EMC (external memory
 controller) driver
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Scott Wood <scottwood@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Prabhakar Kushwaha <prabhakar@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 November 2014 12:35, Mikko Perttunen <mikko.perttunen@kapsi.fi> wrote:
> On 11/06/2014 09:56 AM, Alexandre Courbot wrote:
>>
>> On 10/30/2014 01:22 AM, Tomeu Vizoso wrote:
>>> +static int tegra_emc_probe(struct platform_device *pdev)
>>> +{
>>> +    struct tegra_emc *tegra;
>>> +    struct device_node *node;
>>> +    struct platform_device *mc_pdev;
>>> +    struct resource *res;
>>> +    u32 ram_code, node_ram_code;
>>> +    int err;
>>> +
>>> +    tegra = devm_kzalloc(&pdev->dev, sizeof(*tegra), GFP_KERNEL);
>>> +    if (!tegra)
>>> +        return -ENOMEM;
>>> +
>>> +    tegra->pdev = pdev;
>>> +
>>> +    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +    tegra->emc_regs = devm_ioremap_resource(&pdev->dev, res);
>>> +    if (IS_ERR(tegra->emc_regs)) {
>>> +        dev_err(&pdev->dev, "failed to map EMC regs\n");
>>> +        return PTR_ERR(tegra->emc_regs);
>>> +    }
>>> +
>>> +    node = of_parse_phandle(pdev->dev.of_node,
>>> +                "nvidia,memory-controller", 0);
>>> +    if (!node) {
>>> +        dev_err(&pdev->dev, "could not get memory controller\n");
>>> +        return -ENOENT;
>>> +    }
>>> +
>>> +    mc_pdev = of_find_device_by_node(node);
>>> +    if (!mc_pdev)
>>> +        return -ENOENT;
>>
>>
>> Isn't there a risk that we will return -ENOENT depending on the probe
>> order? I.e. if this device is probed before the MC device?
>
>
> Yes.. I remember having some trouble with this code. IIRC, I couldn't figure
> out a way to sanely detect if the MC driver had been probed or not. Clearly
> this is not good, though.

Yeah, I found this issue during testing and resorted to
subsys_initcall(). Any better ideas?

Thanks,

Tomeu
