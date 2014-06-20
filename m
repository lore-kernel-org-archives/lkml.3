Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbaFTSP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:15:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48886 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbaFTSP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:15:26 -0400
Date: Fri, 20 Jun 2014 20:15:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
Message-ID: <20140620181518.GG11391@pd.tnic>
References: <20140620161736.D6AC16FD@viggo.jf.intel.com>
 <20140620161740.BFB00798@viggo.jf.intel.com>
 <53A46008.5060509@zytor.com>
 <53A4619C.8020100@sr71.net>
 <53A46365.6090101@zytor.com>
 <20140620174345.GD11391@pd.tnic>
 <53A47461.4050409@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53A47461.4050409@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:50:25AM -0700, H. Peter Anvin wrote:
> Looking at the AMD init code, there is a whole bunch of other 32/64-bit
> differences that are clearly bogus.  I also see that amd_k7_smp_check()
> doesn't even *exist* on 64 bits, and that init_amd_k7() which calls
> amd_k7_smp_check() only is ever called for family == 6, despite having
> tests for family 7 and above in it.

No, K7 is family 6. The tests are for c->x86_model, or am I looking at
the wrong place?

OTOH, init_amd() could probably use a cleanup of moving the per-family
code into init_amd_<fam>() functions and extending the switch-case.

I'll take a look.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
