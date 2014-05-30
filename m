Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145AbaE3SVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 14:21:48 -0400
Received: from 8bytes.org ([85.214.48.195]:43595 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933239AbaE3SVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 14:21:47 -0400
Date: Fri, 30 May 2014 20:21:43 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Vaughan Cao <vaughan.cao@oracle.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove duplicate checking code
Message-ID: <20140530182143.GK17056@8bytes.org>
References: <1400225980-12797-1-git-send-email-vaughan.cao@oracle.com>
 <20140526093959.GH17056@8bytes.org>
 <1401371147.22923.4.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401371147.22923.4.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri May 30 20:21:45 2014
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5388cc3920861616155294
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 03:45:47PM +0200, Paul Bolle wrote:
> On Mon, 2014-05-26 at 11:39 +0200, Joerg Roedel wrote:
> > On Fri, May 16, 2014 at 03:39:40PM +0800, Vaughan Cao wrote:
> > > amd_iommu_rlookup_table[devid] != NULL is already guaranteed by check_device
> > > called before, it's fine to attach device at this point.
> > > 
> > > Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> > > ---
> > >  drivers/iommu/amd_iommu.c | 6 ------
> > >  1 file changed, 6 deletions(-)
> > 
> > Applied, thanks.
> 
> This one entered linux-next, as of next-20142527, in commit ecef115d4540
> ("iommu/amd: Remove duplicate checking code"). It triggers an obviously
> correct warning:
>     drivers/iommu/amd_iommu.c: In function ‘amd_iommu_init_passthrough’:
>     drivers/iommu/amd_iommu.c:3503:6: warning: unused variable ‘devid’ [-Wunused-variable]
>       u16 devid;
>           ^
>     drivers/iommu/amd_iommu.c:3502:20: warning: unused variable ‘iommu’ [-Wunused-variable]
>       struct amd_iommu *iommu;
>                         ^
> 
> Is the trivial fix for this queued somewhere?

Just queued one to my x86/amd branch. Thanks for the report.


	Joerg


