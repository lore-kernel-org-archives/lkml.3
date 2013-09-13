Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab3IMO3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:29:45 -0400
Received: from [207.46.163.235] ([207.46.163.235]:4440 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932900Ab3IMO3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:29:42 -0400
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
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Thread-Topic: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer
 frequency from the hypervisor
Thread-Index: AQHOqM30I+mkPB2b1kKq/5YqjRysqJnC17CggAAG+ACAABQ5UIAAikAAgABK5hA=
Date: Fri, 13 Sep 2013 14:28:35 +0000
Message-ID: <7737cb643a664b6fb39021b4d364b5cf@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <dd29077371564a14b2d317d2291db8a9@SN2PR03MB061.namprd03.prod.outlook.com>
 <52325C1E.90101@zytor.com>
 <50f92d9c16a54e5bb6fa14ef72e5fdfb@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130913095526.GE18381@redhat.com>
In-Reply-To: <20130913095526.GE18381@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.61.203.63]
x-forefront-prvs: 0968D37274
x-forefront-antispam-report: SFV:NSPM;SFS:(377454003)(479174003)(24454002)(13464003)(51704005)(31014004)(189002)(199002)(65816001)(77982001)(59766001)(76786001)(80976001)(76796001)(77096001)(81686001)(56816003)(63696002)(81816001)(50986001)(54356001)(76576001)(74316001)(79102001)(74366001)(15202345003)(74502001)(74662001)(31966008)(47446002)(46102001)(19580395003)(83322001)(19580405001)(74706001)(83072001)(51856001)(56776001)(15975445006)(76482001)(4396001)(54316002)(33646001)(49866001)(47976001)(47736001)(80022001)(69226001)(81342001)(81542001)(74876001)(66066001)(53806001)(15583001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:174.61.203.63;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Gleb Natapov [mailto:gleb@redhat.com]
> Sent: Friday, September 13, 2013 2:55 AM
> To: KY Srinivasan
> Cc: H. Peter Anvin; x86@kernel.org; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; tglx@linutronix.de;
> JBeulich@suse.com; bp@alien8.de
> Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
> from the hypervisor
> 
> On Fri, Sep 13, 2013 at 01:43:09AM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: H. Peter Anvin [mailto:hpa@zytor.com]
> > > Sent: Thursday, September 12, 2013 5:28 PM
> > > To: KY Srinivasan
> > > Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > jasowang@redhat.com; tglx@linutronix.de; JBeulich@suse.com;
> bp@alien8.de
> > > Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
> > > from the hypervisor
> > >
> > > On 09/12/2013 05:06 PM, KY Srinivasan wrote:
> > > >
> > > > Peter,
> > > >
> > > > Let me know if you want me to address any additional issues in this patch.
> > > >
> > >
> > > Please address Jan and Gleb's feedback.
> >
> > Gleb's feedback was a question and I answered that as I did Jan's feedback as
> well.
> > Gleb, Jan, please let me know if there is something else you want addressed
> here.
> >
> No, I am just interesting to know some details about the interface since
> I cannot find it documented in Hyper-V spec.

Thanks Gleb. Here is the link for the latest Hyper-V specification:
http://www.microsoft.com/en-us/download/details.aspx?id=39289

This spec talks about how migration is handled with regards to TSC.

Peter, if you are ok with the message level, there is no other current issue
that is left unaddressed.

Regards,

K. Y 
> 
> --
> 			Gleb.
