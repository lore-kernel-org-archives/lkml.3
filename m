Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaG2VEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 17:04:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60380 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752030AbaG2VEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 17:04:07 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <joro@8bytes.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] PM / Hibernate: Memory bitmap scalability improvements
Date: Tue, 29 Jul 2014 23:22:39 +0200
Message-ID: <3290133.D59AnCbavX@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140728135933.GA5918@pd.tnic>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org> <20140722103443.GV30979@8bytes.org> <20140728135933.GA5918@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 28, 2014 03:59:33 PM Borislav Petkov wrote:
> On Tue, Jul 22, 2014 at 12:34:44PM +0200, Joerg Roedel wrote:
> > So my test was to resume from a swap partition that contained no image.
> > Here is the result from the 16GB machine. First with a v3.16-rc6 kernel
> > without my changes:
> > 
> > kv:~/base # time perf record /usr/sbin/resume /dev/sda1
> > resume: libgcrypt version: 1.5.3
> > [ perf record: Woken up 1 times to write data ]
> > [ perf record: Captured and wrote 0.019 MB perf.data (~823 samples) ]
> > 
> > real    0m0.084s
> > user    0m0.012s
> > sys     0m0.064s
> > 
> > Here is the result with my patches on top:
> > 
> > kv:~/hibernate # time perf record /usr/sbin/resume /dev/sda1
> > resume: libgcrypt version: 1.5.3
> > [ perf record: Woken up 1 times to write data ]
> > [ perf record: Captured and wrote 0.014 MB perf.data (~602 samples) ]
> > 
> > real    0m0.032s
> > user    0m0.003s
> > sys     0m0.027s
> > 
> > So we save around 50ms (or 62% of time) already on this 16GB machine.
> 
> So, let's see, with Joerg's patches we
> 
> - solve the issue on huge boxes. And yes, we most definitely want to be
> able to suspend them too. RAS is one very prominent use case here.
> 
> *and*
> 
> - we see improvement on smaller boxes, above numbers look good to me.
> 
> and all that for an additional 8K for a S/R cycle?! And for some
> additional complexity of a radix tree which is self-contained, well
> tested and understood?
> 
> This looks like certainly like net win to me.

Yes, it does.

I've queued up the Joergs patches for 3.17, thanks!

Rafael

