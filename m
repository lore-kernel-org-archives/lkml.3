Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530Ab3GSOVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:21:06 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:57365 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224Ab3GSOVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:21:01 -0400
Date: Fri, 19 Jul 2013 16:20:53 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Willeke <willeke@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v7 0/5] kdump: Allow ELF header creation in new kernel
Message-ID: <20130719162053.61b37f88@mschwide>
In-Reply-To: <20130719133518.GB19997@redhat.com>
References: <OF6010D9F0.5A45F2CF-ONC1257BAB.002B1F3E-C1257BAB.002B2812@de.ibm.com>
	<20130717180049.3b9c6ec8@holzheu>
	<20130717214207.GB27633@redhat.com>
	<20130718124004.098b85f4@holzheu>
	<20130718124754.7453756e@mschwide>
	<20130718133541.GB785@redhat.com>
	<20130719085020.28daef68@mschwide>
	<20130719133518.GB19997@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071914-4966-0000-0000-00000654F502
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jul 2013 09:35:18 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, Jul 19, 2013 at 08:50:20AM +0200, Martin Schwidefsky wrote:
> > On Thu, 18 Jul 2013 09:35:41 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > On Thu, Jul 18, 2013 at 12:47:54PM +0200, Martin Schwidefsky wrote:
> > > > On Thu, 18 Jul 2013 12:40:04 +0200
> > > > Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > On Wed, 17 Jul 2013 17:42:07 -0400
> > > > > Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > > > On Wed, Jul 17, 2013 at 06:00:49PM +0200, Michael Holzheu wrote:
> > > > > 
> > > > > [snip]
> > > > > 
> > > > > > > But this is all additional effort now and would not be necessary if we
> > > > > > > integrate this patch series in 3.11.
> > > > > > > 
> > > > > > > Perhaps we should let Andrew decide here.
> > > > > > 
> > > > > > Hi Michael,
> > > > > > 
> > > > > > Given the fact that andrew too prefers a fix to get s390 working at this
> > > > > > stage can we modify s390 copy_from_oldmem() to be able to copy to 
> > > > > > vmalloc() memory area.
> > > > > > 
> > > > > > For mmap(), let us disable it on s390. And rest of the cleanups w.r.t
> > > > > > ELF header swap etc, let us now target that for 3.12.
> > > > > > 
> > > > > > Sounds reasonable?
> > > > > 
> > > > > Hi Vivek,
> > > > > 
> > > > > Ok this is not our preferred solution but we can't expect that life is
> > > > > always easy ;-)
> > > > > 
> > > > > Our s390 kernel maintainer Martin Schwidefsky agreed to send the following
> > > > > two patches upstream for 3.11:
> > > > > 
> > > > >  * s390/kdump: Disable mmap for s390
> > > > >  * s390/kdump: Allow copy_oldmem_page() copy to virtual memory
> > > > 
> > > > Patches have been added to 
> > > >   git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git features
> > > > 
> > > > They will go upstream with my next pull request.
> > > > 
> > > 
> > > If everything related to crash dump is going through Andrew, wouldn't
> > > it make sense that even these fixes go through him?
> > > 
> > > https://git.kernel.org/cgit/linux/kernel/git/s390/linux.git/commit/?h=features&id=5a74953ff56aa870d6913ef4d81934f5c620c59d
> > > 
> > > https://git.kernel.org/cgit/linux/kernel/git/s390/linux.git/commit/?h=features&id=191a2fa0a8d2bbb64c98f9b1976fcb37ee5eae6b
> > 
> > Most of the architecture specific kdump patches for s390 have gone through me,
> > and these two fall into that category. If you insist we can route them over
> > Andrew, it just seems easier to me via the s390 tree.
> > 
> 
> In this case one patch is modifying proc/vmcore.c and that's not arch
> specific change only.
> 
> Secondly, in this specific instance, these changes are in the context
> of mmap() related changes which just were pushed. I find it easier
> if fixes flow through same channel where previous big set of patches
> flowed through.
> 
> Hence, I was expecting that Michael will route these fixes through
> Andrew. But I am not too particular about it, so go ahead and
> push it to Linus.

The pull request is on its way.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

