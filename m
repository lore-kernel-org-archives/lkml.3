Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3JKXbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:31:51 -0400
Received: from mail-bn1lp0157.outbound.protection.outlook.com ([207.46.163.157]:33857
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab3JKXbu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:31:50 -0400
From: KY Srinivasan <kys@microsoft.com>
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Olaf Hering <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [patch x86/hyperv] x86, hyperv: Fix build error
Thread-Topic: [patch x86/hyperv] x86, hyperv: Fix build error
Thread-Index: AQHOxta5P1yA7RPLC0+Qc4gHG+R3tJnwIZhQgAAD9YCAAABSgA==
Date: Fri, 11 Oct 2013 23:31:45 +0000
Message-ID: <05744953b2404341866fad7bb08c5506@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1380554932-9888-1-git-send-email-olaf@aepfle.de>
 <tip-9e7827b5ea4ca93b4d864bc07c0fafb838d496b1@git.kernel.org>
 <alpine.DEB.2.02.1310111604160.31170@chino.kir.corp.google.com>
 <86627d477ccc42aea289f62ad96d0e4b@SN2PR03MB061.namprd03.prod.outlook.com>
 <alpine.DEB.2.02.1310111619470.31170@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1310111619470.31170@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::3]
x-forefront-prvs: 0996D1900D
x-forefront-antispam-report: SFV:NSPM;SFS:(51704005)(377454003)(199002)(189002)(54534003)(13464003)(24454002)(74706001)(47446002)(79102001)(74502001)(74366001)(33646001)(50986001)(47736001)(47976001)(54356001)(81816001)(59766001)(80976001)(76482001)(77982001)(51856001)(74662001)(31966008)(4396001)(56776001)(85306002)(54316002)(81686001)(46102001)(49866001)(53806001)(81342001)(63696002)(81542001)(19580395003)(65816001)(83072001)(80022001)(69226001)(74876001)(83322001)(19580405001)(74316001)(56816003)(77096001)(76576001)(76786001)(76796001)(3826001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e8:ed31::3;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Rientjes [mailto:rientjes@google.com]
> Sent: Friday, October 11, 2013 4:29 PM
> To: KY Srinivasan
> Cc: Ingo Molnar; H. Peter Anvin; tglx@linutronix.de; H. Peter Anvin; Olaf Hering;
> linux-kernel@vger.kernel.org; linux-tip-commits@vger.kernel.org
> Subject: RE: [patch x86/hyperv] x86, hyperv: Fix build error
> 
> On Fri, 11 Oct 2013, KY Srinivasan wrote:
> 
> > > From: David Rientjes [mailto:rientjes@google.com]
> > > Sent: Friday, October 11, 2013 4:08 PM
> > > To: Ingo Molnar; H. Peter Anvin; tglx@linutronix.de; H. Peter Anvin
> > > Cc: KY Srinivasan; Olaf Hering; linux-kernel@vger.kernel.org; linux-tip-
> > > commits@vger.kernel.org
> > > Subject: [patch x86/hyperv] x86, hyperv: Fix build error
> > >
> > > 9e7827b5ea4c ("x86, hyperv: Get the local APIC timer frequency from the
> > > hypervisor") breaks the build with some configs because apic.h isn't
> > > directly included:
> > >
> > > arch/x86/kernel/cpu/mshyperv.c: In function 'ms_hyperv_init_platform':
> > > arch/x86/kernel/cpu/mshyperv.c:90:3: error: 'lapic_timer_frequency'
> undeclared
> > > (first use in this function)
> > > arch/x86/kernel/cpu/mshyperv.c:90:3: note: each undeclared identifier is
> > > reported only once for each function it appears in
> > >
> > > Fix it by including asm/apic.h.
> >
> > Thank you. The issue was configuration related - local APIC was not configured.
> This has already been fixed.
> >
> 
> Yeah, it's config related as stated in the changelog.  If you're referring
> to 90ab9d551093 ("x86, hyperv: Correctly guard the local APIC calibration
> code ")as "fixing" it, it does not.  (I'm left to wonder what you mean by
> it being fixed since you didn't elaborate.)  You can trigger this build
> breakage even with CONFIG_X86_LOCAL_APIC=y.
> 
> Let me be explicit: this file includes desc.h, which includes linux/smp.h,
> which includes asm/smp.h iff CONFIG_SMP is enabled.  That's what you're
> relying upon to get asm/apic.h when CONFIG_X86_LOCAL_APIC is enabled.  It
> will break when CONFIG_SMP is disabled.
> 
> So you need to include asm/apic.h directly for such a configuration.

Thank you for the details.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Regards,

K. Y


