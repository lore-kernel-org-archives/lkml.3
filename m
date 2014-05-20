Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaETNcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:32:50 -0400
Received: from 8bytes.org ([85.214.48.195]:55305 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaETNct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:32:49 -0400
Date: Tue, 20 May 2014 15:32:45 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Cornwall, Jay" <Jay.Cornwall@amd.com>
Cc: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Hurwitz, Sherry" <sherry.hurwitz@amd.com>,
        "Naru, Kim" <Kim.Naru@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iommu/amd: Fix for L2 race with VM invalidation
Message-ID: <20140520133245.GE17056@8bytes.org>
References: <1400049252-4213-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140514092920.GB6026@8bytes.org>
 <99CB3FADB756624A867BE9481439561C334C9045@satlexdag03.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99CB3FADB756624A867BE9481439561C334C9045@satlexdag03.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue May 20 15:32:47 2014
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 537b597f20861863736652
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 11:38:25AM +0000, Cornwall, Jay wrote:
> Hi,
> 
> I'm not sure why you're submitting this, Suravee?
> 
> We already agreed that we need the extra mmu_notifier point, proposed
> by Joerg back in 2011, to eliminate the race. I had thought we were
> waiting on that to be implemented.

Speaking of this, would it also be possible to hold back all faults (so
not sending back ppr-comletions) between invalidate_range_start/end()?
Or will the hardware run into a timeout when it takes too long to
process a fault or when it issued the maximum number of parallel faults?


Regards,

	Joerg


