Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbbAUPtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:49:51 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:59387 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbbAUPtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:49:40 -0500
MIME-Version: 1.0
In-Reply-To: <20141217140131.607a1ac7@lxorguk.ukuu.org.uk>
References: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org>
	<1418812486-12394-6-git-send-email-gabriel.fernandez@linaro.org>
	<20141217140131.607a1ac7@lxorguk.ukuu.org.uk>
Date: Wed, 21 Jan 2015 16:49:39 +0100
Message-ID: <CAG374jD3Y_y1Ugt0Y7_j9kz66yUCx8PPNLkkpWBdpVPMxnoC8w@mail.gmail.com>
Subject: Re: [PATCH 5/5] PCI: st: disable IO support
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Arnd Bergmann <arnd@arndb.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Minghuan Lian <Minghuan.Lian@freescale.com>,
        Magnus Damm <damm@opensource.se>, Will Deacon <will.deacon@arm.com>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Sachin Kamat <sachin.kamat@samsung.com>, Andrew Lunn <andrew@lunn.ch>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Srikanth Thokala <sthokal@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>, linux-pci@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yes, we don't really care about this corner case.
Thanks for your reviewing.

BR

Gabriel

On 17 December 2014 at 15:01, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> On Wed, 17 Dec 2014 11:34:46 +0100
> Gabriel FERNANDEZ <gabriel.fernandez@st.com> wrote:
>
>> sti SoCs PCIe IPs are built around DesignWare IP Core.
>> But in these SoCs, PCIe IP doesn't support IO.
>> By default, when no IO space is provided, a default one is assigned.
>>
>> Add an empty IO resource to the bus, and disable IO by default.
>
> As a point of PCI pedantry I don't think this is quite sufficient. PCI
> has a weird corner case where I/O resources are implied rather than
> allocated.
>
> For IDE/SATA you may need to something like
>
>         if (class == PCI_CLASS_STORAGE_IDE) {
>                 u8 progif;
>                 pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
>                 progif |= 5;
>                 pci_write_config_byte(dev, PCI_CLASS_PROG, &progif);
>         }
>
> so that any adapter is kicked out of legacy mode and doesn't get implied
> I/O resources and interrupts. I don't know if that case matters for your
> usage.
>
>
