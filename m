Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaAPXan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:30:43 -0500
Received: from mga03.intel.com ([143.182.124.21]:5296 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaAPXal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:30:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="404107504"
Date: Thu, 16 Jan 2014 15:35:41 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: intel-mid: sfi_handle_*_dev() should check for
 pdata error code
Message-ID: <20140116233541.GA12486@psi-dev26.jf.intel.com>
References: <1387244246-20714-1-git-send-email-david.a.cohen@linux.intel.com>
 <1387518179-4316-1-git-send-email-david.a.cohen@linux.intel.com>
 <1387518179-4316-2-git-send-email-david.a.cohen@linux.intel.com>
 <20131220084953.GB21133@gmail.com>
 <20140115002121.GC18183@psi-dev26.jf.intel.com>
 <20140115065837.GA13462@gmail.com>
 <20140115173952.GB10933@psi-dev26.jf.intel.com>
 <20140115222603.GA28185@psi-dev26.jf.intel.com>
 <20140116095006.GA10278@gmail.com>
 <20140116172354.GA28180@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116172354.GA28180@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 09:23:54AM -0800, David Cohen wrote:
> On Thu, Jan 16, 2014 at 10:50:06AM +0100, Ingo Molnar wrote:
> > 
> > * David Cohen <david.a.cohen@linux.intel.com> wrote:
> > 
> > > Hi Ingo and hpa,
> > > 
> > > On Wed, Jan 15, 2014 at 09:39:52AM -0800, David Cohen wrote:
> > > > On Wed, Jan 15, 2014 at 07:58:37AM +0100, Ingo Molnar wrote:
> > > > > 
> > > > > * David Cohen <david.a.cohen@linux.intel.com> wrote:
> > > > > 
> > > > > > Hi Ingo,
> > > > > > 
> > > > > > On Fri, Dec 20, 2013 at 09:49:53AM +0100, Ingo Molnar wrote:
> > > > > > > 
> > > > > > > * David Cohen <david.a.cohen@linux.intel.com> wrote:
> > > > > > > 
> > > > > > > > Prevent sfi_handle_*_dev() to register device in case
> > > > > > > > intel_mid_sfi_get_pdata() failed to execute.
> > > > > > > > 
> > > > > > > > Since 'NULL' is a valid return value, this patch makes
> > > > > > > > sfi_handle_*_dev() functions to use IS_ERR() to validate returned pdata.
> > > > > > > 
> > > > > > > Is this bug triggering in practice? If not then please say so in the 
> > > > > > > changelog. If yes then is this patch desired for v3.13 merging and 
> > > > > > > also please fix the changelog to conform to the standard changelog 
> > > > > > > style:
> > > > > > > 
> > > > > > >  - first describe the symptoms of the bug - how does a user notice?
> > > > > > > 
> > > > > > >  - then describe how the code behaves today and how that is causing
> > > > > > >    the bug
> > > > > > > 
> > > > > > >  - and then only describe how it's fixed.
> > > > > > > 
> > > > > > > The first item is the most important one - while developers 
> > > > > > > (naturally) tend to concentrate on the least important point, the last 
> > > > > > > one.
> > > > > > 
> > > > > > Thanks for the feedback :)
> > > > > > This new patch set was done in reply to your comment:
> > > > > > https://lkml.org/lkml/2013/12/20/517
> > > > > 
> > > > > Hm, in what way does the new changelog address my first request:
> > > > > 
> > > > > > >  - first describe the symptoms of the bug - how does a user notice?
> > > > > 
> > > > > They are all phrased as bug fixes, yet _none_ of the three changelogs 
> > > > > appears to describe specific symptoms on specific systems - they all 
> > > > > seem to talk in the abstract, with no specific connection to reality.
> > > > > 
> > > > > That really makes it harder for patches to get into the (way too 
> > > > > narrow) attention span of maintainersm, while phrasing it like this:
> > > > > 
> > > > >  'If an Intel-MID system boots in a specific SFI environment then it 
> > > > >   will hang on bootup without this fix.'
> > > > > 
> > > > > or:
> > > > > 
> > > > >  'Existing Intel-MID hardware will run faster with this patch.'
> > > > > 
> > > > > will certainly wake up maintainers like a good coffee in the morning.
> > > > > 
> > > > > If a patch is a cleanup with no known bug fix effects then say so in 
> > > > > the title and the changelog.
> > > > 
> > > > Fair enough.
> > > > These patches are fixing a potential bug that exists in current kernel,
> > > > but I triggered with patches in my development tree that depends on
> > > > this one to be refactored first:
> > > > https://patchwork.kernel.org/patch/3109791/
> > > > 
> > > > I tried to describe the potential bug, but it lacks the real use case as
> > > > you pointed out. I'll resend the patches in a way to trigger and
> > > > describe the situation without dependiing on non-upstreamed patches yet.
> > > > And I'll hurry up to publish my intel mid devel tree as well.
> > > > 
> > > > I hope the new patch set tastes like good morning Brazilian coffee :)
> > > 
> > > In order to show a practical error case fixed by this patch set 
> > > using current legacy platform code, I need to get them working 
> > > first. But it turns out legacy platform code (for Moorestown and 
> > > Medfield) aren't in a good shape at all. I found few cases of 
> > > obsolete platform data being returned from platform code (intel mid 
> > > was orphan for too long on upstream).
> > > 
> > > I'll have to append new patches to this set "[PATCH v2 0/3] x86: 
> > > intel-mid: handle platform code error in better way", so it won't be 
> > > a simple fix of patch description.
> > 
> > Great, more fixes to the code is the best kind of fix to a changelog.
> 
> IMHO it's better than say "considering this driver works, it would fail
> this way because of SFI doing that thing..."
> 
> But thinking twice, I'm tempted to say these patches simply don't do
> functional changes right now. Than I can handle fixing the platform code
> and the new driver's upstreaming that depends on this fix perhaps on 3.15.
> 
> > 
> > > In order to not block the rest of my patches on thread "[PATCH v2 
> > > 0/4] Add Clovertrail and Merrifeld support to Intel MID", please 
> > > consider to apply them first (maybe for 3.14 if possible).
> > 
> > Sure, those look fine to me, but please don't forget about these fixes 
> > either.
> 
> Thanks.
> 
> > 
> > > When I resend these patches here, we can consider apply them on 
> > > 3.14-rcX (as they are bug fixes) or just postpone them to >3.14.
> > 
> > Please send them ASAP, don't wait for v3.14 -rc's. We'll handle the 
> > logistics. Sending those 3 fixes with an improved changelog would be a 
> > good start.
> 
> I'm currently stuck with full day trainings for the rest of the week in
> my job. I can resend ASAP if assuming this is a non-functional change at
> this moment.

I resent this patch set here:
https://lkml.org/lkml/2014/1/16/498

It is non-functional now (explicitly said on changelogs).
I hope it's all good this time.

Br, David Cohen

