Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbaHHPpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:45:31 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37786 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756187AbaHHPp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:45:27 -0400
X-Sasl-enc: 1byNJsOed3fdqSEpYE/ge3AUN3mTIwFilGPT0O5SrE5g 1407512726
Date: Fri, 8 Aug 2014 12:45:14 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20140808154514.GB29666@khazad-dum.debian.net>
References: <1406146251-8540-8-git-send-email-hmh@hmh.eng.br>
 <20140728153157.GC5350@pd.tnic>
 <20140728193734.GC9752@khazad-dum.debian.net>
 <20140729104520.GF11179@pd.tnic>
 <20140729202543.GB15382@khazad-dum.debian.net>
 <20140804110942.GC4808@pd.tnic>
 <20140804201836.GA24823@khazad-dum.debian.net>
 <20140808125430.GC2776@pd.tnic>
 <20140808135057.GC17542@khazad-dum.debian.net>
 <20140808152135.GD2776@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808152135.GD2776@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Aug 2014, Borislav Petkov wrote:
> On Fri, Aug 08, 2014 at 10:50:57AM -0300, Henrique de Moraes Holschuh wrote:
> > On Fri, 08 Aug 2014, Borislav Petkov wrote:
> > > If someone tries to load a microcode blob which has been split and so
> > > on, then we should refuse loading. We want to accept microcode from the
> > > vendor and nothing else glued together.
> > 
> > I don't quite get why we should refuse microcode
> 
> Because the blob from the official location passes internal validation, I'd
> strongly assume. Everything else doesn't.
> 
> > that has been split by userspace when the Intel SDM explicitly states
> > that tools can do that if there is a need,
> 
> Where?

Intel SDM vol 3A, last row of table 9-6, page 9-30:

    "Used by utility software to decompose a microcode update into
     multiple microcode updates where each of the new updates is
     constructed without the optional Extended Processor Signature
     Table."

Not that there is any such utility in use as far as I know (and as I said,
iucode-tool doesn't do it either, and I won't add it unless it is absolutely
required).

But, as I said, I don't care about this one anymore because I don't believe
it will have any pratical effects...

> You can't just assume that just because implementations are faulty there
> - they should adhere to the SDM and it is authoritative. If the extended
> signatures are really needed at some point, implementations will have to
> be fixed.

... exactly because just about every implementation WILL have to be fixed,
which means someone @intel will show up around here with a patch.

> > I will respin the patch without the %1024 comment.  Note that I never
> > *removed* any test, we never tested for %1024 in the first place
> 
> And I'm saying we should if we're loading the official blob.

I will add a patch doing that.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
