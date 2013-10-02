Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3JBXLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 19:11:45 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:9175
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753933Ab3JBXLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:11:44 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Gleb Natapov <gleb@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
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
Thread-Index: AQHOqM30I+mkPB2b1kKq/5YqjRysqJnC17CggAAG+ACAABQ5UIAAikAAgABK5hCABkKSgIAAYOzQgACm54CACFRvYIAAMLCAgA6f7HA=
Date: Wed, 2 Oct 2013 23:11:29 +0000
Message-ID: <9d0d4edf4b484f6cb581f7316ac24681@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <dd29077371564a14b2d317d2291db8a9@SN2PR03MB061.namprd03.prod.outlook.com>
 <52325C1E.90101@zytor.com>
 <50f92d9c16a54e5bb6fa14ef72e5fdfb@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130913095526.GE18381@redhat.com>
 <7737cb643a664b6fb39021b4d364b5cf@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130917135918.GY17294@redhat.com>
 <2b4a9a0cff5143c59a0802a2e425c4db@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130918054335.GE5657@redhat.com>
 <2d39849c011b4cc794686a41e45db87a@SN2PR03MB061.namprd03.prod.outlook.com>
 <5240632F.5070709@zytor.com>
In-Reply-To: <5240632F.5070709@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::2]
x-forefront-prvs: 0987ACA2E2
x-forefront-antispam-report: SFV:NSPM;SFS:(13464003)(51704005)(24454002)(479174003)(377454003)(199002)(189002)(83072001)(65816001)(59766001)(80022001)(63696002)(81542001)(77982001)(54316002)(49866001)(81342001)(47976001)(50986001)(47736001)(56776001)(80976001)(33646001)(74316001)(74366001)(83322001)(19580405001)(53806001)(4396001)(19580395003)(79102001)(69226001)(56816003)(77096001)(74502001)(47446002)(76786001)(76796001)(74662001)(31966008)(54356001)(76482001)(74876001)(81816001)(46102001)(74706001)(81686001)(76576001)(51856001)(85306001)(3826001)(24736002)(15583001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e8:ed31::2;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Monday, September 23, 2013 8:50 AM
> To: KY Srinivasan
> Cc: Gleb Natapov; x86@kernel.org; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; tglx@linutronix.de;
> JBeulich@suse.com; bp@alien8.de; dmitry.torokhov@gmail.com
> Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
> from the hypervisor
> 
> On 09/23/2013 06:02 AM, KY Srinivasan wrote:
> >
> > Peter,
> > Please let me know if there are other issues I need to address here. Now that
> Dmitry has queued up the
> > Hyper-V keyboard driver, with this patch we can fully support Linux on our uefi
> firmware.
> >
> 
> I just got back from Plumber's -- this is on my short list of things to
> look at.  If you haven't heard anything by Wednesday, ping me.

Ping.

K. Y
> 
> 	-hpa
> 

