Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbaJVKGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:06:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:38873 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbaJVKGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:06:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,768,1406617200"; 
   d="scan'208";a="593652727"
Date: Wed, 22 Oct 2014 13:05:33 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix multiple race conditions in
 tpm_ppi.c
Message-ID: <20141022100533.GA31487@intel.com>
References: <1413879761-25392-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141021165551.GA28382@obsidianresearch.com>
 <20141021204251.GA5438@intel.com>
 <20141021210215.GA31755@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021210215.GA31755@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 03:02:15PM -0600, Jason Gunthorpe wrote:
> On Tue, Oct 21, 2014 at 11:42:51PM +0300, Jarkko Sakkinen wrote:
> 
> > > Personally, I'd sequence this commit right after your 'tpm: two-phase
> > > chip management functions' commit because it makes it much saner (no
> > > half step toward the new functions). I assume this is a theoretical
> > > problem? Or do you have a two TPM system?
> > 
> > This has realized in Intel NUCs where there is PTT and dTPM module. Even
> > when PTT is selected there is still ACPI device for dTPM so three is a
> > race condition and PPI is unusable. I think that it's not good that code is
> > not robust enough to deal with this.
> 
> Oh OK, you should probably explain in the commit log that this is a
> bug fix that impacts real hardware, that qualifies it for the -stable
> tree.
> 
> Assuming two-phase commit is nearly ready to go, I'd still sequence
> this fix after two-phase for mainline and then use this patch as-is
> for the 3.17 -stable backport of the mainline commit.

OK, makes sense. I'll try to get this done tonight.

> > Even if you forget the race condition it feels waste to lookup a handle
> > that is already known.
> 
> There is no doubt that this new arrangement is much better than what
> was there before!
> 
> Thanks,
> Jason

/Jarkko
