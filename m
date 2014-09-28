Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaI1VQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 17:16:35 -0400
Received: from mail-by2on0138.outbound.protection.outlook.com ([207.46.100.138]:23742
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753956AbaI1VQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 17:16:31 -0400
X-WSS-ID: 0NCMR39-08-PC3-02
X-M-MSG: 
Message-ID: <54287AA5.3060408@amd.com>
Date: Sun, 28 Sep 2014 16:16:21 -0500
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Liviu Dudau <liviu@dudau.co.uk>
CC: Liviu Dudau <Liviu.Dudau@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "Rob Herring" <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Will Deacon" <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Device Tree ML" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v12 10/12] PCI: Assign unassigned bus resources in pci_scan_root_bus()
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
 <1411498874-9864-11-git-send-email-Liviu.Dudau@arm.com>
 <20140924011851.GD32643@bart.dudau.co.uk>
 <CAErSpo5DR+TPYXBWGKRj9SRPjsbJ6kjZmAH1AXT12txEjGdZGQ@mail.gmail.com>
In-Reply-To: <CAErSpo5DR+TPYXBWGKRj9SRPjsbJ6kjZmAH1AXT12txEjGdZGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(164054003)(24454002)(377454003)(479174003)(199003)(189002)(23676002)(83322001)(83072002)(81542003)(19580405001)(83506001)(92726001)(74502003)(80022003)(81342003)(92566001)(74662003)(46102003)(44976005)(85852003)(80316001)(33656002)(97736003)(36756003)(84676001)(20776003)(95666004)(50466002)(87936001)(47776003)(68736004)(102836001)(15975445006)(90102001)(64706001)(65806001)(65956001)(21056001)(4396001)(107046002)(31966008)(105586002)(93886004)(85306004)(106466001)(65816999)(87266999)(50986999)(76176999)(120916001)(54356999)(79102003)(76482002)(19580395003)(77982003)(86362001)(101416001)(10300001)(99396003)(64126003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB199;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-Forefront-PRVS: 03484C0ABF
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 08:41 PM, Bjorn Helgaas wrote:
> On Tue, Sep 23, 2014 at 7:18 PM, Liviu Dudau <liviu@dudau.co.uk> wrote:
>> On Tue, Sep 23, 2014 at 08:01:12PM +0100, Liviu Dudau wrote:
>>> If the firmware has not assigned all the bus resources and
>>> we are not just probing the PCIe busses, it makes sense to
>>> assign the unassigned resources in pci_scan_root_bus().
>>>
>>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>>> Cc: Rob Herring <robh+dt@kernel.org>
>>> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>>> ---
>>>   drivers/pci/probe.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>>> index ef891d2..508cf61 100644
>>> --- a/drivers/pci/probe.c
>>> +++ b/drivers/pci/probe.c
>>> @@ -1953,6 +1953,9 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, int bus,
>>>        if (!found)
>>>                pci_bus_update_busn_res_end(b, max);
>>>
>>> +     if (!pci_has_flag(PCI_PROBE_ONLY))
>>> +             pci_assign_unassigned_bus_resources(b);
>>> +
>>>        pci_bus_add_devices(b);
>>>        return b;
>>>   }
>>> --
>>> 2.1.0
>>>
>>
>> Bjorn,
>>
>> If you are OK with this patch, can you let me know how do you feel about
>> making pci_scan_root_bus() set up the bus->msi pointer as well?
>
> I'm not opposed to it, but I have the same question as for setting up
> the domain: how does pci_scan_root_bus() learn what to assign to
> bus->msi?  It currently only gets a "void *sysdata" so there's no
> obvious place to put it there.  You could add a pcibios interface to
> retrieve it, I suppose, but I'm starting to get uncomfortable with
> adding more of those because we have such a mess of them already.
>
> Bjorn

[Suravee] Liviu and I had a talk during Linaro Connect, and we came up
with a new binding for the pcie controller called "msi-parent" which is
supposed to contain phandle to the corresponded msi-controller.

>
>> Side note: I don't know exactly how to do it now, but setting bus->msi is
>> needed by platforms that are based on my patches and want to use MSI,
>> otherwise they have to open code pci_scan_root_bus() to set it. I haven't
>> made any attempts to do it in this series as the GICv2m patches are not
>> ready yet, but I can see the need arriving soon.

[Suravee] I just sent out an RFC which implements the described binding 
here.

https://lkml.org/lkml/2014/9/28/149

Any feedback/comments are welcome :)

Thanks,

Suravee
