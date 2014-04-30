Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaD3Hup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 03:50:45 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:30424
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751451AbaD3Hun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 03:50:43 -0400
X-WSS-ID: 0N4U341-08-RNX-02
X-M-MSG: 
Message-ID: <5360AB3D.3020401@amd.com>
Date: Wed, 30 Apr 2014 02:50:21 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>, Myron Stowe <myron.stowe@gmail.com>
CC: Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        "Andreas Herrmann" <herrmann.der.user@googlemail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        "Aravind Gopalakrishnan" <aravind.gopalakrishnan@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>, <kim.naru@amd.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Jan Beulich" <JBeulich@suse.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2 2/5] x86/PCI: Support additional MMIO range capabilities
References: <20140420075936.GA19672@pd.tnic>
 <CAL-B5D1rJmf9vLSnV2izsXcbCu1idXsTsnSwoFRKFNTM7BnyfA@mail.gmail.com>
 <20140426091031.GA10166@pd.tnic>
 <CAErSpo4Jqo_opj=QqjcquS_6HqckZfP5-oQHkmY5FSAyyLNYMg@mail.gmail.com>
 <20140428214036.GA32143@pd.tnic> <20140429073309.GE10997@alberich>
 <20140429102013.GA4726@pd.tnic> <535FC269.2000808@amd.com>
 <20140429191454.GB4726@pd.tnic>
 <CAL-B5D2Z7AvJZ3G2JLY6ZOZBRe4DGgO27RVJ_HHotGrnKL7Y1A@mail.gmail.com>
 <20140430070042.GN32718@rric.localhost>
In-Reply-To: <20140430070042.GN32718@rric.localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(24454002)(479174003)(51704005)(189002)(199002)(80316001)(65956001)(76482001)(92726001)(19580405001)(47776003)(50466002)(84676001)(36756003)(85852003)(44976005)(81342001)(83072002)(20776003)(80976001)(50986999)(83322001)(64126003)(80022001)(92566001)(65816999)(99396002)(65806001)(19580395003)(74502001)(81542001)(74662001)(31966008)(76176999)(77096999)(87266999)(2009001)(83506001)(97736001)(77982001)(54356999)(87936001)(101416001)(86362001)(79102001)(33656001)(46102001)(23756003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB113;H:atltwp02.amd.com;FPR:AC97F025.AFEA1A91.38EF10B7.4D7EE971.203BA;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0197AFBD92
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/30/2014 02:00 AM, Robert Richter wrote:
> On 29.04.14 15:40:28, Myron Stowe wrote:
>> On Tue, Apr 29, 2014 at 1:14 PM, Borislav Petkov <bp@alien8.de> wrote:
>>> So sounds to me like we want to get rid of the whole IO ECS deal
>>> altogether then.
>>>
>>> Now, I'm wondering whether we should kill it completely since I don't
>>> think anyone cares about numa node info being correct on K8, or? I'm
>>> specifically turning to our numascale friends who love to have a lot of
>>> nodes. :-)
>
> Maybe I did get you wrong, but IO ECS was introduced with fam10h and
> is not related to k8.
>
>> I think we need to be careful here as there are two unrelated topics
>> being discussed together.  What started this whole thread was the need
>> for sysfs related numa_node information with respect to PCI devices
>> (1).  Without patch 1, platforms with newer AMD CPUs end up having
>> '-1' numa_node values for all PCI devices.
>>
>> IO ECS has no bearing on patch 1, it only comes into play with patch 2
>> which is concerned with MMIO resource information when MCFG doesn't
>> exist.  For the particular issue I'm trying to get resolved, patch 2
>> is not needed.  However, since we have expended time and effort on
>> this subject, perhaps we should get this cleaned up while it has our
>> attention.
>>
>> I'm all for deleting as much of amd_bus.c as possible due to its
>> "perennial maintenance headache".  The obvious choices seem to be all,
>> or some combination, of:
>>    o removing IO ECS logic,
>>    o removing IO/MMIO logic (assuming MCFG issues were long enough ago
>> to no longer be a concern),
>>    o start deprecating amd_bus.c by adding logic to skip if BIOS >= 2015
>
> I don't see any reason for big changes actually. Just bind the IO ECS
> logic to fam10h (either with fam check or pci device depending on the
> implementation, xen's flavor would be pci). This is something stricter
> than 'if BIOS >= 2015'. It leaves code as it is which is maintainable.
>
> You implement the new logic for for newer families. No need for one
> implementation that fits all.
>
> -Robert
>
Actually, if ECS is needed by IBS, then wouldn't this still be needed 
for every family since 10h and later (except family11h).

Suravee
