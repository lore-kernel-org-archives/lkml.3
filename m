Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbaCCXmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:42:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36734 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbaCCXmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:42:09 -0500
Date: Mon, 3 Mar 2014 23:42:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Message-ID: <20140303234207.GQ18016@ZenIV.linux.org.uk>
References: <20140303210359.26624.qmail@science.horizon.com>
 <20140303212642.GJ18016@ZenIV.linux.org.uk>
 <CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
 <20140303220106.GL18016@ZenIV.linux.org.uk>
 <CA+55aFyRJqb1HkVESdZDOcQ+20t-s-JWxZa15SHJpGU+k=6www@mail.gmail.com>
 <20140303232858.GO18016@ZenIV.linux.org.uk>
 <CA+55aFyEXgMh61P3cmjZzw3RxitiL0oymWSyUsiMp96iJ+98Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyEXgMh61P3cmjZzw3RxitiL0oymWSyUsiMp96iJ+98Og@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 03:34:43PM -0800, Linus Torvalds wrote:
> On Mon, Mar 3, 2014 at 3:28 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Umm...   I would be very surprised if that worked well.  You have just
> > forced fdget() to comply to the ABI.  And unless that has such structs
> > returned in register pairs, there's no way for compiler to do about
> > that.
> 
> Register pairs are very much a common return model.
> 
> And we've relied on that before. For example, 64-bit pte's on x86-32
> very much does that whole thing with the "pte_t" union.
> 
> So you can now commence being surprised.
> 
> (Side note: I think sparc or something doesn't support it, and may
> return things in memory. I can't really seem to find it in myself to
> care)

sparc64 actually does support that.  So does amd64, and, with explicit
flag, i386.  No other more or less general purpose architecture does.

Not ppc.  Not mips.  Not arm.  I think that some of those are worth
caring about...
