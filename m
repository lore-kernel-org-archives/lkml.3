Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab3LWNK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 08:10:57 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36029 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211Ab3LWNKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 08:10:55 -0500
Date: Mon, 23 Dec 2013 14:10:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Perf: Correct Assumptions about Sample Timestamps in
 Passes
Message-ID: <20131223131051.GB585@localhost.localdomain>
References: <528484CB.7@tu-dresden.de>
 <20131114083930.GC16543@gmail.com>
 <528490DE.4080204@tu-dresden.de>
 <20131114100552.GA5064@gmail.com>
 <528E1EE6.9040407@tu-dresden.de>
 <20131127135137.GA24403@gmail.com>
 <52B437AA.4090102@tu-dresden.de>
 <52B479E1.7020204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B479E1.7020204@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 10:09:53AM -0700, David Ahern wrote:
> On 12/20/13, 5:27 AM, Joseph Schuchart wrote:
> >I know this comes late, but: As far as I can see, your change does not
> >preserve the logic of the code I suggested. The idea was to first gather
> >all the maximum timestamps of all cpus (that is, the last timestamp seen
> >on each cpu) and then determine the minimum of these maxima. These are
> >two distinct steps that I think cannot be combined in one update. Your
> 
>  A number of people have reported similar problems -- timestamps
> below last flush time. This approach would solve that problem for
> data processed from files, so it would be a good improvement.

Could it be near what you're looking for?

https://lkml.org/lkml/2012/2/18/53
