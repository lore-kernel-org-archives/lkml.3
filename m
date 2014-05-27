Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaE0Qrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:47:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36965 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbaE0Qrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:47:36 -0400
Message-ID: <5384C17E.5060806@ti.com>
Date: Tue, 27 May 2014 12:46:54 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 3/5] phy: pci serdes phy driver for keystone
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <9550746.D1ri3H0uvi@wuerfel> <537F81D8.2080005@ti.com> <9828919.7tZBgbvqj4@wuerfel>
In-Reply-To: <9828919.7tZBgbvqj4@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/2014 3:23 PM, Arnd Bergmann wrote:
> On Friday 23 May 2014 13:14:00 Murali Karicheri wrote:
>> On 5/15/2014 12:14 PM, Arnd Bergmann wrote:
>>> On Thursday 15 May 2014 12:01:30 Murali Karicheri wrote:
>>>> +static struct serdes_config ks_100mhz_pcie_5gbps_serdes[] = {
>>>> +       {0x0000, 0x00000800, 0x0000ff00},
>>>> +       {0x0060, 0x00041c5c, 0x00ffffff},
>>>> +       {0x0064, 0x0343c700, 0xffffff00},
>>>> +       {0x006c, 0x00000012, 0x000000ff},
>>>> +       {0x0068, 0x00070000, 0x00ff0000},
>>>> +       {0x0078, 0x0000c000, 0x0000ff00},
>>> It looks like the PHY is generic, but the configuration above is
>>> PCI specific. If this is true, you should have #phy-cells=<1>
>>> and document the possible modes, adding a lookup table here to
>>> pick the configuration based on the argument. It's fine to just
>>> implement pcie-5ghz initially, but the binding should list all
>>> the modes that the PHY can support.
>> The PCIE name needs to be dropped and as you correctly guessed, this SERDES
>> is generic.
> Ok, good.
>
>>> Also, please list the exact name of the phy if you can find it
>>> out. You mention that you don't know the register descriptions,
>>> but you should at least be able to let us know what phy this
>>> is, in case some other SoC reuses the same thing.
>> Unfortunately there is a NDA restriction that prevents us from using the
>> actual Phy name and keystone phy is the name what we can usel at the
>> moment. I am checking
>> this with our IP team and if original name can  be used, I will update
>> the driver to reflect the same.
> Can you please check the phy drivers that we already have in linux-next
> to see if any of those are for the same hardware then?
>
> I guess it's our best hope to catch duplications by inspecting all
> other phy drivers as they get merged then.
>
> 	Arnd
Arnd,

I have checked the register set of the following drivers under 
drivers/phy from the
master branch (v3.15-rc6) using the registers set available with us 
internally and
I can't find a match.

phy-exynos5250-sata.c  phy-exynos-mipi-video.c  phy-omap-usb2.c 
phy-sun4i-usb.c
phy-xgene.c phy-exynos4210-usb2.c  phy-exynos5250-usb2.c phy-mvebu-sata.c
phy-samsung-usb2.c  phy-ti-pipe3.c phy-bcm-kona-usb2.c phy-exynos4x12-usb2.c
  phy-exynos-dp-video.c  phy-omap-control.c  phy-twl4030-usb.c

So there is no duplication.

Murali

