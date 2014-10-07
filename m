Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaJGLXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:23:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56190 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaJGLXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:23:47 -0400
Date: Tue, 7 Oct 2014 13:23:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: perf & rasd integration plan
Message-ID: <20141007112342.GC30146@pd.tnic>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20141006150741.GB14113@kernel.org>
 <20141006151605.GE4372@pd.tnic>
 <20141006191227.GD14113@kernel.org>
 <20141006195349.GE20739@pd.tnic>
 <20141006212243.GE14113@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141006212243.GE14113@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 06:22:43PM -0300, Arnaldo Carvalho de Melo wrote:
> My preference would be for single object files, but the pressure to have
> a written in stone library seems to just build up...

Yeah, I think if we have an alternative way to easily integrate that
functionality into external projects, we can avoid the need for a lib.

...

> After doing a 'make perf-targz-src-pkg'
> 
> I.e. no kernel sources involved on the machines where I build test.
> 
> IOW, it is untangled from the kernel sources. As tools/lib/api/ should
> as well.

Ok, that actually sounds like something we should try:

$ make perf-api-src-pkg

which would spit a tgz with all the generic stuff perf carries. People
would simply unpack it in their projects and build it.

That would require somewhat stable function names so that updating is
relatively painless and if visible functions change, some sort of a
README file should say what and why.

Sounds like a good alternative to a lib to me...

> Well, the rasd experience is serving to show areas where there is
> unnecessary entanglement (hists inside perf_event, etc, the ifdefs you
> put in place).

Yep.

> I'm working to remove the ones that are in rasd.c, aiming to have a
> tools/lib/api/ tree that can be used to build rasd and tools/perf/.
> 
> What I don't want to do is to simply straight more
> tools/perf/util/evlist.c to tools/lib/api/perf/, some untanglement work
> is needed.

Yep.

Thanks acme!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
