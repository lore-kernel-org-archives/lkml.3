Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab3EHO3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:29:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40170 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab3EHO3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:29:08 -0400
Date: Wed, 8 May 2013 16:29:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, fenghua.yu@intel.com,
        xen-devel@lists.xensource.com
Subject: Re: v3.9 - CPU hotplug and microcode earlier loading hits a mutex
 deadlock (x86_cpu_hotplug_driver_mutex)
Message-ID: <20130508142949.GC30955@pd.tnic>
References: <20130506125937.GA14036@phenom.dumpdata.com>
 <20130507190024.GA4303@phenom.dumpdata.com>
 <20130508125414.GB30955@pd.tnic>
 <20130508140342.GA8152@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130508140342.GA8152@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 10:03:42AM -0400, Konrad Rzeszutek Wilk wrote:

[ … snip some funky BIOS code ]

> [here it shifts and continues on testing each CPU bit]
> 
> > Questions over questions...?
> 
> I probably went overboard with my answers :-)

Konrad, you're killing me! :-) You actually went and looked at the
BIOS disassembly voluntarily. You must be insane, I think you should
immediately go to the doctor now for a thorough checkup. :-)

I think I know who I can sling BIOS issues now to.

> > Looks like save_mc_for_early would need another, local mutex to fix that.
> 
> Let me try that. Thanks for the suggestion.

Ok, seriously now: yeah, this was just an idea, it should at least get
the nesting out of the way.

About the BIOS deal: you're probably staring at some BIOS out there
but is this the way that it is actually going to be implemented on
the physical hotplug BIOS? I mean, I've only heard rumors about IVB
supporting physical hotplug but do you even have access to such BIOS to
verify?

All I'm saying is, let's not hurry too much before we actually can
really trigger this on baremetal.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
