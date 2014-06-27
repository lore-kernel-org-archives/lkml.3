Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaF0DXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:23:46 -0400
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:50865 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaF0DXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:23:44 -0400
X-MXL-Hash: 53ace3c06522786d-fb1b779a7babeab489398adbd2b778cf81c1aa4e
X-MXL-Hash: 53ace3b87afe23ba-3d86b25f3cb091143f84c4173173c554db6462ae
Date: Thu, 26 Jun 2014 23:23:29 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
X-X-Sender: jlaw@jlaw-desktop.mno.stratus.com
To: Jeff Moyer <jmoyer@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Joe Lawrence <joe.lawrence@stratus.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] block,scsi: fixup blk_get_request dead queue
 scenarios
In-Reply-To: <x49oaxf4mfo.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.DEB.2.02.1406262319140.16358@jlaw-desktop.mno.stratus.com>
References: <1401909633-25931-1-git-send-email-joe.lawrence@stratus.com> <x49wqc34psf.fsf@segfault.boston.devel.redhat.com> <53AC461D.6080004@kernel.dk> <x49oaxf4mfo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=Qq3Q3DCd c=1 sm=1 tr=0 a=VNTQBUOG7PJoPU2GWtE7Ww==]
X-AnalysisOut: [:117 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a=nXGuE6rTyBAA:10 a=ByM]
X-AnalysisOut: [f-pIqOQgA:10 a=_KQqW7t0BisA:10 a=CdzKgOd8jloA:10 a=BLceEmw]
X-AnalysisOut: [cHowA:10 a=kj9zAlcOel0A:10 a=uelBKuKpAAAA:8 a=YlVTAMxIAAAA]
X-AnalysisOut: [:8 a=mjndd0fWPFVmtqgmUroA:9 a=CjuIK1q_8ugA:10 a=kSViFEBMy1]
X-AnalysisOut: [sA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014062637); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014, Jeff Moyer wrote:

> Jens Axboe <axboe@kernel.dk> writes:
> 
> > On 2014-06-26 10:08, Jeff Moyer wrote:
> >> Joe Lawrence <joe.lawrence@stratus.com> writes:
> >>
> >>> v1->v2: incorporate Jeff's feedback in bsg_map_hdr() and Reviewed-by
> >>>          tags.
> >>>
> >>> Joe Lawrence (2):
> >>>    block,scsi: verify return pointer from blk_get_request
> >>>    block,scsi: convert and handle ERR_PTR from blk_get_request
> >>
> >> Jens,
> >>
> >> Can you pick this series up?  It actually fixes a NULL pointer
> >> dereference that can happen if (for example) a usb optical drive is
> >> removed while an application is using it.
> >
> > Yeah I'll pick it up, opening up the 3.17 branches soon.
> 
> Thanks, Jens.  Joe, the patches don't apply anymore... would you mind
> sending an updated set so Jens doesn't have to do the fixups?  I think
> you also need to convert blk_mq_alloc_request, I didn't see that in your
> patch.

Hi Jeff,

I have a new set that applies on top of 3.16-rc2... but before posting, I 
wasn't sure what needs to be converted w/regard to blk_mq_alloc_request.  
As far as I can tell, the new multi-queue block IO queueing implementation 
via blk_mq_alloc_request should be safe from this bug as it doesn't 
include any dead queue checks that introduce early exits.

Regards,

-- Joe
