Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456AbaJUUoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:44:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:45868 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842AbaJUUon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:44:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,764,1406617200"; 
   d="scan'208";a="593281913"
Date: Tue, 21 Oct 2014 23:42:51 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix multiple race conditions in
 tpm_ppi.c
Message-ID: <20141021204251.GA5438@intel.com>
References: <1413879761-25392-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141021165551.GA28382@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021165551.GA28382@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 10:55:51AM -0600, Jason Gunthorpe wrote:
> On Tue, Oct 21, 2014 at 11:22:41AM +0300, Jarkko Sakkinen wrote:
> > * Traversal of the ACPI device tree was not done right. It should lookup
> >   PPI only under the ACPI device that it is associated. Otherwise, it could
> >   match to a wrong PPI interface if there are two TPM devices in the device
> >   tree.
> > * Removed global ACPI handle and version string from tpm_ppi.c as this
> >   is racy. Instead they should be associated with the chip.
> > * Moved code just a tiny bit towards two-phase allocation to implement
> >   fix for the PPI race conditions.
> > * Added missing copyright platter in tpm_ppi.c.
> 
> The PPI parts of this look fine to me, and are a really nice cleanup,
> thanks!
> 
> Personally, I'd sequence this commit right after your 'tpm: two-phase
> chip management functions' commit because it makes it much saner (no
> half step toward the new functions). I assume this is a theoretical
> problem? Or do you have a two TPM system?

This has realized in Intel NUCs where there is PTT and dTPM module. Even
when PTT is selected there is still ACPI device for dTPM so three is a
race condition and PPI is unusable. I think that it's not good that code is
not robust enough to deal with this.

Even if you forget the race condition it feels waste to lookup a handle
that is already known.

I'll send non-TPM2 patches in their own patch set because they don't
require to deal with sysfs attributes.

> Jason

/Jarkko
