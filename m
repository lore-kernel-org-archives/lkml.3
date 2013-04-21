Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab3DURpB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 13:45:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34898 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab3DURpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 13:45:00 -0400
Date: Sun, 21 Apr 2013 19:44:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86: Fix AMD K6 indirect call check v2
Message-ID: <20130421174456.GA4559@pd.tnic>
References: <1366562995-20530-1-git-send-email-andi@firstfloor.org>
 <51741CB2.3090209@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51741CB2.3090209@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 10:06:58AM -0700, H. Peter Anvin wrote:
> On 04/21/2013 09:49 AM, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > The AMD K6 errata check relies on timing a indirect call.
> > But the way it was written it could be optimized to a direct call.
> > Force gcc to actually do a indirect call and not just
> > constant resolve the target address.
> > 
> > Found during code review, no runtime testing due to lack
> > of hardware.
> 
> Maybe it would be even better to just code the indirect call instruction
> in assembly?
> 
> Something like:
> 
> 	asm volatile("call *%0"
> 		     : : "r" (vide)
> 		     : "eax", "ecx", "edx");
> 
> Gotta love the metal mask(?) fix without bumping the stepping number...

They fixed it in the next revision:

"Resolution Status. This erratum is corrected in the C stepping of the
AMD-K6 processor."

On page 12 here http://www.datasheetcatalog.org/datasheet/AdvancedMicroDevices/mXwsxv.pdf

But it looks some revBs got fixed too reportedly: "... before B
9730xxxx...". Who knows.

Btw, I can't help but cringe everytime I see the wording "...
instruction is speculatively executed... " in an erratum :-).

So the poor K6 had some issues with SMC, that's sad.

But I have hard time understanding what that test with the 10^6 loop
iterations is supposed to achieve. And what makes sure that the RDTSCs
don't get reordered? Or maybe K6 wasn't reordering that aggressively...

Erratum says "unpredictable system behavior" but it seems it wasn't that
unpredictable after all - otherwise the fix would've been "HLT" right
then and there. :)

Oh well.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
