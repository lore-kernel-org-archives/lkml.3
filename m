Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbbABSS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:18:29 -0500
Received: from mail-bn1bon0114.outbound.protection.outlook.com ([157.56.111.114]:38816
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750777AbbABSS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:18:27 -0500
X-WSS-ID: 0NHKAUK-07-PLY-02
X-M-MSG: 
Message-ID: <54A6E0DE.6090309@amd.com>
Date: Fri, 2 Jan 2015 12:18:06 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>, Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "Catalin Marinas" <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <2148776.X8NPqiYA6S@wuerfel>
 <20141023091309.GF25302@e106497-lin.cambridge.arm.com>
 <2355100.WsW1DXh57P@wuerfel> <54A1AC5C.7000903@amd.com>
 <20150102115533.GA25573@red-moon>
In-Reply-To: <20150102115533.GA25573@red-moon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(479174004)(164054003)(52604005)(51704005)(189002)(24454002)(51914003)(377454003)(4396001)(64706001)(92566001)(65956001)(86362001)(46102003)(23746002)(107046002)(120886001)(80316001)(36756003)(99396003)(120916001)(93886004)(65806001)(47776003)(19580395003)(106466001)(97736003)(105586002)(77156002)(59896002)(64126003)(15975445007)(83506001)(68736005)(76176999)(77096005)(84676001)(33656002)(87936001)(50466002)(87266999)(21056001)(54356999)(101416001)(50986999)(20776003)(2950100001)(31966008)(110136001)(62966003)(65816999);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Forefront-PRVS: 0444EB1997
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2015 18:18:21.7608
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB207
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/2/2015 5:55 AM, Lorenzo Pieralisi wrote:
> Hi Suravee,
>
> On Mon, Dec 29, 2014 at 07:32:44PM +0000, Suravee Suthikulpanit wrote:
>> >Hi,
>> >
>> >I am not sure if this thread is still alive. I'm trying to see what I
>> >can do to help clean up/convert to make the PCI GHC also works for arm64
>> >w/ zero or minimal ifdefs.
>> >
>> >Please let me know if someone is already working on this. I noticed that
>> >Lorenzo's patches has already been in 3.19-rc1, and in Bjorn's
>> >pci/domain branch. Otherwise, I'll try to continue the work based on the
>> >sample patch from Arnd here.
> If I am not mistaken, the only bit missing to remove pci_sys_data (and so
> having a generic host controller driver that works on ARM32/64) is generic
> MSI management.

Lorenzo,

Do you mean to remove pci_sys_data from pci-host-generic.c or removing 
it completely? I assume the former case.

So, looking at the current code in the pci-host-generic.c, my 
understanding is that the:
     *gen_pci = pci_bus->sysdata->private_data
will be changed to:
     *gen_pci = pci_bus->sysdata

Then, we can simply just call pci_scan_root_bus() directly since we no 
longer need to declare hw_pci for calling pci_common_init_dev().

> I know for certain Marc is working on it, and the solution is WIP,
> I think we should prevent adding more churn to pci_sys_data, since
> I managed to remove most of the dependencies (domain, mem_offset).

Thanks for cleaning up the domain and mem_offset.

I saw Marc's irq/msi_domain patch series 
(http://git.kernel.org/cgit/linux/kernel/git/maz/arm-platforms.git/log/?h=irq/msi_domain). 


My understanding is that deals with associating the newly introduced 
msi_domain to each device, which replaces the need for pci_bus->msi and 
hw_pci->msi_ctrl when configure with CONFIG_PCI_MSI_IRQ_DOMAIN (not sure 
if this would be the plan for all arm32).  For ARM32, if not define 
CONFIG_PCI_MSI_IRQ_DOMAIN, it would still fall back to using the 
[pci_sys_data|hw_pci]->msi_ctrl.

However, I noticed that the hw_pci->msi_controller is not even used for 
the pci-host-generic. So, this should not be blocking the work to free 
pci-host-generic from pci_sys_data and hw_pci, as the MSI stuff can go 
in separately. Am I missing something?

> So to sum it up, to have a generic host controller driver for ARM32/64
> we just need to work out how to handle the MSI data, patches will be
> on the lists shortly to handle that, please review.
>
> Thanks,
> Lorenzo
>

Thanks for the update and the summary. I'll help review/test the MSI 
patch once posted.

Thanks,

Suravee

