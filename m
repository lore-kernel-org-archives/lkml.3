Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaEWTX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 15:23:28 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:58363 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaEWTX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 15:23:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 3/5] phy: pci serdes phy driver for keystone
Date: Fri, 23 May 2014 21:23:11 +0200
Message-ID: <9828919.7tZBgbvqj4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <537F81D8.2080005@ti.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <9550746.D1ri3H0uvi@wuerfel> <537F81D8.2080005@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ER9a00NpRYUXWIsMAIdhhY839yEE3XwgfWtr8XBzut2
 /HZgChi1bupPQEp5WtY04EHJa+LqW2UnYbwooGRu0RN+8I8dlV
 doeoCGlCBBgHoxeW5GWw8YUJOee2dw1ehLFFbR/6tVo1Gdq6vQ
 yAGivxMZ9LRKobYflq0tqf/M4rugG0QIX+gE03X0lRqJL9PHWw
 zLxOTf0Fty9XK42BuoKXT85ZO0+gOBQf/Pqm6ewAKCftE2+6f4
 eoiZAhlQ4+Y6CUlzr3npXPJF+V+aww5aeIdqMfZEKIv+xewiOI
 CEX9uh4Mb9WLCsb9nuIJ6D1ADckCOu216Qn+fDAPN/Wt4bJre5
 zkxb6pUX+joxsNbD7SOg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2014 13:14:00 Murali Karicheri wrote:
> On 5/15/2014 12:14 PM, Arnd Bergmann wrote:
> > On Thursday 15 May 2014 12:01:30 Murali Karicheri wrote:
> >> +static struct serdes_config ks_100mhz_pcie_5gbps_serdes[] = {
> >> +       {0x0000, 0x00000800, 0x0000ff00},
> >> +       {0x0060, 0x00041c5c, 0x00ffffff},
> >> +       {0x0064, 0x0343c700, 0xffffff00},
> >> +       {0x006c, 0x00000012, 0x000000ff},
> >> +       {0x0068, 0x00070000, 0x00ff0000},
> >> +       {0x0078, 0x0000c000, 0x0000ff00},
> > It looks like the PHY is generic, but the configuration above is
> > PCI specific. If this is true, you should have #phy-cells=<1>
> > and document the possible modes, adding a lookup table here to
> > pick the configuration based on the argument. It's fine to just
> > implement pcie-5ghz initially, but the binding should list all
> > the modes that the PHY can support.
> 
> The PCIE name needs to be dropped and as you correctly guessed, this SERDES
> is generic.

Ok, good.

> > Also, please list the exact name of the phy if you can find it
> > out. You mention that you don't know the register descriptions,
> > but you should at least be able to let us know what phy this
> > is, in case some other SoC reuses the same thing.
>
> Unfortunately there is a NDA restriction that prevents us from using the
> actual Phy name and keystone phy is the name what we can usel at the 
> moment. I am checking
> this with our IP team and if original name can  be used, I will update 
> the driver to reflect the same.

Can you please check the phy drivers that we already have in linux-next
to see if any of those are for the same hardware then?

I guess it's our best hope to catch duplications by inspecting all
other phy drivers as they get merged then.

	Arnd
