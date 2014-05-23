Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaEWVgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:36:22 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:54723
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751253AbaEWVgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:36:20 -0400
X-WSS-ID: 0N61QOC-08-3MN-02
X-M-MSG: 
Message-ID: <537FBF4F.4050406@amd.com>
Date: Fri, 23 May 2014 16:36:15 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: Borislav Petkov <bp@alien8.de>, Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aravind Gopalakrishnan" <Aravind.Gopalakrishnan@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH V5 3/4] x86/PCI: Stop enabling ECS for AMD CPUs after
 Fam16h
References: <20140521231615.26447.38060.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521231817.26447.55150.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521233802.GA21575@pd.tnic>
 <CAErSpo4hcitey+jtZkgpbZsEswJJekStXONct9rrh0aQ_R0h8g@mail.gmail.com>
 <20140522191746.GL4383@pd.tnic>
 <CAErSpo7=0-xdnu4DQufu_6eS=6AYhnDRaQvzeiMEC5a=zKU0Jg@mail.gmail.com>
 <537E8ACF.6000103@amd.com>
 <CAErSpo6AMGPFELx+2qJXYaxaLRhk2F2J=wn4=gLgmvYGdLup7A@mail.gmail.com>
 <20140523115622.GU27560@rric.localhost>
In-Reply-To: <20140523115622.GU27560@rric.localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(52314003)(51704005)(377454003)(24454002)(479174003)(199002)(189002)(31966008)(44976005)(99396002)(81342001)(87266999)(50466002)(81542001)(36756003)(65816999)(76176999)(80316001)(54356999)(23756003)(76482001)(33656002)(97736001)(74662001)(74502001)(65806001)(85852003)(84676001)(80022001)(92726001)(64126003)(4396001)(92566001)(65956001)(64706001)(87936001)(83322001)(20776003)(102836001)(68736004)(50986999)(46102001)(86362001)(77982001)(101416001)(83072002)(77096999)(59896001)(79102001)(47776003)(21056001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB474;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0220D4B98D
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/2014 6:56 AM, Robert Richter wrote:
> On 22.05.14 20:54:54, Bjorn Helgaas wrote:
>> I'm going to go out on a limb and guess that Windows does not enable
>> ECS, so it probably uses ECAM.  Therefore, I suspect Linux's parsing
>> of MCFG is broken in some way, and we probably *could* use ECAM in all
>> these cases I'm seeing.
>
> Even if ECS is not enabled the system should be fine anyway, as ECS is
> only used to enable certain features. For family 10h this was
> originally the IBS EILVT (extended interrupt local vector table,
> needed for hw profiling) setup which need to be set by the OS which
> the BIOS didn't right. This should be fixed now and properly set by
> the BIOS on 15h+ systems.
>
> I don't remember what was added to 16h where ECS was needed, I think
> there was one (Suravee?). Not sure if this is essential.

I am not aware of anything specific in the family16h which require 
IO_ECS to be enabled.

Suravee

