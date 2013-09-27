Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3I0PXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:23:34 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:16808
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753417Ab3I0PXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:23:32 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Thread-Topic: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer
 frequency from the hypervisor
Thread-Index: AQHOqM30I+mkPB2b1kKq/5YqjRysqJnZ1ccAgAADeVA=
Date: Fri, 27 Sep 2013 15:23:17 +0000
Message-ID: <418dd0e9b1054189b61770edb57c5b37@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <20130927151026.GA29416@aepfle.de>
In-Reply-To: <20130927151026.GA29416@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.238.85.242]
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(377454003)(13464003)(51704005)(189002)(199002)(24454002)(19580395003)(76482001)(4396001)(53806001)(33646001)(51856001)(74876001)(47976001)(83322001)(46102001)(47736001)(50986001)(19580405001)(80976001)(49866001)(74662001)(81686001)(76576001)(47446002)(74502001)(31966008)(54316002)(66066001)(76786001)(76796001)(74316001)(74366001)(56816003)(59766001)(83072001)(65816001)(80022001)(77982001)(63696002)(81342001)(69226001)(81542001)(74706001)(77096001)(54356001)(56776001)(81816001)(79102001)(24736002)(15583001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:212.238.85.242;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8RFNb9b024385



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Friday, September 27, 2013 8:10 AM
> To: KY Srinivasan
> Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com;
> tglx@linutronix.de; hpa@zytor.com; JBeulich@suse.com; bp@alien8.de
> Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
> from the hypervisor
> 
> On Tue, Sep 03, K. Y. Srinivasan wrote:
> 
> > Hyper-V supports a mechanism for retrieving the local APIC frequency.Use this
> and bypass
> > the calibration code in the kernel. This would allow us to boot the Linux kernel
> as a
> > "modern VM" on Hyper-V where many of the legacy devices (such as PIT) are
> not emulated.
> 
> > +	if (ms_hyperv.features & HV_X64_MSR_APIC_FREQUENCY_AVAILABLE) {
> > +		/*
> > +		 * Get the APIC frequency.
> > +		 */
> > +		rdmsrl(HV_X64_MSR_APIC_FREQUENCY, hv_lapic_frequency);
> > +		hv_lapic_frequency /= HZ;
> 
> This leads to build errors on 32bit:
> 
> linux-3.12-rc2/arch/x86/kernel/cpu/mshyperv.c:88: undefined reference to
> `__udivdi3'
> 
> Up to now I have only tested on 64bit, sorry for that.

Thanks Olaf. I am travelling currently; I will fix it when I get back (early next week).

K. Y
> 
> 
> Olaf
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
