Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaAOG6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 01:58:42 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:46327 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaAOG6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 01:58:40 -0500
Date: Wed, 15 Jan 2014 07:58:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: intel-mid: sfi_handle_*_dev() should check for
 pdata error code
Message-ID: <20140115065837.GA13462@gmail.com>
References: <1387244246-20714-1-git-send-email-david.a.cohen@linux.intel.com>
 <1387518179-4316-1-git-send-email-david.a.cohen@linux.intel.com>
 <1387518179-4316-2-git-send-email-david.a.cohen@linux.intel.com>
 <20131220084953.GB21133@gmail.com>
 <20140115002121.GC18183@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115002121.GC18183@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Cohen <david.a.cohen@linux.intel.com> wrote:

> Hi Ingo,
> 
> On Fri, Dec 20, 2013 at 09:49:53AM +0100, Ingo Molnar wrote:
> > 
> > * David Cohen <david.a.cohen@linux.intel.com> wrote:
> > 
> > > Prevent sfi_handle_*_dev() to register device in case
> > > intel_mid_sfi_get_pdata() failed to execute.
> > > 
> > > Since 'NULL' is a valid return value, this patch makes
> > > sfi_handle_*_dev() functions to use IS_ERR() to validate returned pdata.
> > 
> > Is this bug triggering in practice? If not then please say so in the 
> > changelog. If yes then is this patch desired for v3.13 merging and 
> > also please fix the changelog to conform to the standard changelog 
> > style:
> > 
> >  - first describe the symptoms of the bug - how does a user notice?
> > 
> >  - then describe how the code behaves today and how that is causing
> >    the bug
> > 
> >  - and then only describe how it's fixed.
> > 
> > The first item is the most important one - while developers 
> > (naturally) tend to concentrate on the least important point, the last 
> > one.
> 
> Thanks for the feedback :)
> This new patch set was done in reply to your comment:
> https://lkml.org/lkml/2013/12/20/517

Hm, in what way does the new changelog address my first request:

> >  - first describe the symptoms of the bug - how does a user notice?

They are all phrased as bug fixes, yet _none_ of the three changelogs 
appears to describe specific symptoms on specific systems - they all 
seem to talk in the abstract, with no specific connection to reality.

That really makes it harder for patches to get into the (way too 
narrow) attention span of maintainersm, while phrasing it like this:

 'If an Intel-MID system boots in a specific SFI environment then it 
  will hang on bootup without this fix.'

or:

 'Existing Intel-MID hardware will run faster with this patch.'

will certainly wake up maintainers like a good coffee in the morning.

If a patch is a cleanup with no known bug fix effects then say so in 
the title and the changelog.

Thanks,

	Ingo
