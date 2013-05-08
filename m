Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab3EHPlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:41:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:44091 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab3EHPlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:41:50 -0400
X-IronPort-AV: E=Sophos;i="4.87,635,1363132800"; 
   d="scan'208";a="22910105"
From: Ross Philipson <Ross.Philipson@citrix.com>
To: Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [Xen-devel] v3.9 - CPU hotplug and microcode earlier loading
 hits a mutex deadlock (x86_cpu_hotplug_driver_mutex)
Thread-Topic: [Xen-devel] v3.9 - CPU hotplug and microcode earlier loading
 hits a mutex deadlock (x86_cpu_hotplug_driver_mutex)
Thread-Index: AQHOSlrBtKmbBRnd2USZ2vUMdzT+tJj6WJoAgAEsBwCAABNpAIAAB0yA///QSVA=
Date: Wed, 8 May 2013 15:41:49 +0000
Message-ID: <92B37F2487AE0841841737618F25AC1A0FF5B3B4@FTLPEX01CL03.citrite.net>
References: <20130506125937.GA14036@phenom.dumpdata.com>
	<20130507190024.GA4303@phenom.dumpdata.com>	<20130508125414.GB30955@pd.tnic>
	<20130508140342.GA8152@phenom.dumpdata.com> <20130508142949.GC30955@pd.tnic>
In-Reply-To: <20130508142949.GC30955@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.74.183]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r48Ffub8009730

> -----Original Message-----
> From: xen-devel-bounces@lists.xen.org [mailto:xen-devel-
> bounces@lists.xen.org] On Behalf Of Borislav Petkov
> Sent: Wednesday, May 08, 2013 7:30 AM
> To: Konrad Rzeszutek Wilk
> Cc: fenghua.yu@intel.com; xen-devel@lists.xensource.com; x86@kernel.org;
> linux-kernel@vger.kernel.org; mingo@redhat.com; hpa@zytor.com;
> tglx@linutronix.de
> Subject: Re: [Xen-devel] v3.9 - CPU hotplug and microcode earlier
> loading hits a mutex deadlock (x86_cpu_hotplug_driver_mutex)
> 
> On Wed, May 08, 2013 at 10:03:42AM -0400, Konrad Rzeszutek Wilk wrote:
> 
> [ â€¦ snip some funky BIOS code ]
> 
> > [here it shifts and continues on testing each CPU bit]
> >
> > > Questions over questions...?
> >
> > I probably went overboard with my answers :-)
> 
> Konrad, you're killing me! :-) You actually went and looked at the
> BIOS disassembly voluntarily. You must be insane, I think you should
> immediately go to the doctor now for a thorough checkup. :-)
> 
> I think I know who I can sling BIOS issues now to.
> 
> > > Looks like save_mc_for_early would need another, local mutex to fix
> that.
> >
> > Let me try that. Thanks for the suggestion.
> 
> Ok, seriously now: yeah, this was just an idea, it should at least get
> the nesting out of the way.
> 
> About the BIOS deal: you're probably staring at some BIOS out there
> but is this the way that it is actually going to be implemented on
> the physical hotplug BIOS? I mean, I've only heard rumors about IVB
> supporting physical hotplug but do you even have access to such BIOS to
> verify?

The ASL Konrad traced through is to make the ACPI bits a guest
interoperate with qemu etc. On bare metal it will be much more opaque
and ugly; the processor related AML will probably burrow down into an
SMI to do the real work.

Ross
> 
> All I'm saying is, let's not hurry too much before we actually can
> really trigger this on baremetal.
> 
> Thanks.
> 
> --
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
