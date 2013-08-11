Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149Ab3HKEim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 00:38:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49514 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab3HKEik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 00:38:40 -0400
Message-ID: <1376195819.7006.18.camel@marge.simpson.net>
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
From: Mike Galbraith <bitbucket@online.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org
Date: Sun, 11 Aug 2013 06:36:59 +0200
In-Reply-To: <520712AE.6060904@zytor.com>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
	 <5205C4BB.6020003@zytor.com> <1376114128.5332.17.camel@marge.simpson.net>
	 <5206659F.9070705@zytor.com> <1376194657.7006.11.camel@marge.simpson.net>
	 <520712AE.6060904@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:T57lD/+mTSzGKAXxkOAw0ljzKIGGOYxKHGfGWLlIYRK
 mZLyUZxjwzzCjRaIc1lr3rpVzHvLftfMlCRUu+rNe0ijR15flm
 EODA/DN8fh2nQkfkHt0GbEnHORsMNYMXHrkrFXBrmXJNBYcb4A
 pZLlpNTx/DRQUGaWcemeE1WQ9FMWRqEnWF84xBSruibZ8kD3ow
 qoCAyaOpd2Xn3XEnCUtrzeI5A3dyJeA1n+4Ml//p7m8u9u3tyU
 yeu2ISlOybjS5OMhQwcgmowEi5IkxNTSzxq/DSjvFiv2bbaUn7
 RQ3PMTTuHhWJeYsMyY5DneSqlSlD/QzqgQ9T3BWPjYgqgZhPwN
 NgaWwnTNwh9Sf0yjl9C/eH3Tfa7HKocpCuSOwTDsYEcC+fLB/X
 4H7ZBpfhUQxVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-10 at 21:27 -0700, H. Peter Anvin wrote: 
> On 08/10/2013 09:17 PM, Mike Galbraith wrote:
> >>
> >> Do you have any quantification of "munches throughput?"  It seems odd
> >> that it would be worse than polling for preempt all over the kernel, but
> >> perhaps the additional locking is what costs.
> > 
> > I hadn't compared in ages, so made some fresh samples.
> > 
> > Q6600 3.11-rc4
> > 
> > vmark
> > voluntary     169808     155826     154741     1.000
> > preempt       149354     124016     128436      .836
> > 
> > That should be ~worst case, it hates preemption. 
> > 
> > tbench 8
> > voluntary    1027.96    1028.76    1044.60     1.000
> > preempt       929.06     935.01     928.64      .900
> > 
> > hackbench -l 10000
> > voluntary     23.146     23.124     23.230     1.000
> > preempt       25.065     24.633     24.789     1.071
> > 
> > kbuild vmlinux
> > voluntary  3m44.842s  3m42.975s  3m42.954s     1.000
> > preempt    3m46.141s  3m45.835s  3m45.953s     1.010
> > 
> > Compute load comparisons are boring 'course.
> > 
> 
> I presume voluntary is indistinguishable from no preemption at all?

No, all preemption options produce performance deltas.

> Either way, that is definitely a reproducible test case, so if someone
> is willing to take on optimizing preemption they can use vmark as the
> litmus test.  It would be really awesome if we genuinely could get the
> cost of preemption down to where it just doesn't matter.

You have to eat more scheduler cycles, that's what PREEMPT does for a
living.  Release a lock, wham.

-Mike

