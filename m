Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaEGLO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 07:14:28 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36033 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaEGLO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 07:14:27 -0400
Date: Wed, 7 May 2014 13:14:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [ABOMINATION] x86: Fast interrupt return to userspace
Message-ID: <20140507111422.GA8410@gmail.com>
References: <e94ab903e725eaf9d98e56f3043878bde7fc1b58.1399408110.git.luto@amacapital.net>
 <CA+55aFy6NzQOfyne4xLqQQCvuhpi-KSXnJNLjXTRc7+4ChPAnQ@mail.gmail.com>
 <CA+55aFw_Dj7Lx_bE0B3mDxMUNz_K1yc=saziC9dmA_dKSkFWiw@mail.gmail.com>
 <CA+55aFwix8dSDQ1N1Qu2-9rzGxWeeGAv4fSPVQWGo1YNzJoCoA@mail.gmail.com>
 <CALCETrVHj1rd=ma-dW8C9RNyQNj3smRAyevWJSQXmvgshbQb6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVHj1rd=ma-dW8C9RNyQNj3smRAyevWJSQXmvgshbQb6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> > Whatever. I got enough profile data to say that it seems to have 
> > cut 'iret' overhead by at least two thirds. So it may not *work*, 
> > but from a "hey look, some random numbers" standpoint it is worth 
> > playing with.
> 
> :)
> 
> Is there actual interest in turning something like this into a real 
> patch?  It would almost certainly have to default off and no one 
> sane would ever use it except for special-purpose machines.

The macro speedup looks rather impressive, and we've done ugly things 
for far smaller speedups.

But I don't think it should be a 'special mode'. It either is made to 
work unconditionally and can be a prime speedup to be proud of in a 
politely disgusted fashion, or we don't want the complexity (and 
future bitrot) of some special switch.

At minimum it can be a "look we want this speedup in hardware" 
testcase to CPU designers.

Thanks,

	Ingo
