Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaAVWIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:08:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:54377 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbaAVWIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:08:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,702,1384329600"; 
   d="scan'208";a="405403450"
Date: Wed, 22 Jan 2014 14:13:30 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, fengguang.wu@intel.com,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v2] x86: don't introduce more __cpuinit users in
 intel_mid_weak_decls.h
Message-ID: <20140122221330.GB6519@psi-dev26.jf.intel.com>
References: <52dff2dd.pH9hExjpyBbWvw0a%fengguang.wu@intel.com>
 <1390412055-19341-1-git-send-email-paul.gortmaker@windriver.com>
 <20140122215032.GA6519@psi-dev26.jf.intel.com>
 <52E03F04.60200@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E03F04.60200@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 04:58:28PM -0500, Paul Gortmaker wrote:
> On 14-01-22 04:50 PM, David Cohen wrote:
> > On Wed, Jan 22, 2014 at 12:34:15PM -0500, Paul Gortmaker wrote:
> >> Commit 85611e3febe78955a519f5f9eb47b941525c8c76 ("x86, intel-mid:
> >> Add Clovertrail platform support") added new instances of __cpuinit
> >> usage.  We removed this a couple versions ago; we now want to remove
> >> the compat no-op stubs.  Introducing new users is not what we want to
> >> see at this point in time, as it will break once the stubs are gone.
> >>
> >> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> >> Cc: David Cohen <david.a.cohen@linux.intel.com>
> >> Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> >> Cc: Fei Yang <fei.yang@intel.com>
> >> Cc: H. Peter Anvin <hpa@linux.intel.com>
> >> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> >> ---
> >>
> >> [v2: actually include changes to mfld.c as well this time
> >>
> >>  patch will be added to init cleanup series:
> >>    http://git.kernel.org/cgit/linux/kernel/git/paulg/init.git/  ]
> >>
> >>  arch/x86/platform/intel-mid/intel_mid_weak_decls.h | 4 ++--
> >>  arch/x86/platform/intel-mid/mfld.c                 | 4 ++--
> >>  2 files changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
> >> index a537ffc16299..41fe17d0d8ff 100644
> >> --- a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
> >> +++ b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
> >> @@ -14,6 +14,6 @@
> >>  /* For every CPU addition a new get_<cpuname>_ops interface needs
> >>   * to be added.
> >>   */
> >> -extern void * __cpuinit get_penwell_ops(void) __attribute__((weak));
> >> -extern void * __cpuinit get_cloverview_ops(void) __attribute__((weak));
> >> +extern void *get_penwell_ops(void) __attribute__((weak));
> >> +extern void *get_cloverview_ops(void) __attribute__((weak));
> >>  extern void * __init get_tangier_ops(void) __attribute__((weak));
> >> diff --git a/arch/x86/platform/intel-mid/mfld.c b/arch/x86/platform/intel-mid/mfld.c
> >> index 4f7884eebc14..88b06fcf9959 100644
> >> --- a/arch/x86/platform/intel-mid/mfld.c
> >> +++ b/arch/x86/platform/intel-mid/mfld.c
> >> @@ -64,12 +64,12 @@ static void __init penwell_arch_setup()
> >>  	pm_power_off = mfld_power_off;
> >>  }
> >>  
> >> -void * __cpuinit get_penwell_ops()
> >> +void *get_penwell_ops()
> >>  {
> >>  	return &penwell_ops;
> >>  }
> >>  
> >> -void * __cpuinit get_cloverview_ops()
> >> +void *get_cloverview_ops()
> >>  {
> >>  	return &penwell_ops;
> >>  }
> > 
> > You are still missing one:
> > 
> > --- a/arch/x86/platform/intel-mid/mrfl.c
> > +++ b/arch/x86/platform/intel-mid/mrfl.c
> > @@ -97,7 +97,7 @@ static struct intel_mid_ops tangier_ops = {
> >         .arch_setup = tangier_arch_setup,
> >  };
> >  
> > -void * __cpuinit get_tangier_ops()
> > +void * get_tangier_ops()
> >  {
> >         return &tangier_ops;
> >  }
> > 
> > Can you amend your patch?
> 
> That was fixed in the other patch you already ack'd  :)
> 
> http://git.kernel.org/cgit/linux/kernel/git/paulg/init.git/tree/x86-don-t-add-new-__cpuinit-users-to-Merrifield-plat.patch
> 
> I made the tangier fix a separate patch since it had a separate
> introductory commit, and also actually had the section mismatch.

I misread mrfl and mdfl :/ (guess I could use some rest...) That's why I
took back my ack from the other patch. Sorry for the confusion.

Br, David

> 
> Thanks,
> Paul.
> --
> 
> 
> > 
> > Br, David Cohen
> > 
> >> -- 
> >> 1.8.5.2
