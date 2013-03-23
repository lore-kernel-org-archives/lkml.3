Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab3CWRcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 13:32:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59304 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab3CWRct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 13:32:49 -0400
Date: Sat, 23 Mar 2013 18:32:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 12/29] x86, tsx: Add a per thread transaction disable
 count
Message-ID: <20130323173238.GA13379@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Andi Kleen <ak@linux.intel.com>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
 <1364001923-10796-13-git-send-email-andi@firstfloor.org>
 <20130323115115.GA10821@pd.tnic>
 <20130323135156.GJ20853@two.firstfloor.org>
 <20130323155256.GB10811@pd.tnic>
 <CA+55aFwim=_UjV+n6MGRCgoa3B-9RuhVF2h=munaRpZhT3Ntfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFwim=_UjV+n6MGRCgoa3B-9RuhVF2h=munaRpZhT3Ntfg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 10:16:28AM -0700, Linus Torvalds wrote:
> On Sat, Mar 23, 2013 at 8:52 AM, Borislav Petkov <bp@alien8.de> wrote:
> >
> > Really? Let's see:
> 
> Your test seems to assume that a single bit is sufficient, which
> sounds unlikely. If you have any kind of nesting going on, you need
> more than one bit. Then add/sub isn't a single "xor" of a bit any
> more.

Right, but does nesting even apply here? I mean, AFAICR the commit
message, we're talking about per-thread transaction disabling. IOW, this
is an on/off button used in a boolean context.

Or is this going to be used as a mechanism to tisable TSX when max
nesting level has been reached?

Hmmm.

Btw, the disable/reenable_txn() aren't used anywhere in the patchset and
I'd actually like to get an idea where/how those are used.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
