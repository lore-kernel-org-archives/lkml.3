Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaEWROp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:14:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53988 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbaEWROo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:14:44 -0400
Message-ID: <537F81D8.2080005@ti.com>
Date: Fri, 23 May 2014 13:14:00 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mohit Kumar <mohit.kumar@st.com>, Jingoo Han <jg1.han@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v1 3/5] phy: pci serdes phy driver for keystone
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <1400169692-9677-4-git-send-email-m-karicheri2@ti.com> <9550746.D1ri3H0uvi@wuerfel>
In-Reply-To: <9550746.D1ri3H0uvi@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/2014 12:14 PM, Arnd Bergmann wrote:
> On Thursday 15 May 2014 12:01:30 Murali Karicheri wrote:
>> +static struct serdes_config ks_100mhz_pcie_5gbps_serdes[] = {
>> +       {0x0000, 0x00000800, 0x0000ff00},
>> +       {0x0060, 0x00041c5c, 0x00ffffff},
>> +       {0x0064, 0x0343c700, 0xffffff00},
>> +       {0x006c, 0x00000012, 0x000000ff},
>> +       {0x0068, 0x00070000, 0x00ff0000},
>> +       {0x0078, 0x0000c000, 0x0000ff00},
> It looks like the PHY is generic, but the configuration above is
> PCI specific. If this is true, you should have #phy-cells=<1>
> and document the possible modes, adding a lookup table here to
> pick the configuration based on the argument. It's fine to just
> implement pcie-5ghz initially, but the binding should list all
> the modes that the PHY can support.

The PCIE name needs to be dropped and as you correctly guessed, this SERDES
is generic.
>
> Also, please list the exact name of the phy if you can find it
> out. You mention that you don't know the register descriptions,
> but you should at least be able to let us know what phy this
> is, in case some other SoC reuses the same thing.
Unfortunately there is a NDA restriction that prevents us from using the
actual Phy name and keystone phy is the name what we can usel at the 
moment. I am checking
this with our IP team and if original name can  be used, I will update 
the driver to reflect the same.
>> +static int ks_phy_init(struct phy *phy)
>> +{
>> +       struct serdes_config *p;
>> +       struct phy_keystone *ks_phy = phy_get_drvdata(phy);
>> +
>> +       int i;
>> +
>> +       for (i = 0, p = &ks_100mhz_pcie_5gbps_serdes[0];
>> +               i < ARRAY_SIZE(ks_100mhz_pcie_5gbps_serdes);
>> +               i++, p++) {
>> +               reg_rmw((ks_phy->base + p->reg), p->val, p->mask);
>> +               reg_dump((ks_phy->base + p->reg), p->mask);
>> +       }
>> +       udelay(2000);
> This should probably be msleep(2);
Fine.

Murali
>
> 	Arnd

