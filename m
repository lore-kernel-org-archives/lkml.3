Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab3BKMie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:38:34 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:65167 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab3BKMib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:38:31 -0500
Date: Mon, 11 Feb 2013 13:38:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
Message-ID: <20130211123827.GB5802@gmail.com>
References: <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
 <20130208145539.GC30334@gmail.com>
 <CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
 <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
 <CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
 <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
 <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
 <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
 <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
 <20130209210640.GG8091@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130209210640.GG8091@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Ts'o <tytso@mit.edu> wrote:

> I completely agree with Linus here; in fact, the main reason 
> why it's important to keep userspace tools outside of the 
> kernel is that it keeps us careful about interface design.

We have first hand experience there: tools/perf/.

None of the predicted extreme badness happened. Yes, sometimes 
we broke compatibility as ABI changes/enhancements do - but 
treated them as regressions and fixed them. I also think that 
considering the rate of changes our breakage ratio is very good.

So no badness happened, and in fact a lot of goodness happened: 
which goodness never happened while Linux profiling was a 
separate project isolated as a user-space utility!

Anyone opposing integration I think *HAS* to explain the 
mechanics behind this very example in plain sight.

Why the heck has pretty much every other out of tree profiling 
project died, while the in-tree one is thriving?

Yes, the key is that Arnaldo is good, and so are the other perf 
contributors - and they are good because they feel at home and 
they are productive. Being in the kernel repo is actually 90% 
responsible for that environment!

> For example, I consider it a *feature* that when we extend the 
> file system data structures for ext4, [...]

I consider filesystems the most extreme example. It's so extreme 
that it's almost a separate class for itself.

Filesystems have the most extreme data persistency constraints 
possible: they define the ABI and anything that gets written out 
through them to persistent storage stays there forever and has 
to work, years down the line. So one must be absolutely, 110% 
careful - to the level of inventing new validation technologies 
just to be more careful.

*NONE* of that applies to tools/perf/ or tools/kvm/: neither 
really writes any data structure defined by itself that will be 
persistent forever. perf.data comes closest, but when was it the 
last time you used a year old perf.data? I'd say never. It 
either gets used within a few days or does not get used at all.

( Yet we even keep perf.data compatibility because being careful 
  about data is generally good technology - it's just not 
  *critical*. )

Same goes for tools/kvm/: it has very short data persistency 
latency as well. Such are in fact most other kernel related 
utilities.

So your 'filesystem utilities' example is totally inapplicable 
to tools/perf/ and tools/kvm/. Shaping all utilities based on 
that extreme example is a sad mistake.

Thanks,

	Ingo
