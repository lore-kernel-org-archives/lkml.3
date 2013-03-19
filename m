Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164Ab3CSWMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:12:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:2559 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964950Ab3CSWMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:12:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,874,1355126400"; 
   d="scan'208";a="309109593"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
CC: "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [3.9-rc1] Bug in bootup code or debug code?
Thread-Topic: [3.9-rc1] Bug in bootup code or debug code?
Thread-Index: AQHOH+41JMUeuBHQvESU+8AmIyoShpijvDbQgACeM4CAADKXgIAJEDzg
Date: Tue, 19 Mar 2013 22:12:39 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122055946F23@ORSMSX105.amr.corp.intel.com>
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp>
	<201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp>
	<201303132224.BEC60922.JStQOFMVFFOHLO@I-love.SAKURA.ne.jp>
	<3E5A0FA7E9CA944F9D5414FEC6C71220528C2DFF@ORSMSX105.amr.corp.intel.com>
	<5140BB13.10806@linux.intel.com>
 <201303140545.DAC69253.FtSJOOFMHVFOLQ@I-love.SAKURA.ne.jp>
In-Reply-To: <201303140545.DAC69253.FtSJOOFMHVFOLQ@I-love.SAKURA.ne.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Tetsuo Handa [mailto:penguin-kernel@I-love.SAKURA.ne.jp]
> H. Peter Anvin wrote:
> > On 03/13/2013 08:22 AM, Yu, Fenghua wrote:
> > >>
> > >> I found the location of "hardware reset" trigger.
> > >>
> > >> It is __pa_symbol(&boot_params) call, for I don't encounter
> "hardware
> > >> reset" if
> > >> I remove the "//" from below debug patch.
> > >>
> > >> This bug is not yet fixed as of 3.9.0-rc2-00188-g6c23cbb .
> > >>
> > >> --- a/arch/x86/kernel/microcode_intel_early.c
> > >> +++ b/arch/x86/kernel/microcode_intel_early.c
> > >> @@ -741,7 +741,9 @@ load_ucode_intel_bsp(void)
> > >>  #ifdef CONFIG_X86_32
> > >>         struct boot_params *boot_params_p;
> > >>
> > >> +       //while (1);
> > >>         boot_params_p = (struct boot_params
> *)__pa_symbol(&boot_params);
> > >> +       while (1);
> > >>         ramdisk_image = boot_params_p->hdr.ramdisk_image;
> > >>         ramdisk_size  = boot_params_p->hdr.ramdisk_size;
> > >>         initrd_start_early = ramdisk_image;
> > >
> > > Tetsuo and Dave,
> > >
> > > That's the place where we suspected to cause the problem.
> > >
> > > My question is: how to access global variable in linear mode in
> virtualization? __pa_symbol() is not a problem for native.
> > >
> >
> > What kind of virtualization are we talking about here?  We should not
> be
> > running this code under any paravirtualized code path -- this is the
> > hypervisor's job to take care of this.  For HVM, this should just
> work
> > the same way.
> >
> > 	-hpa
> >
> H. Peter Anvin wrote:
> > This is a CONFIG_DEBUG_VIRTUAL configuration, isn't it?
> 
> Yes. CONFIG_MICROCODE_INTEL_EARLY=y && CONFIG_64BIT=n &&
> CONFIG_DEBUG_VIRTUAL=y
> on VMware Workstation/Player environment.

Tetsuo,

I just now sent out a patch to fix this issue and you are in the list.

Could you please verify if it fixes the issue you saw?

Thanks.

-Fenghua
