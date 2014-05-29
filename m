Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbaE2Npv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:45:51 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:56551 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932605AbaE2Npt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:45:49 -0400
Message-ID: <1401371147.22923.4.camel@x220>
Subject: Re: [PATCH] remove duplicate checking code
From: Paul Bolle <pebolle@tiscali.nl>
To: Joerg Roedel <joro@8bytes.org>
Cc: Vaughan Cao <vaughan.cao@oracle.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Thu, 29 May 2014 15:45:47 +0200
In-Reply-To: <20140526093959.GH17056@8bytes.org>
References: <1400225980-12797-1-git-send-email-vaughan.cao@oracle.com>
	 <20140526093959.GH17056@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 May 2014 13:45:48.0047 (UTC) FILETIME=[4C05B9F0:01CF7B44]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 11:39 +0200, Joerg Roedel wrote:
> On Fri, May 16, 2014 at 03:39:40PM +0800, Vaughan Cao wrote:
> > amd_iommu_rlookup_table[devid] != NULL is already guaranteed by check_device
> > called before, it's fine to attach device at this point.
> > 
> > Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> > ---
> >  drivers/iommu/amd_iommu.c | 6 ------
> >  1 file changed, 6 deletions(-)
> 
> Applied, thanks.

This one entered linux-next, as of next-20142527, in commit ecef115d4540
("iommu/amd: Remove duplicate checking code"). It triggers an obviously
correct warning:
    drivers/iommu/amd_iommu.c: In function ‘amd_iommu_init_passthrough’:
    drivers/iommu/amd_iommu.c:3503:6: warning: unused variable ‘devid’ [-Wunused-variable]
      u16 devid;
          ^
    drivers/iommu/amd_iommu.c:3502:20: warning: unused variable ‘iommu’ [-Wunused-variable]
      struct amd_iommu *iommu;
                        ^

Is the trivial fix for this queued somewhere?


Paul Bolle

