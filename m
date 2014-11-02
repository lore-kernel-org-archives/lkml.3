Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaKBOIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 09:08:49 -0500
Received: from pepin.polanet.pl ([193.34.52.2]:45213 "EHLO pepin.polanet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaKBOIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 09:08:46 -0500
Date: Sun, 2 Nov 2014 15:08:39 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64_edac: Build module on x86-32
Message-ID: <20141102140839.GA27342@polanet.pl>
References: <20141102102212.GA7034@polanet.pl>
 <20141102103300.GB5229@pd.tnic>
 <20141102121139.GA7000@polanet.pl>
 <20141102123538.GE5229@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
In-Reply-To: <20141102123538.GE5229@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 13:35:38 +0100, Borislav Petkov wrote:

> Or do you want for amd64_edac to try to pinpoint which DIMMs are causing
> the errors too?

Yes - when error happens, it would be desirable to locate failing module.

> So were you able to confirm that those errors went away after replacing
> the DIMMs?

Can't say - such error (noticed) happened to me only once, how many silent bit
rots I've missed is hard to say, as I haven't got data checksums before.
The previous modules were well tested in this motherboard, so I can't
blame them nor any other component - it's a 'cosmic ray' situation.

OK, with EDAC_DECODE_MCE I would know if I should blame RAM or not. But
if UCE rate is 1/year I can't randomly remove modules and wait if the
problem is gone. Any single UCE should result in action that narrows
down the possibile causes. Other than 'replace entire RAM' obviously.

> First of all, you need to relax yourself. Just calm down a bit, maybe
> take a walk first. Take a deep breath, whatever helps.

OK, done. Sorry for being rude.

> I'm not talking about your time, energy and resources but about mine! I
> don't have 32-bit configurations to test 32-bit amd64_edac and am not
> willing to go buy any. So let me flip your question: are you going to
> test amd64_edac on 32-bit and fix issues when people report them?

1. Yes, I'm going to test, but no, I'm not capable of fixing it, sorry.
1a. There were other reporters you said, maybe some of them are capable.
2. Were there any op-mode specific issues in this code till now? Does
   this differ from not having e.g. F10h hardware? If that happens, I
   might grant remote access to such machine, but that's unfortunatelly all.
3. Didn't know that lack of resources to support discrepancies that might
   occur (but not occuring right now) is valid reason for disabling module
   entirely. After all, there are many parts that are not maintained
   actively at all and nobody removes them preemptively. Back then it
   could be (X86_64 || EXPERIMENTAL), couldn't now it be just a note in
   the description?
4. To be honest I think that more people are abandoning x86-32 than
   enabling ECC on them, so I wouldn't worry about people starting to use this
   and report 32-bit related errors. If you got reports on this once per a few
   months that's the order of magnitude we are talking about.

So, if 32-bit related error are real threat, not just an excuse, ENOTIME
for handling them is fair enough - people determined to have this
running like me will find their way. But please don't say it's not
_worth_ it, Kconfig descriptions are not a place to make such judgements
(as it's YOUR time vs MY data). I'd go for something more objective,
like "this driver might be run on 32-bit kernel, however no complains
would be accepted due to lack of resources to handle 32-bit specific
bugs").

Oh, and one more thing about the proposed description - I've noticed before:

[PATCH 01/16] amd64_edac: Remove F11h support
Fri, 26 Nov 2010 20:04:08 +0100

F11h doesn't support DRAM ECC so whack it away.

and I see F10h, F15h and F16h families only mentioned in amd64_edac.c.

regards,
-- 
Tomasz Pala <gotar@pld-linux.org>
