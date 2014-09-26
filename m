Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbaIZQal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 12:30:41 -0400
Received: from mail-bn1bon0117.outbound.protection.outlook.com ([157.56.111.117]:48672
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755196AbaIZQaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:30:39 -0400
X-WSS-ID: 0NCIOIV-07-92T-02
X-M-MSG: 
Message-ID: <542594A6.4040504@amd.com>
Date: Fri, 26 Sep 2014 11:30:30 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Jiang Liu <jiang.liu@linux.intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFT Part2 v2 00/24] Enable hierarchy irqdomian on x86 platforms
References: <1411740145-30626-1-git-send-email-jiang.liu@linux.intel.com>
 <20140926142931.GA10066@nazgul.tnic>
In-Reply-To: <20140926142931.GA10066@nazgul.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(479174003)(189002)(24454002)(377454003)(199003)(51704005)(10300001)(83506001)(107046002)(31966008)(74662003)(33656002)(79102003)(81542003)(120916001)(65956001)(106466001)(99136001)(74502003)(15975445006)(120886001)(59896002)(83072002)(47776003)(80316001)(83322001)(19580395003)(19580405001)(65806001)(81342003)(44976005)(80022003)(85306004)(85852003)(46102003)(20776003)(64706001)(77982003)(21056001)(90102001)(95666004)(84676001)(102836001)(65816999)(87936001)(99396003)(92726001)(36756003)(92566001)(4396001)(105586002)(76482002)(68736004)(64126003)(97736003)(86362001)(50986999)(101416001)(54356999)(23676002)(50466002)(87266999)(76176999);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/2014 9:29 AM, Borislav Petkov wrote:
> On Fri, Sep 26, 2014 at 10:02:01PM +0800, Jiang Liu wrote:
>> We plan to restructure x86 interrupt code based on hierarchy irqdomain,
>> that is to build irqdomains for CPU vector, interrupt remapping unit,
>> IOAPIC, MSI and HPET etc and organize those irqdomains in hierarchy mode.
>> Each irqdomain manages corresponding interrupt controller and talks to
>> parent interrupt controller through public irqdomain interfaces. We also
>> support stacked irq_chip based on hierarchy irqdomain. It will make the
>> x86 interrupt architecture much more clear and more easy to maintain
>> with hierarchy irqdomain and stacked irq_chip. It may also help ARM
>> interrupt management architecture too.
>>
>> This is the second patch set to enable support of hierarchy irqdomain
>> on x86 platforms. It depends on the first part at:
>> https://lkml.org/lkml/2014/9/26/501
>> And you may access it at:
>> https://github.com/jiangliu/linux.git irqdomain/p2v2
>>
>> And there will be a third patch set to convert IOAPIC driver to support
>> hierarchy irqdomain and clean up code.
>>
>> The first patch extends irqdomain interfaces to support hierarchy
>> irqdomain. Hope this interface could be used by other architectures too,
>> such as ARM/ARM64.
>> The second patch introduces two helper functions to support stacked
>> irq_chip.
>> Patch 3-9 implements an irqdomain to manange CPU interrupt vectors, and
>> it's the root irqdomain for x86 platforms.
>> Patch 10-13 converts Intel and AMD interrupt remapping drivers to
>> support hierarchy irqdomain.
>> Patch 14-16 converts HPET and MSI to support hierarchy irqdomain.
>> Patch 17-20 cleans up unsued code in x86 arch and interrupt remapping
>> drivers.
>> Patch 21-24 converts DMAR, HTIRQ and UV to support hierarchy irqdomain.
>>
>> We have tested this patchset on Intel 32-bit and 64-bit systems. And it
>> also passes Fengguang's 0day tests. But helps are need for testing:
>> 1) AMD interrupt remapping
>> 2) AMD HT_IRQ
> Adding Aravind.
>
> @Aravind: you might want to give that patchset a run just in case, to
> make sure it doesn't break anything on AMD. You'll need the previous
> patchset to go before too, though:
>
> https://lkml.kernel.org/r/1411738196-29958-1-git-send-email-jiang.liu@linux.intel.com

Sure, Will help testing these.

> I'm sure Jiang will help you if you have more questions.
>
>

Okay, I shall start looking into the patches and RFH as needed.

-Aravind.
