Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaILKO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:14:26 -0400
Received: from mail-by2on0142.outbound.protection.outlook.com ([207.46.100.142]:35968
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751091AbaILKOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:14:23 -0400
X-Greylist: delayed 4474 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2014 06:14:22 EDT
X-WSS-ID: 0NBS9RK-08-EH3-02
X-M-MSG: 
Message-ID: <5412C75F.30207@amd.com>
Date: Fri, 12 Sep 2014 05:13:51 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Will Deacon" <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Device Tree ML" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 09/10] PCI: Assign unassigned bus resources in pci_scan_root_bus()
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
 <1410184472-17630-10-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1410184472-17630-10-git-send-email-Liviu.Dudau@arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(24454002)(51704005)(377454003)(479174003)(164054003)(199003)(19580395003)(83322001)(19580405001)(106466001)(31966008)(85306004)(50986999)(44976005)(107046002)(68736004)(21056001)(76482001)(99396002)(90102001)(97736003)(54356999)(65816999)(76176999)(74502001)(74662001)(84676001)(95666004)(101416001)(83506001)(105586002)(33656002)(36756003)(23746002)(102836001)(64706001)(47776003)(77982001)(85852003)(83072002)(65806001)(79102001)(80022001)(65956001)(87936001)(4396001)(20776003)(81542001)(92566001)(92726001)(81342001)(86362001)(46102001)(50466002)(64126003)(921003)(1121002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR02MB276;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 0332AACBC3
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/8/2014 8:54 AM, Liviu Dudau wrote:
> If the firmware has not assigned all the bus resources and
> we are not just probing the PCIe busses, it makes sense to
> assign the unassigned resources in pci_scan_root_bus().
>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> ---
>   drivers/pci/probe.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index ef891d2..508cf61 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1953,6 +1953,9 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, int bus,
>   	if (!found)
>   		pci_bus_update_busn_res_end(b, max);
>
> +	if (!pci_has_flag(PCI_PROBE_ONLY))
> +		pci_assign_unassigned_bus_resources(b);
> +
>   	pci_bus_add_devices(b);
>   	return b;
>   }
>

Liviu,

Besides the check for PCI_PROBE_ONLY here, I think we also need to avoid calling
"pci_enable_resources()" in the "driver/pci/pci.c: pcibios_enable_device()" for
PCI_PROBE_ONLY mode since the resource is not assigned by Linux. Otherwise, the
"drivers/pci/setup-res.c: pci_enable_resource()" would fail w/ error:

     can't enable device: BAR ..... not assigned

Actually, in "arch/arm/kernel/bios32.c:", the weak "pcibios_enable_device()" function
also has the check for PCI_PROBE_ONLY mode before calling pci_enable_resources().

Thanks,

Suravee

