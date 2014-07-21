Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052AbaGUQlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:41:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57173 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbaGUQlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:41:16 -0400
Message-ID: <53CD424B.1090806@ti.com>
Date: Mon, 21 Jul 2014 12:39:39 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Rob Herring'" <robherring2@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Mohit Kumar'" <mohit.kumar@st.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Richard Zhu'" <r65037@freescale.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Marek Vasut'" <marex@denx.de>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Randy Dunlap'" <rdunlap@infradead.org>
Subject: Re: [PATCH v6 4/5] PCI: add PCI controller for keystone PCIe h/w
References: <1405696469-7172-1-git-send-email-m-karicheri2@ti.com> <1405696469-7172-5-git-send-email-m-karicheri2@ti.com> <CAL_JsqKheoWrSGtxPO=AE8g9iOAqfwRa=81Ku=Cfx8_gpDysOg@mail.gmail.com> <53C9839C.5090604@ti.com> <006001cfa485$4f4fcff0$edef6fd0$%han@samsung.com>
In-Reply-To: <006001cfa485$4f4fcff0$edef6fd0$%han@samsung.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2014 09:44 PM, Jingoo Han wrote:
> On Saturday, July 19, 2014 5:29 AM, Murali Karicheri wrote:
>> On 07/18/2014 03:31 PM, Rob Herring wrote:
>>> On Fri, Jul 18, 2014 at 10:14 AM, Murali Karicheri<m-karicheri2@ti.com>   wrote:
>> --- Cut ---
>>>> +
>>>> +Optional properties:-
>>>> +       phys: phandle to Generic Keystone SerDes phy for PCI
>>>> +       phy-names: name of the Generic Keystine SerDes phy for PCI
>>>> +         - If boot loader already does PCI link establishment, then phys and
>>>> +           phy-names shouldn't be present.
>>>> +       ti,enable-linktrain - Enable Link training.
>>>> +         - If boot loader already does PCI link establishment, then this
>>>> +           shouldn't be present.
>>>
>>> Can't you read from the h/w if the link is trained?
>
> I agree with Rob Herring's suggestion.
>
>>
>> Yes.
>>
>> There are customers who use this driver with PCI Link setup done in the
>> boot loader. This property tells the driver to bypass Link setup
>> procedure in that case. Is this undesirable and if so. how other
>> platforms handle it? Check first if link is trained or start the link
>> setup procedure? Let me know. If this is fine, please provide your Ack.
>
> Please, check the following code of Exynos PCIe diver.
>
> ./drivers/pci/host/pci-exynos.c
>
> static int exynos_pcie_establish_link(struct pcie_port *pp)
> {
> 	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
> 	void __iomem *elbi_base = exynos_pcie->elbi_base;
> 	void __iomem *pmu_base = exynos_pcie->pmu_base;
>
> 	if (dw_pcie_link_up(pp)) {
> 		dev_err(pp->dev, "Link already up\n");
> 		return 0;
> 	}
> 	.....
>
> In the case of Exynos PCIe, the Exynos PCIe driver checks the
> h/w bit such as PCIE_ELBI_LTSSM_ENABLE bit of PCIE_ELBI_RDLH_LINKUP
> offset register.
>
> If the link is already set up by the boot loader or other reasons,
> the driver will skip some initialization codes.
>
> The first step is that you find such h/w bit for checking link up.
> If so, please add the code for skipping, when the link is already
> set up.
>
Rob, Jingoo,

We have similar bit to check for Link status and I have removed the DT 
property and skip Link retrain if PCIe Link is already Up. I will be 
resending the series with Patch 4/5 updated.

Thanks.

Murali

> Best regards,
> Jingoo Han
>

