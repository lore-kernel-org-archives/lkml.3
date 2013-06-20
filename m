Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab3FTJ76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:59:58 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:57171 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512Ab3FTJ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:59:55 -0400
Message-ID: <51C2D260.6000303@st.com>
Date: Thu, 20 Jun 2013 15:28:56 +0530
From: Pratyush Anand <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        Mohit KUMAR <Mohit.KUMAR@st.com>
Subject: Re: [PATCH V4 1/3] pci: Add PCIe driver for Samsung Exynos
References: <003601ce6756$444e8cd0$cceba670$@samsung.com> <2061566.hRLrhtBK6z@wuerfel> <000901ce6838$8b514720$a1f3d560$@samsung.com> <28355406.ThqqvnG0Yj@wuerfel>
In-Reply-To: <28355406.ThqqvnG0Yj@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/2013 7:48 PM, Arnd Bergmann wrote:
> On Thursday 13 June 2013 22:18:50 Jingoo Han wrote:
>> >On Wednesday, June 12, 2013 8:23 PM, Arnd Bergmann wrote:
>>> > >On Wednesday 12 June 2013 19:19:05 Jingoo Han wrote:
>>>> > > >+
>>>> > > >+/* synopsis specific PCIE configuration registers*/
>>>> > > >+#define PCIE_PORT_LINK_CONTROL		0x710
>>>> > > >+#define PORT_LINK_MODE_MASK		(0x3f << 16)
>>>> > > >+#define PORT_LINK_MODE_4_LANES		(0x7 << 16)
>>> > >
>>> > >Do you mean this is a "Synopsys" designware part? In that case it
>>> > >should really not be called "exynos-pcie" but "designware-pcie"
>>> > >and you should make sure that the driver makes no assumptions about
>>> > >the platform. A lot of other platforms also use designware
>>> > >parts and should be able to reuse this driver.
>> >
>> >Sorry, I don't think so.
>> >Only core block is a "Synopsys" designware part IP block,
>> >other parts are Exynos-specific.
>> >So, it is hard to share with other PCIe IPs using synopsis core.
> Just call it synopsys anyway and put a comment in to explain this.
> That should be enough for the next person with a synopsys PCI core
> to reuse your code and split out the exynos specific parts into a
> separate file.
>

I agree to Arnd that this patch should be split. I had worked in past 
with SPEAr PCIe which also had designware PCIe IP. I see some code which 
will fit both in SPEAr as well as in exynos. Unfortunately, I was not 
able to get SPEAr driver pushed to mainline, as I moved to some other 
project and got heavily occupied.

Last patch is here:

https://patchwork.kernel.org/patch/1661441/

Infact, these functions should be common to all arm platforms.

sys_to_pcie
cfg_read
cfg_write

Following functions should be common to all designware based driver (at 
least they are same in SPEAr)

exynos_pcie_prog_viewport_cfg0
exynos_pcie_prog_viewport_cfg1
exynos_pcie_rd_other_conf
exynos_pcie_wr_other_conf
exynos_pcie_setup
exynos_pcie_valid_config
exynos_pcie_rd_conf
exynos_pcie_wd_conf
exynos_pcie_scan_bus
exynos_pcie_map_irq
add_pcie_port (after a bit of generalization)
exynos_pcie_probe
exynos_pcie_remove



Following should be specific to exynos:

exynos_pcie_rd_own_conf
exynos_pcie_wr_own_conf
exynos_pcie_link_up
exynos_pcie_setup_rc
exynos_pcie_assert_core_reset
exynos_pcie_deassert_core_reset
exynos_pcie_assert_phy_reset
exynos_pcie_deassert_phy_reset
exynos_pcie_init_phy
exynos_pcie_assert_reset
exynos_pcie_establish_link
exynos_pcie_host_init



struct pcie_port_info and struct pcie_port can also be standardized.

Regards
Pratyush
