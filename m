Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab3GRN2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:28:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758547Ab3GRN2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:28:35 -0400
Date: Thu, 18 Jul 2013 09:27:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v7 0/5] kdump: Allow ELF header creation in new kernel
Message-ID: <20130718132757.GA785@redhat.com>
References: <OF6010D9F0.5A45F2CF-ONC1257BAB.002B1F3E-C1257BAB.002B2812@de.ibm.com>
 <20130717180049.3b9c6ec8@holzheu>
 <20130717214207.GB27633@redhat.com>
 <20130718124004.098b85f4@holzheu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718124004.098b85f4@holzheu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 12:40:04PM +0200, Michael Holzheu wrote:
> On Wed, 17 Jul 2013 17:42:07 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Jul 17, 2013 at 06:00:49PM +0200, Michael Holzheu wrote:
> 
> [snip]
> 
> > > But this is all additional effort now and would not be necessary if we
> > > integrate this patch series in 3.11.
> > > 
> > > Perhaps we should let Andrew decide here.
> > 
> > Hi Michael,
> > 
> > Given the fact that andrew too prefers a fix to get s390 working at this
> > stage can we modify s390 copy_from_oldmem() to be able to copy to 
> > vmalloc() memory area.
> > 
> > For mmap(), let us disable it on s390. And rest of the cleanups w.r.t
> > ELF header swap etc, let us now target that for 3.12.
> > 
> > Sounds reasonable?
> 
> Hi Vivek,
> 
> Ok this is not our preferred solution but we can't expect that life is
> always easy ;-)
> 
> Our s390 kernel maintainer Martin Schwidefsky agreed to send the following
> two patches upstream for 3.11:
> 
>  * s390/kdump: Disable mmap for s390
>  * s390/kdump: Allow copy_oldmem_page() copy to virtual memory
> 
> @Andrew:
> 
> Would you then take the "ELF header in new memory" patch series for 3.12?

Hi Michael,

Once this patch series gets merged for 3.12, can we first do some cleanup
of s390 code before we do further development there. Basically there is
no reason that s390 kdump should be any different than x86. So all the
logic of OLD base can go away. 

Only thing different about s390 is primarily zfcpdump w.r.t handling of
HSA region and creating of elf headers in 2nd kernel.

Thanks
Vivek
