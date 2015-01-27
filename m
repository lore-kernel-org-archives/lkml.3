Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbbA0RYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:24:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:55382 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbbA0RYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:24:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,475,1418112000"; 
   d="scan'208";a="518450103"
Message-ID: <1422379417.2912.4.camel@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix suspend/resume paths for TPM 2.0
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Scot Doyle <lkml14@scotdoyle.com>, peterhuewe@gmx.de, ashley@ashleylai.com,
        christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, trousers-tech@lists.sourceforge.net
Date: Tue, 27 Jan 2015 19:23:37 +0200
In-Reply-To: <20150127170308.GA10140@obsidianresearch.com>
References: <1422356564-17312-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	 <alpine.DEB.2.11.1501271620520.1725@localhost.localdomain>
	 <1422377842.2912.1.camel@linux.intel.com>
	 <20150127170308.GA10140@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.10-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 10:03 -0700, Jason Gunthorpe wrote:
> On Tue, Jan 27, 2015 at 06:57:22PM +0200, Jarkko Sakkinen wrote:
> > > > +	/* TPM 1.2 requires self-test on resume. */
> > > > +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
> > > > +		ret = tpm_do_selftest(chip);
> > > > +		if (ret < 0)
> > > > +			return ret;
> > > 
> > > Just to note, the return value from tpm_do_selftest() on TPM 1.2 chips was 
> > > previously ignored. Mine does return 0.
> > 
> > Right. I can update the patch to ignore return value if the majority
> > wants that.
> 
> What happens to the system when pnp_driver.resume() returns failure?
> 
> Should tpm ever report failure on resume to the rest of the kernel?
> 
> Shouldn't this stuff be in tpm_pm_resume common code anyhow?

I think it should but not in the scope of this bug fix IMHO.

> Jason

/Jarkko

