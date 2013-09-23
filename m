Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab3IWNDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:03:13 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:58844
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753486Ab3IWNDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:03:12 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Gleb Natapov <gleb@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Thread-Topic: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer
 frequency from the hypervisor
Thread-Index: AQHOqM30I+mkPB2b1kKq/5YqjRysqJnC17CggAAG+ACAABQ5UIAAikAAgABK5hCABkKSgIAAYOzQgACm54CACFRvYA==
Date: Mon, 23 Sep 2013 13:02:42 +0000
Message-ID: <2d39849c011b4cc794686a41e45db87a@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <dd29077371564a14b2d317d2291db8a9@SN2PR03MB061.namprd03.prod.outlook.com>
 <52325C1E.90101@zytor.com>
 <50f92d9c16a54e5bb6fa14ef72e5fdfb@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130913095526.GE18381@redhat.com>
 <7737cb643a664b6fb39021b4d364b5cf@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130917135918.GY17294@redhat.com>
 <2b4a9a0cff5143c59a0802a2e425c4db@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130918054335.GE5657@redhat.com>
In-Reply-To: <20130918054335.GE5657@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [109.174.139.136]
x-forefront-prvs: 09781D4C35
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(377454003)(51704005)(13464003)(189002)(199002)(33646001)(77982001)(76576001)(65816001)(74366001)(56816003)(51856001)(81686001)(76796001)(74316001)(54356001)(76786001)(47736001)(74876001)(66066001)(81342001)(69226001)(81542001)(74706001)(4396001)(76482001)(15975445006)(63696002)(31966008)(47976001)(54316002)(49866001)(47446002)(74502001)(74662001)(19580405001)(77096001)(19580395003)(46102001)(80022001)(83072001)(80976001)(56776001)(53806001)(59766001)(15202345003)(79102001)(81816001)(83322001)(50986001)(15583001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:109.174.139.136;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Gleb Natapov [mailto:gleb@redhat.com]
> Sent: Tuesday, September 17, 2013 10:44 PM
> To: KY Srinivasan
> Cc: H. Peter Anvin; x86@kernel.org; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; tglx@linutronix.de;
> JBeulich@suse.com; bp@alien8.de
> Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
> from the hypervisor
> 
> On Tue, Sep 17, 2013 at 07:53:36PM +0000, KY Srinivasan wrote:
> > > > Thanks Gleb. Here is the link for the latest Hyper-V specification:
> > > > http://www.microsoft.com/en-us/download/details.aspx?id=39289
> > > >
> > > > This spec talks about how migration is handled with regards to TSC.
> > > >
> > > All I can see is "15.4.3 Partition Reference TSC Mechanism". I see
> > > nothing about HV_X64_MSR_TSC_FREQUENCY specifically. To access this MSR
> > > a partition needs AccessFrequencyMsrs privilege, may be partition that
> > > cab be migrated does not have this privilege?
> >
> > If you use the MSR to read the TSC frequency, then indeed when you migrate
> then there
> > is no guarantee that the TSC frequency won't change when you migrate. The
> approach
> > described in section 15.4.3 is the preferred approach that can accommodate
> migration.
> >
> Thanks.

Peter,
Please let me know if there are other issues I need to address here. Now that Dmitry has queued up the
Hyper-V keyboard driver, with this patch we can fully support Linux on our uefi firmware.

Regards,

K. Y 
