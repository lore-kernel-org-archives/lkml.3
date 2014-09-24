Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaIXTnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:43:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:49904 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaIXTn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:43:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="578424995"
Date: Wed, 24 Sep 2014 22:43:23 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/12] tpm: TPM2 support for tpm_pcr_read()
Message-ID: <20140924194323.GE6801@intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1411549562-24242-4-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20140924165320.GD8898@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924165320.GD8898@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:53:20AM -0600, Jason Gunthorpe wrote:
> On Wed, Sep 24, 2014 at 12:05:53PM +0300, Jarkko Sakkinen wrote:
> 
> > +static struct tpm_input_header tpm2_pcrread_header = {
> 
> Missing const - all of these static structures in tpm2-cmds.c are missing the
> const, please fix them all.
> 
> > +	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> > +	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
> > +	.ordinal = cpu_to_be32(TPM2_CC_PCR_READ)
> > +};
> 
> BTW, I always thought this was a goofy and very expensive way to store
> 3 values and zero initialize. If you want to do something different in
> the tpm2-cmds.c that would be great too...

What do you think about the way trusted module builds messages? It's easier 
to maintain and debug than the approach used in the tpm subsystem.

That's the approach I was thinking to use when I started doing this but
didn't want to diverge before I get feedback.

> Jason

/Jarkko
