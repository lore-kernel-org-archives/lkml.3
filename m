Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967036AbaFTW6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 18:58:38 -0400
Received: from 1wt.eu ([62.212.114.60]:43749 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965046AbaFTW6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 18:58:36 -0400
Date: Sat, 21 Jun 2014 00:58:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Tesar <mtesar@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, tyler.hicks@canonical.com
Subject: Re: [ 059/143] sysctl net: Keep tcp_syn_retries inside the boundary
Message-ID: <20140620225827.GF9639@1wt.eu>
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local> <20140512003203.088027167@1wt.eu> <20140611184644.GA5442@hercules> <20140611194657.GU28551@1wt.eu> <87sinanv6u.fsf@canonical.com> <20140614175047.GH15102@1wt.eu> <87simzgrbs.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87simzgrbs.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Fri, Jun 20, 2014 at 03:16:07PM -0700, Eric W. Biederman wrote:
> Willy Tarreau <w@1wt.eu> writes:
> 
> > Hi Luis,
> >
> > On Thu, Jun 12, 2014 at 01:55:53PM +0100, Luis Henriques wrote:
> >> I was finally able to spend some more time with this and tried (a
> >> modified) Tyler's patch on top of 2.6.32.62, and it seems to work.
> >> Although I haven't done any extended testing, I don't see the two
> >> stack traces and the /proc/sys/net/ipv4/ directory seems to be
> >> correctly populated.
> >> 
> >> I'm attaching the patch I've used, based on Tyler's.
> >
> > Would any of you or Tyler please kindly pass me a signed-off-by with
> > a commit message ? That would be great. Alternately I'd do it myself
> > and mention you authored them.
> 
> If my memory serves it is possibe in 2.6.32 to set 
> .ctl_name = CTL_UNNEEDED
> 
> and not need to implement a .strategy routine at all.

Ah that's quite interesting, thanks for the tip!

> Given the fact that most people got the strategy routines
> slightly wrong and that sys_sysctl is effectively unused
> a strategy where you don't implement code that no-one
> will use in a backport I would be preferable.

OK.

> Since you have mentioned this has come up a couple of times if something
> else this will be something to think about for next time.

I'm keeping your e-mail where I manage patches, hoping to recognize
this case next time.

> I am puzzled why .ctl_name was populated in a backport at all.

Oh it's simply because I didn't know it did not have to be there,
and among the few reviewers, I guess that it's not common to know
what version uses what semantics.

Thank you for the exaplanation, it's really helpful. We're not used
to backport sysctl changes but here I got caught a few times and have
found some sysctl.conf with bogus values in field a few times, so it
was really important to backport this one.

Best regards,
Willy

