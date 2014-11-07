Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaKGW4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:56:47 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56239 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbaKGW4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:56:45 -0500
X-Sasl-enc: M2tKyTejtWqCbC2xnYjMKKTZWLgW7PKzKFV0L7kulHVK 1415401005
Date: Fri, 7 Nov 2014 20:56:39 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 8/8] x86, microcode, intel: defend apply_microcode_intel
 with BUG_ON
Message-ID: <20141107225639.GD18128@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-9-git-send-email-hmh@hmh.eng.br>
 <20141107200501.GF5180@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107200501.GF5180@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014, Borislav Petkov wrote:
> On Mon, Sep 08, 2014 at 02:37:54PM -0300, Henrique de Moraes Holschuh wrote:
> > Microcode updates that requires an unknown loader should never reach the
> > apply_* functions (the code should have rejected it earlier).  Likewise
> > for an unknown microcode header layout.
> > 
> > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > ---
> >  arch/x86/kernel/cpu/microcode/intel.c       |    2 ++
> >  arch/x86/kernel/cpu/microcode/intel_early.c |    2 ++
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
> > index 40caef1..439681f 100644
> > --- a/arch/x86/kernel/cpu/microcode/intel.c
> > +++ b/arch/x86/kernel/cpu/microcode/intel.c
> > @@ -157,6 +157,8 @@ static int apply_microcode_intel(int cpu)
> >  	if (mc_intel == NULL)
> >  		return 0;
> >  
> > +	BUG_ON(mc_intel->hdr.hdrver != 1 || mc_intel->hdr.ldrver != 1);
> > +
> >  	/* Intel SDM vol 3A section 9.11.6, page 9-34 */
> >  	if (WARN_ONCE((unsigned long)(mc_intel->bits) % 16,
> >  		"microcode data incorrectly aligned"))
> > diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
> > index 994c59b..095db11 100644
> > --- a/arch/x86/kernel/cpu/microcode/intel_early.c
> > +++ b/arch/x86/kernel/cpu/microcode/intel_early.c
> > @@ -671,6 +671,8 @@ static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
> >  	if (mc_intel == NULL)
> >  		return 0;
> >  
> > +	BUG_ON(mc_intel->hdr.hdrver != 1 || mc_intel->hdr.ldrver != 1);
> > +
> >  	mcu_data = mc_intel->bits;
> >  	aligned_mcu_data = mc_intel->bits;
> 
> Both not needed, because we're running all microcode through
> microcode_sanity_check() first which already does that check.

Yeah, that's why it is BUG_ON().

But if you feel this is too defensive, I will just drop this patch.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
