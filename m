Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab3HJSXM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 14:23:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42122 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab3HJSXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 14:23:11 -0400
Date: Sat, 10 Aug 2013 20:23:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 10/13] x86: Move cond resched for copy_{from,to}_user
 into low level code 64bit
Message-ID: <20130810182309.GA5714@pd.tnic>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
 <1376089460-5459-11-git-send-email-andi@firstfloor.org>
 <CA+55aFyN2Cnt=uQOnXszwDA971o=xEwO=yFSgL-RH9vRjMsBbg@mail.gmail.com>
 <20130810161031.GK19750@two.firstfloor.org>
 <CA+55aFw94ow=aYF-y9kJu+2ZsA=YLob5wFe01H+ooQmP6EbJvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFw94ow=aYF-y9kJu+2ZsA=YLob5wFe01H+ooQmP6EbJvQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 09:27:33AM -0700, Linus Torvalds wrote:
> Now, the *debug* logic is entirely different, of course. Maybe the
> problem is that we have mixed up the two so badly, and we have
> "might_sleep()" that implies more of a debug issue than a preemption
> issue, and then people add those because they want the debug coverage
> (and then you *absolutely* want it even for a single-byte user
> mode access). And then because the concept is tied together with
> preemption, we end up doing preemption even for that single-byte
> access despite the fact that it makes no sense what-so-ever.

Sounds like the debug aspect and the preemption point addition need
to be sorf-of split into two different functions/macros and each used
separately.

Something like keep the current might_sleep and have debug_sleep or
similar which does only __might_sleep without the resched...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
