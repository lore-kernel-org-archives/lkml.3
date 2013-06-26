Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab3FZJhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:37:23 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:45222 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab3FZJhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:37:18 -0400
Date: Wed, 26 Jun 2013 11:37:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Dave Chiluk <chiluk@canonical.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler accounting inflated for io bound processes.
Message-ID: <20130626093713.GA27385@gmail.com>
References: <51C35C05.1070005@canonical.com>
 <1372176104.7497.86.camel@marge.simpson.net>
 <1372182534.7497.129.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372182534.7497.129.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <bitbucket@online.de> wrote:

> On Tue, 2013-06-25 at 18:01 +0200, Mike Galbraith wrote: 
> > On Thu, 2013-06-20 at 14:46 -0500, Dave Chiluk wrote: 
> > > Running the below testcase shows each process consuming 41-43% of it's
> > > respective cpu while per core idle numbers show 63-65%, a disparity of
> > > roughly 4-8%.  Is this a bug, known behaviour, or consequence of the
> > > process being io bound?
> > 
> > All three I suppose.
> 
> P.S.
> 
> perf top --sort=comm -C 3 -d 5 -F 250 (my tick freq)
> 56.65%    netserver
> 43.35%         pert
> 
> perf top --sort=comm -C 3 -d 5
> 67.16%  netserver
> 32.84%       pert
> 
> If you sample a high freq signal (netperf TCP_RR) at low freq (tick),
> then try to reproduce the original signal, (very familiar) distortion
> results.  Perf doesn't even care about softirq yada yada, so seems it's
> a pure sample rate thing.

Would be very nice to randomize the sampling rate, by randomizing the 
intervals within a 1% range or so - perf tooling will probably recognize 
the different weights.

Thanks,

	Ingo
