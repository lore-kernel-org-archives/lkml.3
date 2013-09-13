Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab3IMOaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:30:20 -0400
Received: from [207.46.163.151] ([207.46.163.151]:54314 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932956Ab3IMO3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:29:43 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>, "bp@alien8.de" <bp@alien8.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Thread-Topic: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer
 frequency from the hypervisor
Thread-Index: AQHOqM30I+mkPB2b1kKq/5YqjRysqJnC17CggAAG+ACAABQ5UIAAU2gAgACAl+A=
Date: Fri, 13 Sep 2013 14:28:29 +0000
Message-ID: <81e1fdc15f4b4b4bb2d6627ee90ae1ed@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <dd29077371564a14b2d317d2291db8a9@SN2PR03MB061.namprd03.prod.outlook.com>
 <52325C1E.90101@zytor.com>
 <50f92d9c16a54e5bb6fa14ef72e5fdfb@SN2PR03MB061.namprd03.prod.outlook.com>
 <5232CF2C02000078000F2ED9@nat28.tlf.novell.com>
In-Reply-To: <5232CF2C02000078000F2ED9@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.61.203.63]
x-forefront-prvs: 0968D37274
x-forefront-antispam-report: SFV:NSPM;SFS:(13464003)(51704005)(479174003)(377454003)(189002)(199002)(24454002)(66066001)(80022001)(81542001)(81342001)(69226001)(47976001)(50986001)(49866001)(47736001)(4396001)(46102001)(63696002)(54316002)(56776001)(47446002)(31966008)(59766001)(77982001)(76482001)(74502001)(74662001)(79102001)(74366001)(33646001)(74316001)(74876001)(74706001)(76796001)(76576001)(76786001)(80976001)(81686001)(51856001)(53806001)(83072001)(81816001)(83322001)(65816001)(19580405001)(19580395003)(54356001)(56816003)(77096001)(15583001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:174.61.203.63;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jan Beulich [mailto:JBeulich@suse.com]
> Sent: Thursday, September 12, 2013 11:39 PM
> To: KY Srinivasan; H. Peter Anvin
> Cc: olaf@aepfle.de; bp@alien8.de; apw@canonical.com; x86@kernel.org;
> tglx@linutronix.de; devel@linuxdriverproject.org; gregkh@linuxfoundation.org;
> jasowang@redhat.com; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
> from the hypervisor
> 
> >>> On 13.09.13 at 03:43, KY Srinivasan <kys@microsoft.com> wrote:
> 
> >
> >> -----Original Message-----
> >> From: H. Peter Anvin [mailto:hpa@zytor.com]
> >> Sent: Thursday, September 12, 2013 5:28 PM
> >> To: KY Srinivasan
> >> Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org;
> >> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> >> jasowang@redhat.com; tglx@linutronix.de; JBeulich@suse.com;
> bp@alien8.de
> >> Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
> >> from the hypervisor
> >>
> >> On 09/12/2013 05:06 PM, KY Srinivasan wrote:
> >> >
> >> > Peter,
> >> >
> >> > Let me know if you want me to address any additional issues in this patch.
> >> >
> >>
> >> Please address Jan and Gleb's feedback.
> >
> > Gleb's feedback was a question and I answered that as I did Jan's feedback
> > as well.
> > Gleb, Jan, please let me know if there is something else you want addressed
> > here.
> 
> Indeed, apart from the question whether to change that one
> message's level from KERN_INFO to KERN_DEBUG, there was
> nothing really left unexplained (the aspect of the artificial tying
> together of distinct features is really something KY has to
> decide - I merely tried to point out that this is odd).

Thanks Jan. Peter, if it is ok with you, I would like to keep the message
level at KERN_INFO.

Regards,

K. Y

