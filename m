Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaIZWDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 18:03:35 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:44587 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbaIZWDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 18:03:33 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVLtJOYkHwsmwueZ7jsSgrNED564W+m4FmMZJZL-836mg@mail.gmail.com>
References: <CALCETrVrHHxGo1RkPu+9LVnPo9XY9yYnJzg2ot0zOgoBspzbOQ@mail.gmail.com>
	<CAMEtUuyt9RASKZ4NeqK_OUYNN8QT6P20+kjcwywchur6QXSt0A@mail.gmail.com>
	<CALCETrXS5KBHm-3Fz031VFPpTHC_BDOLd_zNB6DjCidZa5-x2A@mail.gmail.com>
	<CAMEtUux-WFOGABTrWW=BGUstE=Zz6agXTGCGrRJtNXDfRmx-5A@mail.gmail.com>
	<CALCETrVLtJOYkHwsmwueZ7jsSgrNED564W+m4FmMZJZL-836mg@mail.gmail.com>
Date: Fri, 26 Sep 2014 15:03:31 -0700
Message-ID: <CAMEtUuxq7oNmDAHZ+1t4Vd-QhW6SV7eoM_juxXGEDJBF3Nfu6A@mail.gmail.com>
Subject: Re: eBPF verifier thoughts (Re: [PATCH v15 net-next 00/11] eBPF
 syscall, verifier, testsuite)
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Miller <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 2:47 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Can't you just disallow the 1-byte write to the stack?

of course not.
That would be extremely limiting to users.
Can you actually see yourself living with stack that only
allows 8-byte writes/reads?
The stack usage will increase a lot, since all char/short
stack variables will become 8-byte...

> I'll try it in Python.  I bet I can get it to be shorter than the current code.

Awesome challenge! :)
I'll buy you a drink of your choice if you can achieve that.
Also I'll send you our C programs that we use for
testing to make sure, your python verifier can analyze them.
If it passes, I'll be glad to rip mine out. Seriously.
Deal?

> Yes, but does it work reliably?

I'm not saying current verifier is perfect. It can get better.
So far it was enough to let people code freely on top of it.
