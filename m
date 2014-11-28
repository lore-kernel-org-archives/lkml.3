Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaK1Vsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 16:48:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:58834 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaK1Vsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 16:48:46 -0500
Date: Fri, 28 Nov 2014 18:48:40 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Milian Wolff <mail@milianw.de>
Subject: Re: [PATCH v2 2/2] perf record: Show precise number of samples
Message-ID: <20141128214840.GL30226@kernel.org>
References: <1417158708-31401-2-git-send-email-namhyung@kernel.org>
 <1417158859-31538-1-git-send-email-namhyung@kernel.org>
 <20141128124426.GE27703@krava.brq.redhat.com>
 <20141128175613.GY12538@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128175613.GY12538@two.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 28, 2014 at 06:56:13PM +0100, Andi Kleen escreveu:
> > > Reported-by: Milian Wolff <mail@milianw.de>
> > > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > 
> > eeeey great, I mean.. finally ;-) 
> 
> Yes I like it too.
> 
> BTW it would be nice if we could show down a break down on how many
> bytes the different options passed to perf record added, by accounting
> the different header fields. That would guide people who suffer
> from too large perf.data files.

That is a good idea, after perf_evsel__parse_sample() we add up the
things that are variable: callchains, branch_stack, etc.

Will implement if nobody does it first :-)

- Arnaldo
