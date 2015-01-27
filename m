Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbbA0RDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:03:24 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:36617 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbbA0RDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:03:20 -0500
Date: Tue, 27 Jan 2015 10:03:08 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Scot Doyle <lkml14@scotdoyle.com>, peterhuewe@gmx.de, ashley@ashleylai.com,
        christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, trousers-tech@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix suspend/resume paths for TPM 2.0
Message-ID: <20150127170308.GA10140@obsidianresearch.com>
References: <1422356564-17312-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <alpine.DEB.2.11.1501271620520.1725@localhost.localdomain>
 <1422377842.2912.1.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422377842.2912.1.camel@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 06:57:22PM +0200, Jarkko Sakkinen wrote:
> > > +	/* TPM 1.2 requires self-test on resume. */
> > > +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
> > > +		ret = tpm_do_selftest(chip);
> > > +		if (ret < 0)
> > > +			return ret;
> > 
> > Just to note, the return value from tpm_do_selftest() on TPM 1.2 chips was 
> > previously ignored. Mine does return 0.
> 
> Right. I can update the patch to ignore return value if the majority
> wants that.

What happens to the system when pnp_driver.resume() returns failure?

Should tpm ever report failure on resume to the rest of the kernel?

Shouldn't this stuff be in tpm_pm_resume common code anyhow?

Jason
