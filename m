Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964933AbaH0Tdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:33:50 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:50676
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750804AbaH0Tds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:33:48 -0400
Message-ID: <53FE328F.5040204@caviumnetworks.com>
Date: Wed, 27 Aug 2014 12:33:35 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Jonas Gorski <jogo@openwrt.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Olof Johansson <olof@lixom.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kumar Gala <galak@codeaurora.org>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, Rob Herring <robh+dt@kernel.org>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        Qais Yousef <qais.yousef@imgtec.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, John Crispin <blogic@openwrt.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jayachandran C <jchandra@broadcom.com>,
        Paul Burton <paul.burton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 0/7] MIPS: Move device-tree files to a common location
References: <1408651466-8334-1-git-send-email-abrestic@chromium.org> <CAGVrzcZobuL4z0WNX+Sz4p_uwaPL-S5yvEmgRUwZPJi4+qq0tg@mail.gmail.com> <CAL1qeaGb-o0P7x4nZPJ+dGfoSKz+2ANrB0gGrBi19TtPxVTAZQ@mail.gmail.com> <20140823063113.GC23715@localhost> <CAMuHMdXudu0kuOkKN8JCrWZSrQ4awKHhHU0E2ss++ProP0rteQ@mail.gmail.com> <CAOiHx=mZPt=p_jw4fyEqgniJvqunQ86ro_Run5ZtD1zLYWzmqA@mail.gmail.com> <CAL1qeaFTw=0XMEkag1Z8C4jKkWnwBeGJLYxHGiYfKXBk-9o0Yw@mail.gmail.com>
In-Reply-To: <CAL1qeaFTw=0XMEkag1Z8C4jKkWnwBeGJLYxHGiYfKXBk-9o0Yw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-ClientProxiedBy: BLUPR07CA081.namprd07.prod.outlook.com (25.160.24.36) To
 DM2PR07MB589.namprd07.prod.outlook.com (10.141.176.139)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0316567485
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(24454002)(199003)(479174003)(189002)(377454003)(105586002)(90102001)(93886004)(85306004)(64126003)(106356001)(83072002)(81156004)(85852003)(92726001)(92566001)(74662001)(76482001)(74502001)(87976001)(95666004)(31966008)(110136001)(23676002)(83506001)(107046002)(50466002)(76176999)(59896002)(50986999)(101416001)(81342001)(19580405001)(47776003)(20776003)(19580395003)(79102001)(64706001)(83322001)(69596002)(36756003)(87266999)(54356999)(65816999)(80316001)(33656002)(66066001)(65806001)(77096002)(53416004)(4396001)(21056001)(81542001)(99396002)(80022001)(65956001)(42186005)(46102001)(102836001)(77982001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR07MB589;H:dl.caveonetworks.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 11:30 AM, Andrew Bresticker wrote:
> On Mon, Aug 25, 2014 at 8:17 AM, Jonas Gorski <jogo@openwrt.org> wrote:
>> On Sat, Aug 23, 2014 at 9:50 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> On Sat, Aug 23, 2014 at 8:31 AM, Olof Johansson <olof@lixom.net> wrote:
>>>>>> arch/arm/boot/dts/<vendor>/
>>>>>>
>>>>>> Is this something we should do for the MIPS and update the other architectures
>>>>>> to follow that scheme?
>>>>>
>>>>> I recall reading that as well and that it would be adopted for ARM64,
>>>>> but that hasn't seemed to have happened.  Perhaps Olof (CC'ed) will no
>>>>> more.
>>>>
>>>> Yeah, I highly recommend having a directory per vendor. We didn't on ARM,
>>>> and the amount of files in that directory is becoming pretty
>>>> insane. Moving to a subdirectory structure later gets messy which is
>>>> why we've been holding off on it.
>>>
>>> It would mean we can change our scripts to operate on "interesting"
>>> DTS files from
>>>
>>>       do-something-with $(git grep -l $vendor, -- arch/arm/boot/dts)
>>>
>>> to
>>>
>>>      do-something-with arch/arm/boot/dts/$vendor/*
>>>
>>> which is easier to type...
>>
>> Btw, do you mean chip-vendor or device-vendor with vendor?
>> Device-vendor could get a bit messy on the source part as the router
>> manufacturers tend to switch them quite often. E.g. d-link used arm,
>> mips and ubi32 chips from marvell, ubicom, broadcom, atheros, realtek
>> and ralink for their dir-615 router, happily switching back and forth.
>> There are 14 known different hardware revisions of it where the chip
>> differed from the previous one.
>
> I'm going to assume it means chip/SoC vendor.  That would result in
> the following structure (I think):
>
> Octeon -> cavium/

To match the state of the art naming we have in other MIPS related 
directories, it should probably be "cavium-octeon/" (See 
arch/mips/cavium-octeon, and arch/mips/include/asm/mach-cavium-octeon)

David Daney
