Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab3HJUiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 16:38:46 -0400
Received: from longford.logfs.org ([213.229.74.203]:60028 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790Ab3HJUip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 16:38:45 -0400
Date: Sat, 10 Aug 2013 15:05:44 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 10/13] x86: Move cond resched for copy_{from,to}_user
 into low level code 64bit
Message-ID: <20130810190544.GA13658@logfs.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
 <1376089460-5459-11-git-send-email-andi@firstfloor.org>
 <CA+55aFyN2Cnt=uQOnXszwDA971o=xEwO=yFSgL-RH9vRjMsBbg@mail.gmail.com>
 <20130810161031.GK19750@two.firstfloor.org>
 <CA+55aFw94ow=aYF-y9kJu+2ZsA=YLob5wFe01H+ooQmP6EbJvQ@mail.gmail.com>
 <20130810182309.GA5714@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130810182309.GA5714@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 August 2013 20:23:09 +0200, Borislav Petkov wrote:
> 
> Sounds like the debug aspect and the preemption point addition need
> to be sorf-of split into two different functions/macros and each used
> separately.
> 
> Something like keep the current might_sleep and have debug_sleep or
> similar which does only __might_sleep without the resched...

I would argue for using "might_sleep" for the debug variant.  Before
reading this thread I wasn't even aware of the non-debug aspect.
After all, might_sleep naturally reads like some assertion.
"might_preempt" for the non-debug version?  "cond_preempt"?

Jörn

--
It is the mark of an educated mind to be able to entertain a thought
without accepting it.
-- Aristotle
