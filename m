Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaJTRzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:55:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:29542 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbaJTRzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:55:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,757,1406617200"; 
   d="scan'208";a="617375693"
Date: Mon, 20 Oct 2014 10:55:52 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: sathyanarayanan kuppuswamy 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v1 02/10] x86, intel-mid: Remove "weak" from function
 declarations
Message-ID: <20141020175552.GF4529@psi-dev26.jf.intel.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20141015170554.4063.62975.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <CAErSpo4sUi=75tM58_EFSFSWAHQUuAK3Yfaz4vTjCxdGWGhdug@mail.gmail.com>
 <544065E3.4060909@linux.intel.com>
 <20141017014128.GA4513@psi-dev26.jf.intel.com>
 <CAErSpo4L=A5wE_UxwQea5ZHbPWOj8WWkaXJO7gXqvKb=Cc5VZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4L=A5wE_UxwQea5ZHbPWOj8WWkaXJO7gXqvKb=Cc5VZg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:15:17AM -0600, Bjorn Helgaas wrote:
> On Thu, Oct 16, 2014 at 7:41 PM, David Cohen
> <david.a.cohen@linux.intel.com> wrote:
> > Hi Bjorn and Sathya,
> >
> > On Thu, Oct 16, 2014 at 05:42:11PM -0700, sathyanarayanan kuppuswamy wrote:
> >> Hi Bjorn,
> >>
> >> On 10/15/2014 04:26 PM, Bjorn Helgaas wrote:
> >> >[+cc David, Kuppuswamy, x86; sorry, I botched my "stg mail" so you
> >> >weren't included the first time]
> >> >
> >> >On Wed, Oct 15, 2014 at 11:05 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> >>For the following interfaces:
> >> >>
> >> >>   get_penwell_ops()
> >> >>   get_cloverview_ops()
> >> >>   get_tangier_ops()
> >> >>
> >> >>there is only one implementation, so they do not need to be marked "weak".
> >> >>
> >> >>Remove the "weak" attribute from their declarations.
> >> >>
> >> >>Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> >> >>CC: David Cohen <david.a.cohen@linux.intel.com>
> >> >>CC: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> >> >>CC: x86@kernel.org
> >> >>---
> >> >>  arch/x86/platform/intel-mid/intel_mid_weak_decls.h |    7 +++----
> >> >>  1 file changed, 3 insertions(+), 4 deletions(-)
> >> >>
> >> >>diff --git a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
> >> >>index 46aa25c8ce06..3c1c3866d82b 100644
> >> >>--- a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
> >> Please remove this file and move the contents to asm/intel-mid.h.
> 
> I don't know or care enough about intel-mid to do this myself.  Right
> now, I'm just trying to remove unnecessary and incorrect usage of
> "weak" in header files.
> 
> > I partially agree :)
> >
> > Historically, this file was created because we could not build all intel
> > mid variants at once. So we have to select only one during compilation
> > time, which was fixed already.
> >
> > But we don't need to expose those functions outside intel-mid's
> > directory, which means asm/intel-mid.h isn't the best option IMHO.
> >
> > If you want, I can send a small re-work instead: we get rid of this
> > header file completely and simplify a bit what is exposed by
> > asm/intel-mid.h. Or you can keep this patch and then I send the re-work
> > on top of it. Anyway I'm fine.
> 
> It's fine with me if you want to rework this to remove the header
> completely.  When I pointed this out in January [1], you mentioned
> plans for that.  But I think we should merge this patch in the interim
> to remove the use of "weak" in a header file.  If we leave bad
> examples in the tree, they just proliferate.
> 
> [1] http://lkml.kernel.org/r/20140128013013.GA31626@psi-dev26.jf.intel.com

Yeah, a lot late :(
Please, go ahead with this patch and I send something on top of it.

BR, David

> 
> 
> >> >>+++ b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
> >> >>@@ -10,10 +10,9 @@
> >> >>   */
> >> >>
> >> >>
> >> >>-/* __attribute__((weak)) makes these declarations overridable */
> >> >>  /* For every CPU addition a new get_<cpuname>_ops interface needs
> >> >>   * to be added.
> >> >>   */
> >> >>-extern void *get_penwell_ops(void) __attribute__((weak));
> >> >>-extern void *get_cloverview_ops(void) __attribute__((weak));
> >> >>-extern void *get_tangier_ops(void) __attribute__((weak));
> >> >>+extern void *get_penwell_ops(void);
> >> >>+extern void *get_cloverview_ops(void);
> >> >>+extern void *get_tangier_ops(void);
> >> >>
> >>
> >> --
> >> Sathyanarayanan Kuppuswamy
> >> Android kernel developer
> >>
