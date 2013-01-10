Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3AJTab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:30:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56303 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab3AJTaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:30:30 -0500
Message-ID: <1357846213.5755.30.camel@marge.simpson.net>
Subject: Re: [PATCH 0/5] x86,smp: make ticket spinlock proportional backoff
 w/ auto tuning
From: Mike Galbraith <bitbucket@online.de>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        eric.dumazet@gmail.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Date: Thu, 10 Jan 2013 20:30:13 +0100
In-Reply-To: <50EEDEC1.9020708@redhat.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
	 <1357831182.5841.21.camel@marge.simpson.net> <50EEDEC1.9020708@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:p6ITZCYW61b6J3l2dCjznMBbF9uR5206XV2256vSJag
 tHEZvDg2At4TAqYbcK7nI7g7qdGQKmgx4pnsW5u+hN1qRknaOE
 i9sXt0Og1nv+ZUTnh/SJwVjwZbiJbyBDjSvwqm2Mq2KFxOIfDz
 HxnoHZE04zh0DAFVQWwbyQt6NCfmlwZx0qHpEfHrHlHl59dsP8
 9/ofAhWobUOl7nbd/dMBk9j3QpxLZCUZgQjQZhq3k1RbjZmbYg
 PQ6vBnE793LKzkzkf8C/lu6K1ZfQ+s4ERtpPHyybwaxc5sNuxB
 qnCeQhEUJlk9LfjN84ddLDtWilozQ6qjQBWiIcLKf1J+37Gjby
 ATpDBU9pEgXyp26WALz5CD2DDpE+zv++2B9HJfTIeSfELq4W0n
 EmIyjstcnH6Vg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-10 at 10:31 -0500, Rik van Riel wrote: 
> On 01/10/2013 10:19 AM, Mike Galbraith wrote:
> > On Tue, 2013-01-08 at 17:26 -0500, Rik van Riel wrote:
> >
> >> Please let me know if you manage to break this code in any way,
> >> so I can fix it...
> >
> > I didn't break it, but did let it play with rq->lock contention.  Using
> > cyclictest -Smp99 -i 100 -d 0, with 3 rt tasks for pull_rt_task() to
> > pull around appears to have been a ~dead heat.
> 
> Good to hear that the code seems to be robust. It seems to
> help prevent performance degradation in some workloads, and
> nobody seems to have found regressions yet.

I had hoped for a bit of positive, but a wash isn't surprising given the
profile.  I tried tbench too, didn't expect to see anything at all
there, and got that.. so both results are positive in that respect.

-Mike

