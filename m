Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3BURuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:50:01 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43528 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab3BURuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:50:00 -0500
Date: Thu, 21 Feb 2013 17:49:55 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130221174955.GA20886@srcf.ucam.org>
References: <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 08:58:45AM -0800, Linus Torvalds wrote:

> If Red Hat wants to deep-throat Microsoft, that's *your* issue.  That
> has nothing what-so-ever to do with the kernel I maintain. It's
> trivial for you guys to have a signing machine that parses the PE
> binary, verifies the signatures, and signs the resulting keys with
> your own key. You already wrote the code, for chissake, it's in that
> f*cking pull request.

There's one significant practical awkwardness, which is that it makes 
key revocation a multi-step process - the blacklisted hash is going to 
be for the PE and not the key itself. I guess the original hash could be 
stuffed in some metadata in the key, but urgh.

Vendors want to ship keys that have been signed by a trusted party. 
Right now the only one that fits the bill is Microsoft, because 
apparently the only thing vendors love more than shitty firmware is 
following Microsoft specs. The equivalent isn't just Red Hat (or anyone 
else) programmatically re-signing those keys, it's re-signing those keys 
with a key that's trusted by the upstream kernel. Would you be willing 
to carry a default trusted key if some sucker/upstanding and 
trustworthy member of society hosted a re-signing service? Or should we 
just assume that anyone who wants to ship external modules is a fucking 
idiot and deserves to be miserable?

(I mean, *I'm* fine with the idea that they're fucking idiots and 
deserve to be miserable, but apparently there's people who think this is 
a vital part of a business model)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
