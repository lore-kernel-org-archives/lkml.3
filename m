Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaKLLiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:38:12 -0500
Received: from [65.55.169.131] ([65.55.169.131]:41766 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752492AbaKLLiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:38:09 -0500
X-WSS-ID: 0NEXC8C-08-5K7-02
X-M-MSG: 
Message-ID: <54634627.60502@amd.com>
Date: Wed, 12 Nov 2014 18:36:07 +0700
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Srikanth Thokala <sriku.linux@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <liviu.dudau@arm.com>,
        <lorenzo.pieralisi@arm.com>, <will.deacon@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 2/2] PCI: generic: Add msi_parent DT binding
References: <1415733454-24322-1-git-send-email-suravee.suthikulpanit@amd.com>
	<1415733454-24322-3-git-send-email-suravee.suthikulpanit@amd.com>
 <CA+mB=1LEEtPCixB9Ej74L03yPPH7D6YvfpkZyJgsHCm97-GvKg@mail.gmail.com>
In-Reply-To: <CA+mB=1LEEtPCixB9Ej74L03yPPH7D6YvfpkZyJgsHCm97-GvKg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(51704005)(199003)(189002)(479174003)(46102003)(47776003)(86362001)(92726001)(92566001)(4396001)(65956001)(64706001)(20776003)(102836001)(77156002)(23676002)(101416001)(68736004)(77096003)(62966003)(99396003)(120916001)(110136001)(65816999)(50986999)(44976005)(76176999)(83506001)(54356999)(31966008)(84676001)(21056001)(36756003)(50466002)(97736003)(65806001)(105586002)(64126003)(117636001)(95666004)(87936001)(106466001)(107046002)(41533002)(62816006);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Forefront-PRVS: 03932714EB
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/14 13:56, Srikanth Thokala wrote:
>> @@ -122,9 +123,19 @@ static int gen_pci_config_write(struct pci_bus *bus, unsigned int devfn,
>> >         return PCIBIOS_SUCCESSFUL;
>> >  }
>> >
>> >+static int gen_pci_set_msi_parent(struct pci_bus *bus)
>> >+{
>> >+       struct gen_pci *pci = bus_to_gen_pci(bus);
>> >+
>> >+       bus->msi = pci->mchip;
>> >+
>> >+       return PCIBIOS_SUCCESSFUL;
>> >+}
>> >+
>> >  static struct pci_ops gen_pci_ops = {
>> >         .read   = gen_pci_config_read,
>> >         .write  = gen_pci_config_write,
>> >+       .set_msi_parent = gen_pci_set_msi_parent,
> We assign the msi chip through add_bus() call, do we still need this?

Certain architecture (i.e arm64) doesn't implement struct hw_pci. 
Therefore, there is no add_bus().  However, this new API should allow 
non-arch dependent implementation.

Suravee
