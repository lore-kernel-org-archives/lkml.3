Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaHHPVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:21:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46382 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628AbaHHPVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:21:42 -0400
Date: Fri, 8 Aug 2014 17:21:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20140808152135.GD2776@pd.tnic>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-8-git-send-email-hmh@hmh.eng.br>
 <20140728153157.GC5350@pd.tnic>
 <20140728193734.GC9752@khazad-dum.debian.net>
 <20140729104520.GF11179@pd.tnic>
 <20140729202543.GB15382@khazad-dum.debian.net>
 <20140804110942.GC4808@pd.tnic>
 <20140804201836.GA24823@khazad-dum.debian.net>
 <20140808125430.GC2776@pd.tnic>
 <20140808135057.GC17542@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140808135057.GC17542@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 10:50:57AM -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 08 Aug 2014, Borislav Petkov wrote:
> > If someone tries to load a microcode blob which has been split and so
> > on, then we should refuse loading. We want to accept microcode from the
> > vendor and nothing else glued together.
> 
> I don't quite get why we should refuse microcode

Because the blob from the official location passes internal validation, I'd
strongly assume. Everything else doesn't.

> that has been split by userspace when the Intel SDM explicitly states
> that tools can do that if there is a need,

Where?

> In these last two weeks I tried to look around for microcode loader
> implementantions, and now I believe we will *never* see microcode with the
> current version of the extended signatures specification.  The loaders in
> the field are just too broken, Intel might as well come up with a new and
> enhanced design that doesn't have so many sharp edges, since nearly everyone
> will have to patch their loaders anyway.

You can't just assume that just because implementations are faulty there
- they should adhere to the SDM and it is authoritative. If the extended
signatures are really needed at some point, implementations will have to
be fixed.

> I will respin the patch without the %1024 comment.  Note that I never
> *removed* any test, we never tested for %1024 in the first place

And I'm saying we should if we're loading the official blob.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
