Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbaGXO1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:27:48 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51223 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758976AbaGXO1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:27:47 -0400
X-Sasl-enc: vWArSTPW3E8ebcJu9ha1KjaCg27LrrxywiWLNsdRPYOq 1406212066
Date: Thu, 24 Jul 2014 11:27:40 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 4/8] x86, microcode, intel: fix missing declaration
Message-ID: <20140724142740.GC32421@khazad-dum.debian.net>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-5-git-send-email-hmh@hmh.eng.br>
 <20140724110106.GJ19239@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724110106.GJ19239@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014, Borislav Petkov wrote:
> On Wed, Jul 23, 2014 at 05:10:47PM -0300, Henrique de Moraes Holschuh wrote:
> > Rename apply_microcode() in microcode/intel.c to apply_microcode_intel(),
> > and declare it as extern in the asm/microcode_intel.h header.
> > 
> > This is a cosmetic fix to silence a warning issued by sparse.  It brings
> > the microcode/intel.c driver in line with what microcode/amd.c is doing.
> > 
> > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > ---
> >  arch/x86/include/asm/microcode_intel.h |    1 +
> >  arch/x86/kernel/cpu/microcode/intel.c  |    4 ++--
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
> > index 9067166..2bdbc6b 100644
> > --- a/arch/x86/include/asm/microcode_intel.h
> > +++ b/arch/x86/include/asm/microcode_intel.h
> > @@ -62,6 +62,7 @@ extern int microcode_sanity_check(void *mc, int print_err);
> >  extern int get_matching_sig(unsigned int csig, int cpf, void *mc, int rev);
> >  extern int
> >  update_match_revision(struct microcode_header_intel *mc_header, int rev);
> > +extern int apply_microcode_intel(int cpu);
> >  
> >  #ifdef CONFIG_MICROCODE_INTEL_EARLY
> >  extern void __init load_ucode_intel_bsp(void);
> > diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
> > index a276fa7..a51cb19 100644
> > --- a/arch/x86/kernel/cpu/microcode/intel.c
> > +++ b/arch/x86/kernel/cpu/microcode/intel.c
> > @@ -127,7 +127,7 @@ static int get_matching_mc(struct microcode_intel *mc_intel, int cpu)
> >  	return get_matching_microcode(csig, cpf, mc_intel, crev);
> >  }
> >  
> > -int apply_microcode(int cpu)
> > +int apply_microcode_intel(int cpu)
> 
> Actually, this function should be static. The AMD counterpart is used in
> amd_early.c too, that's why it is exported there, unlike here.
> 
> The "_intel" suffix is ok.

Ok, I will respin this patch.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
