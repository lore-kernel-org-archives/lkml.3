Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbaHHNvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:51:13 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44469 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126AbaHHNvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:51:12 -0400
X-Sasl-enc: Nxlltv42fwemg+N3En2tD2MSIDHJnKGHnhMaGKUQ1xql 1407505870
Date: Fri, 8 Aug 2014 10:50:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20140808135057.GC17542@khazad-dum.debian.net>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-8-git-send-email-hmh@hmh.eng.br>
 <20140728153157.GC5350@pd.tnic>
 <20140728193734.GC9752@khazad-dum.debian.net>
 <20140729104520.GF11179@pd.tnic>
 <20140729202543.GB15382@khazad-dum.debian.net>
 <20140804110942.GC4808@pd.tnic>
 <20140804201836.GA24823@khazad-dum.debian.net>
 <20140808125430.GC2776@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808125430.GC2776@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Aug 2014, Borislav Petkov wrote:
> If someone tries to load a microcode blob which has been split and so
> on, then we should refuse loading. We want to accept microcode from the
> vendor and nothing else glued together.

I don't quite get why we should refuse microcode that has been split by
userspace when the Intel SDM explicitly states that tools can do that if
there is a need, but hey, I consider this to be a very minor point now:

In these last two weeks I tried to look around for microcode loader
implementantions, and now I believe we will *never* see microcode with the
current version of the extended signatures specification.  The loaders in
the field are just too broken, Intel might as well come up with a new and
enhanced design that doesn't have so many sharp edges, since nearly everyone
will have to patch their loaders anyway.

I will respin the patch without the %1024 comment.  Note that I never
*removed* any test, we never tested for %1024 in the first place (nor does
anyone else with the possible exception of proprietary tools to write
microcode to FLASH or merge them into a BIOS image).

> > "CPUID returns a value in a model specific register in addition to its
> > usual register return values. The semantics of CPUID cause it to
> > deposit an update ID value in the 64-bit model-specific register at
> > address 08BH (IA32_BIOS_SIGN_ID).  If no update is present in the
> > processor, the value in the MSR remains unmodified.  The BIOS must
> > pre-load a zero into the MSR before executing CPUID. If a read of the
> > MSR at 8BH still returns zero after executing CPUID, this indicates
> > that no update is present."
> > 
> > Reading a revision of zero really is supposed to mean "no update is
> > present in the processor", and that's because it must be pre-loaded
> > with a zero before cpuid is called.
> > 
> > IMHO, this mean that one should be really paranoid over any Intel
> > microcode update that claims to have a revision of zero.  Intel
> > wouldn't release such a microcode update except in error, and we can
> > safely assume we want nothing to do with any such update attempts.
> 
> Ok, then please change the patch to reflect that - it is not "silicon
> microcode" anymore but revision 0 is special and means no update was
> done. Which is a proper way for the CPU to signal microcode update
> status.

Will change the commit log in the respin.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
