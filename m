Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaDDPB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:01:56 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:27033
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752852AbaDDPBy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:01:54 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL
 legacy PIC
Thread-Topic: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL
 legacy PIC
Thread-Index: AQHPT5v0hZTrqe/+3EGIeADAdCnXXZsBgI4AgAAKkDA=
Date: Fri, 4 Apr 2014 15:01:51 +0000
Message-ID: <fb8d196a0c01479bae9c3669d8ea8be5@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1396574193-12043-1-git-send-email-kys@microsoft.com>
 <20140404141218.GA2161@redhat.com>
In-Reply-To: <20140404141218.GA2161@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.19.246.69]
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(377454003)(189002)(199002)(13464003)(51704005)(19580395003)(83322001)(33646001)(65816001)(81686001)(85306002)(19580405001)(46102001)(51856001)(49866001)(80976001)(20776003)(66066001)(54316002)(95416001)(76482001)(47976001)(15202345003)(76786001)(54356001)(77982001)(87266001)(79102001)(59766001)(87936001)(74662001)(69226001)(74502001)(47446002)(99286001)(4396001)(94316002)(31966008)(76576001)(2656002)(80022001)(74706001)(74876001)(81542001)(74366001)(50986001)(53806001)(15975445006)(92566001)(94946001)(95666003)(47736001)(86612001)(83072002)(74316001)(85852003)(90146001)(93516002)(81816001)(56776001)(76796001)(63696002)(81342001)(98676001)(97336001)(97186001)(86362001)(99396002)(93136001)(56816005)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:B4DDF55E.A3C65F56.F0F50D7C.40F9CAEB.20396;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vivek Goyal [mailto:vgoyal@redhat.com]
> Sent: Friday, April 4, 2014 7:12 AM
> To: KY Srinivasan
> Cc: x86@kernel.org; linux-kernel@vger.kernel.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; hpa@zytor.com; KY Srinivasan;
> stable@vger.kernel.org
> Subject: Re: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL
> legacy PIC
> 
> On Thu, Apr 03, 2014 at 06:16:33PM -0700, K. Y. Srinivasan wrote:
> > Use the NULL legacy PIC when on Hyper-V. With this change we can
> > support kexec even when booting on EFI firmware. This patch has been
> > tested on both EFI as well as non-EFI firmware stacks on Hyper-V.
> >
> > This patch is required to support kexec on EFI firmware on Hyper-V.
> > Please apply.
> 
> Can you give some more details about what's the problem we run into with
> kexec on EFI on hyper-V.
> 
> Now EFI should be enabled in kexeced kernel. That means
> efi_enabled(EFI_BOOT) should be true and that means you would set
> legacy_pic to null anyway.
> 
> So with this patch, what changed w.r.t kexec on EFI.

Vivek,

On Hyper-V EFI firmware stack we have to set the legacy PIC to NULL legacy PIC since
legacy PIC is not emulated and if this were not set to NULL legacy PIC, we would crash in
PIC based calibration code. Hypervisor gives us the calibration information so
we don't need PIC based calibration.

Even on non-EFI firmware, the hypervisor gives us the calibration information
and so, we can set the legacy PIC to NULL legacy PIC unconditionally.

The problem we were having is that the initial boot on the EFI firmware
would succeed as the legacy PIC would be NULL legacy PIC, however
in the kexeced kernel, the initial boot information is not available and so
we would not set the legacy PIC to NULL legacy PIC. Thus, we would crash in
PIC based calibration code in the kexeced kernel.

Since we don't need legacy PIC both on EFI and non-EFI firmware,
we can set the legacy  PIC to NULL legacy PIC unconditionally.

K. Y 
> 
> Thansk
> Vivek
> 
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Cc: <stable@vger.kernel.org>        [3.13+]
> > ---
> >  arch/x86/kernel/cpu/mshyperv.c |   10 ++--------
> >  1 files changed, 2 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/mshyperv.c
> > b/arch/x86/kernel/cpu/mshyperv.c index 76f98fe..47359f7 100644
> > --- a/arch/x86/kernel/cpu/mshyperv.c
> > +++ b/arch/x86/kernel/cpu/mshyperv.c
> > @@ -133,14 +133,8 @@ static void __init ms_hyperv_init_platform(void)
> >  		printk(KERN_INFO "HyperV: LAPIC Timer Frequency: %#x\n",
> >  				lapic_timer_frequency);
> >
> > -		/*
> > -		 * On Hyper-V, when we are booting off an EFI firmware
> stack,
> > -		 * we do not have many legacy devices including PIC, PIT etc.
> > -		 */
> > -		if (efi_enabled(EFI_BOOT)) {
> > -			printk(KERN_INFO "HyperV: Using
> null_legacy_pic\n");
> > -			legacy_pic = &null_legacy_pic;
> > -		}
> > +		printk(KERN_INFO "HyperV: Using null_legacy_pic\n");
> > +		legacy_pic = &null_legacy_pic;
> >  	}
> >  #endif
> >
> > --
> > 1.7.4.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
