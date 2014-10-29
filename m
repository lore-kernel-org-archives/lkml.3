Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589AbaJ2OiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:38:03 -0400
Received: from gproxy1-pub.mail.unifiedlayer.com ([69.89.25.95]:35733 "HELO
	gproxy1-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932475AbaJ2OiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:38:01 -0400
X-Authority-Analysis: v=2.1 cv=F5TEKMRN c=1 sm=1 tr=0
 a=9W6Fsu4pMcyimqnCr1W0/w==:117 a=9W6Fsu4pMcyimqnCr1W0/w==:17 a=cNaOj0WVAAAA:8
 a=f5113yIGAAAA:8 a=kj9zAlcOel0A:10 a=TBVoxVdAAAAA:8 a=GhZ5P8ky69gA:10
 a=noBwr2J6l1kA:10 a=zd2uoN0lAAAA:8 a=qm_TePnp5OIS79z_CXMA:9 a=CjuIK1q_8ugA:10
Date: Wed, 29 Oct 2014 07:37:52 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: Joerg Roedel <jroedel@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: export find_extend_vma and handle_mm_fault for
 driver use
Message-ID: <20141029073752.72e5f1c1@jbarnes-hsw>
In-Reply-To: <5450B472.1020301@amd.com>
References: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
	<20141027151327.GE9734@suse.de>
	<544E61A1.7090400@amd.com>
	<20141027083552.4af5753f@jbarnes-hsw>
	<5450B472.1020301@amd.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cool, thanks a lot, Oded.  I guess my compiler did a good job making
sure there were no bugs. :)

Jesse

On Wed, 29 Oct 2014 11:33:38 +0200
Oded Gabbay <oded.gabbay@amd.com> wrote:

> Hi Joerg and Jesse,
> 
> I tested our amdkfd driver with your patches applied (kernel 3.17.1).
> I run OpenCL tests, Aparapi/Sumatra (Java) and OpenMP
> 
> All tests passed and I didn't see any kernel error messages.
> 
> So:
> 
> Tested-by: Oded Gabbay <oded.gabbay@amd.com>
> 
> Oded
> 
> On 10/27/2014 05:35 PM, Jesse Barnes wrote:
> 
> Thanks, I have no way of testing this, but I'm hopeful. :)
> 
> Jesse
> 
> On Mon, 27 Oct 2014 17:15:45 +0200
> Oded Gabbay <oded.gabbay@amd.com> wrote:
> 
> > Sure, no problem
> >
> >       Oded
> >
> > On 10/27/2014 05:13 PM, Joerg Roedel wrote:
> >
> > Hi Oded,
> >
> > can you please test these patches with the KFD driver and make sure
> > nothing breaks for you? I really like this improvement and it would be
> > great to send it upstream for v3.19.
> >
> > Thanks,
> >
> > 	Joerg
> >
> > On Fri, Oct 24, 2014 at 12:34:30PM -0700, Jesse Barnes wrote:
> >
> >> This lets drivers like the AMD IOMMUv2 driver handle faults a bit more
> >> simply, rather than doing tricks with page refs and get_user_pages().
> >>
> >> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> >> ---
> >>    mm/memory.c | 1 +
> >>    mm/mmap.c   | 2 ++
> >>    2 files changed, 3 insertions(+)
> >>
> >> diff --git a/mm/memory.c b/mm/memory.c
> >> index 1cc6bfb..969ff0c 100644
> >> --- a/mm/memory.c
> >> +++ b/mm/memory.c
> >> @@ -3378,6 +3378,7 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
> >>    
> >>    	return ret;
> >>    }
> >> +EXPORT_SYMBOL_GPL(handle_mm_fault);
> >>    
> >>    #ifndef __PAGETABLE_PUD_FOLDED
> >>    /*
> >> diff --git a/mm/mmap.c b/mm/mmap.c
> >> index 7f85520..2ee7971 100644
> >> --- a/mm/mmap.c
> >> +++ b/mm/mmap.c
> >> @@ -2359,6 +2359,8 @@ find_extend_vma(struct mm_struct *mm, unsigned long addr)
> >>    }
> >>    #endif
> >>    
> >> +EXPORT_SYMBOL_GPL(find_extend_vma);
> >> +
> >>    /*
> >>     * Ok - we have the memory areas we should free on the vma list,
> >>     * so release them, and do the vma updates.
> >> -- 
> >> 1.9.1
> 
> 
> 


-- 
Jesse Barnes, Intel Open Source Technology Center
