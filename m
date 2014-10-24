Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbaJXMIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:08:31 -0400
Received: from mail-bn1bon0147.outbound.protection.outlook.com ([157.56.111.147]:48890
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756415AbaJXMI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:08:27 -0400
X-WSS-ID: 0NDY71V-08-OTK-02
X-M-MSG: 
Message-ID: <544A4132.8000404@amd.com>
Date: Fri, 24 Oct 2014 07:08:18 -0500
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>
Subject: Re: [RFC 1/4] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1411937610-22125-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20141010134534.GC6004@leverpostej>
In-Reply-To: <20141010134534.GC6004@leverpostej>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(199003)(51704005)(377454003)(189002)(479174003)(164054003)(46102003)(20776003)(64706001)(80022003)(65806001)(76176999)(84676001)(87936001)(76482002)(54356999)(87266999)(50986999)(92726001)(85852003)(83506001)(68736004)(65816999)(102836001)(86362001)(44976005)(19580405001)(19580395003)(50466002)(80316001)(110136001)(15975445006)(120916001)(33656002)(99396003)(97736003)(21056001)(101416001)(92566001)(4396001)(64126003)(23746002)(85306004)(95666004)(15202345003)(106466001)(107046002)(31966008)(59896002)(36756003)(105586002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 8:45 AM, Mark Rutland wrote:
> Hi Suravee,
>
> On Sun, Sep 28, 2014 at 09:53:27PM +0100, suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> Initial revision of device tree for AMD Seattle platform
>
> To check: how is it possible to make use of a DTB generated from this
> dts? Can a user update the DTB used by the Seattle firmware?

In the current FW, there is a mechanism that users can modify and 
provide UEFI with the updated device tree to override the one that comes 
with Seattle firmware.

[...];
>> +
>> +       timer@1,1060000 {
>> +               compatible = "arm,standalone_a5_twd";
>> +               reg = <0 0x1060000 0 0x40>;
>> +               interrupts =
>> +                       <0 378 4>,
>> +                       <0 379 4>;
>> +       };
>
> This binding does not exist in mainline.

I am removing this.

>
>> +
>> +       ccp: ccp@1,00100000 {
>> +               compatible = "amd,ccp-seattle-v1a";
>> +               reg = <0 0x00100000 0 0x10000>;
>> +               interrupts = <0 3 4>;
>> +               dma-coherent;
>> +       };
>
> Nor does this.

The binding for this one is here 
(http://lxr.free-electrons.com/source/Documentation/devicetree/bindings/crypto/amd-ccp.txt).


 > [....]
>
>> +               linux,pci-probe-only;
>
> Why is this necessary?

This was defined in the PCI Generic Host Controller binding here 
(http://lxr.free-electrons.com/source/Documentation/devicetree/bindings/pci/host-generic-pci.txt).

>
>> +       };
>> +
>> +       aliases {
>> +               serial0 = &v2m_serial0;
>> +       };
>> +
>> +       /* Note: This entry is modified by UEFI */
>
> In what way is this modified?

1. UEFI would basically take out certain CPUs and modify the cpu-map 
accordingly.
2. Change method to psci-0.2 when support is in place.
3. Update release address.

Actually, the "cpus" entry should/will be fully auto generated by UEFI 
in the future BIOS. I think I'll be taking this out completely for now.

> [...]
>
>> +
>> +       /* Note: This entry is modified by UEFI */
>> +       memory@8000000000 {
>> +               device_type = "memory";
>> +               reg = <0x00000080 0x00000000 0x1 0x00000000>; /* 4GB */
>> +       };
>
> Why does UEFI modify this? When booted via UEFI we use the UEFI memory
> map.

True. But for non-EFI boot (as fallback), we still need this. UEFI will 
update the amount of detected memory.

Actually, same here as the "cpus", this entry should/will go away 
completely from the static DT, and UEFI will auto-generate this in the 
future firmware.

Thanks,

Suravee
