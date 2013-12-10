Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3LJPHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:07:05 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64505 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3LJPHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:07:01 -0500
Date: Tue, 10 Dec 2013 16:06:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <bitbucket@online.de>, Len Brown <lenb@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
Message-ID: <20131210150656.GB873@gmail.com>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
 <1386478624.4748.19.camel@marge.simpson.net>
 <CAJvTdKn_2mihtMLiQVNCOp_zokx8CsSr2c5NhbkbfJ-qvma-8Q@mail.gmail.com>
 <1386559014.4875.16.camel@marge.simpson.net>
 <1386652637.5374.72.camel@marge.simpson.net>
 <alpine.DEB.2.02.1312101458040.28330@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312101458040.28330@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 10 Dec 2013, Mike Galbraith wrote:
> > vogelweide:~/:[130]# turbostat -P -i 60
> > pk cor CPU    %c0  GHz  TSC SMI    %c1    %c3    %c6 CTMP   %pc3   %pc6
> >              0.02 2.12 2.26   0  43.40  56.57   0.00   53  33.81   0.00
> >  0   0   0   0.23 2.10 2.26   5  65.47  34.30   0.00   52  10.69   0.00
> 
> ...
>  
> > That, vs solid >99% pc3 for old 3.0 enterprise kernel.  What happened,
> > dunno, kernel called itself master.  Whatever, I don't like test bogons,
> > and this is one, so I thought I should let you know.  DL980 refuses to
> > come close to the previous result.
> 
> Hmm, that's very similar to the issue Len is seing on his quad 
> socket WM.
> 
> But I can't see it on my dual socket SNB, neither does PeterZ on his 
> dual socket WM machine. Heisenbugs ....
> 
> Can you offline all cpus except core 0, enable all trace events (nop 
> tracer), run "sleep 100" and stop and grab the trace? Please make 
> sure that your tracebuffer is big enough to cover the full thing.

I guess because we are facing a Heisenbug it might be prudent to check 
that the bug is still present with all those cpus offlined and with 
tracing enabled :-/

Thanks,

	Ingo
