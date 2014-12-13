Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaLMP0m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 10:26:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:41693 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaLMP0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 10:26:41 -0500
Date: Sat, 13 Dec 2014 12:26:35 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: "perf top -g" leaking ~300MB per second.
Message-ID: <20141213152635.GG9845@kernel.org>
References: <20141213084845.GA13453@x4>
 <20141213090331.GB13453@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141213090331.GB13453@x4>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Dec 13, 2014 at 10:03:31AM +0100, Markus Trippelsdorf escreveu:
> On 2014.12.13 at 09:48 +0100, Markus Trippelsdorf wrote:
> > Running "perf top -g" built from current Linus tree apparently leaks
> > ~300MB of memory every second an my machine.
> 
> Hmm, this is a much older problem. I just noticed this the first time
> today. 
> To reproduce: Compile some application in the background (make -j4 in my
> case) and run "perf top -g". Perf will continue to accumulate memory
> until the system starts to swap and the OOM killer eventually kicks in.

Yeap, longstanding problem, try minimizing the problem using a lower
frequency.

The callchain code was done initially for 'report' and when I made 'top'
reuse the hist_entry code allowing 'top' to collect callchains was too
easy, but then we need to go thru the callchain/hists/hist_entry code to
make sure that they don't leak, will try to do it...

- Arnaldo
