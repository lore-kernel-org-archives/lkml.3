Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab3GRNgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:36:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758677Ab3GRNgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:36:12 -0400
Date: Thu, 18 Jul 2013 09:35:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Willeke <willeke@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v7 0/5] kdump: Allow ELF header creation in new kernel
Message-ID: <20130718133541.GB785@redhat.com>
References: <OF6010D9F0.5A45F2CF-ONC1257BAB.002B1F3E-C1257BAB.002B2812@de.ibm.com>
 <20130717180049.3b9c6ec8@holzheu>
 <20130717214207.GB27633@redhat.com>
 <20130718124004.098b85f4@holzheu>
 <20130718124754.7453756e@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718124754.7453756e@mschwide>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 12:47:54PM +0200, Martin Schwidefsky wrote:
> On Thu, 18 Jul 2013 12:40:04 +0200
> Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:
> 
> > On Wed, 17 Jul 2013 17:42:07 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Wed, Jul 17, 2013 at 06:00:49PM +0200, Michael Holzheu wrote:
> > 
> > [snip]
> > 
> > > > But this is all additional effort now and would not be necessary if we
> > > > integrate this patch series in 3.11.
> > > > 
> > > > Perhaps we should let Andrew decide here.
> > > 
> > > Hi Michael,
> > > 
> > > Given the fact that andrew too prefers a fix to get s390 working at this
> > > stage can we modify s390 copy_from_oldmem() to be able to copy to 
> > > vmalloc() memory area.
> > > 
> > > For mmap(), let us disable it on s390. And rest of the cleanups w.r.t
> > > ELF header swap etc, let us now target that for 3.12.
> > > 
> > > Sounds reasonable?
> > 
> > Hi Vivek,
> > 
> > Ok this is not our preferred solution but we can't expect that life is
> > always easy ;-)
> > 
> > Our s390 kernel maintainer Martin Schwidefsky agreed to send the following
> > two patches upstream for 3.11:
> > 
> >  * s390/kdump: Disable mmap for s390
> >  * s390/kdump: Allow copy_oldmem_page() copy to virtual memory
> 
> Patches have been added to 
>   git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git features
> 
> They will go upstream with my next pull request.
> 

If everything related to crash dump is going through Andrew, wouldn't
it make sense that even these fixes go through him?

https://git.kernel.org/cgit/linux/kernel/git/s390/linux.git/commit/?h=features&id=5a74953ff56aa870d6913ef4d81934f5c620c59d

https://git.kernel.org/cgit/linux/kernel/git/s390/linux.git/commit/?h=features&id=191a2fa0a8d2bbb64c98f9b1976fcb37ee5eae6b

Thanks
Vivek
