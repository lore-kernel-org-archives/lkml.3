Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaJAPpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:45:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57700 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaJAPpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:45:30 -0400
Date: Wed, 1 Oct 2014 17:45:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, bp@suse.de, dan.carpenter@oracle.com,
        dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] edac, amd64_edac: Add F15h M60h support
Message-ID: <20141001154523.GF18271@pd.tnic>
References: <1411070230-10298-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141001113235.GC18271@pd.tnic>
 <542C1EAA.4050408@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <542C1EAA.4050408@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:32:58AM -0500, Aravind Gopalakrishnan wrote:
> >>+			if (dcsm & 0x3) {
> >>+				/* LRDIMMs */
> >>+				edac_dbg(1, "  DIMM type: LRDIMM %dx rank multiply;"
> >>+					 "CS = %d; all DIMMs support ECC: %s\n",
> >>+					 (dcsm & 0x3), cs,
> >>+					 (dclr & BIT(19)) ? "yes" : "no");
> >Why do we need to iterate over the DRAM CS sets? Just for the rank
> >multiplier, apparently. We dump those normally in read_dct_base_mask(),
> >though.
> 
> It's not just for rank multiplier.. we find that it's LRDIMM only by
> examining dcsm. Hence the iteration here..

So we can look only at the first DCSM, no? Or are there systems with
different types of LRDIMMs on one DCT?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
