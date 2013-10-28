Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab3J1Myg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:54:36 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49511 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755989Ab3J1Myf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:54:35 -0400
Date: Mon, 28 Oct 2013 12:53:54 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: PERF_EVENT_IOC_PERIOD on ARM vs everywhere else
Message-ID: <20131028125354.GB20814@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.10.1310272233120.12721@vincent-weaver-1.um.maine.edu>
 <20131028085700.GB20218@mudshark.cambridge.arm.com>
 <20131028100049.GK19466@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028100049.GK19466@laptop.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 10:00:49AM +0000, Peter Zijlstra wrote:
> On Mon, Oct 28, 2013 at 08:57:00AM +0000, Will Deacon wrote:
> > > Should other architectures be updated to?  I just wanted to find out the 
> > > rationale for this before I update the manpage to reflect the difference 
> > > in behaviors between architectures.
> > 
> > I don't want to be the `oddball' architecture (at least, not more than I am
> > already :), but I do find it tricky to follow the required semantics of perf
> > as opposed to `it happens to work this way', especially when so much of it
> > is buried in the various arch backends. So if somebody using the thing on
> > ARM has (what looks to me like) a valid issue, then I usually try and fix
> > it.
> 
> Hurmph.. at least raise the issue for the other archs.

Yeah, sorry about that. I thought Stephane might take it forward (since he
was on the perfmon thread I linked to) and I did CC you on the patch.

While we're at it, there was another patch that I CC'd others on since it
might be wanted by other architectures too: cb2d8b342aa0 ("ARM: 7698/1:
perf: fix group validation when using enable_on_exec"). Basically, the
patch ensures that events that are set to enable on exec are included in
group validation, despite being in the OFF state at validation time.

Any thoughts on that?

Will
