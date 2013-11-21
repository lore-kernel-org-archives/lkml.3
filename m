Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3KUMGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:06:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54109 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab3KUMGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:06:13 -0500
Date: Thu, 21 Nov 2013 13:06:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131121120605.GC26009@pd.tnic>
References: <1384984585-24300-1-git-send-email-bp@alien8.de>
 <20131121073410.GA16971@gmail.com>
 <20131121100722.GA25459@pd.tnic>
 <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
 <20131121114224.GA27704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131121114224.GA27704@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 12:42:24PM +0100, Ingo Molnar wrote:
> Ok - so why not call it tools/lib/kernel/ or tools/lib/kernelapi/ or
> tools/lib/kapi/?

I like short names so "kapi" it is.

> That's really what is common about it: it offers various helper
> methods to interface with the Linux kernel: debugfs, procfs, sysfs
> handling routines with no policy, just pure, obvious helpers to use
> kernel functionality.

Yes.

> [ Naming it 'ktools' is not optimal because these are already tools/
> ... the secondary meaning of 'tools' in that context is easily lost.
> Same goes for 'kutils', the secondary meaning is confusing (to me). ]

Ok.

> ... and just in case you are wondering why I'm making a fuss about it:
> a naming discussion for something fundamental as this isn't bikeshed
> painting, we really want people to look at that place to readily
> stuff kernel related helpers into, and the name should make that very
> obvious.

No, I absolutely don't think it is a bikeshedding exercise too. We
really need that lib because people have started growing their own
facilities in tools/ and outside so having a lib which implements
generic functionality for interfacing with the kernel right is going to
save everyone a lot of time and energy.

So kapi it is, I'm gonna convert what we have to it but leave time for
acme to wake up and smell the coffee ... and the change :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
