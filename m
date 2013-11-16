Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab3KPKH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 05:07:28 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35509 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab3KPKHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 05:07:21 -0500
Date: Sat, 16 Nov 2013 11:06:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] A minor amd64_edac fix for 3.13
Message-ID: <20131116100649.GB18306@pd.tnic>
References: <20131110122638.GA17775@pd.tnic>
 <CAADWXX_FdW4vGn8N4TA_GcNBrwuqeH_=qxmK2J7K7kfAWztxPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADWXX_FdW4vGn8N4TA_GcNBrwuqeH_=qxmK2J7K7kfAWztxPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 06:02:59PM -0800, Linus Torvalds wrote:
> [ This was in my spam collection. I don't quite know why, but it might
> signify problems with your email setup. Quite often, when gmail is
> unhappy about kernel developer emails, it's been because their email
> provider ends up doing something odd.
> 
> But the headers actually have "spf=pass" and "dkim=pass", so it's
> nothing obvious. ]

Hmm, strange. Does this mean, you don't get other emails from my email
address or only this pull request? Say, do you have this one, for
example:

http://marc.info/?l=linux-kernel&m=138442829620489&w=2

where I ask you whether you're fine with Mauro and me playing interim
EDAC maintainers?

> That said, I don't much like the patch either. The "fixed' version
> looks worse than the original. If it's an unsigned type, no extra code
> will be generated,

Yes, correct, in both cases I have here:

.L779:
        .loc 1 1579 0
        cmpb    $4, %r10b       #, alias_channel
        ja      .L859   #,
.L847:

> and if it's a signed type, it's correct. In either way, the code looks
> good, and the range test means that people reading it don't even need
> to worry about whether the type is signed or not.
>
> If this patch was written because of some f*cking broken compiler
> warning, then just tell the compiler to shut the hell up about it.
> This is a clear example of where compiler warnings are actually making
> things worse.

Yeah, no, the compiler's fine here. Dave raised the issue about not
testing unsigned's for < 0:

http://www.spinics.net/lists/kernel/msg1597525.html

And I took it because it is less code in the .c source file to look at.
But I certainly don't care all that much whether the < 0 test is there
or not as long as the produced code is identical so...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
