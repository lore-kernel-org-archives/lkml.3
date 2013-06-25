Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab3FYRtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:49:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59919 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3FYRtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:49:23 -0400
Message-ID: <1372182534.7497.129.camel@marge.simpson.net>
Subject: Re: Scheduler accounting inflated for io bound processes.
From: Mike Galbraith <bitbucket@online.de>
To: Dave Chiluk <chiluk@canonical.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Jun 2013 19:48:54 +0200
In-Reply-To: <1372176104.7497.86.camel@marge.simpson.net>
References: <51C35C05.1070005@canonical.com>
	 <1372176104.7497.86.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:kY7Yb+5mWGtbhOzmhFyQbKyn8bfLW9bWVzb6uFZQte9
 OkUBluUW2KU6h9ZDaXHITnSHuaASrObmg0+j8/NsSvS6nR/DvV
 y0HHfuzRNdtifqO38MXxMELVErsORVb6+dhfyWR0qi0YuG+gZN
 cVED8Q5qkxUlsbkV10Q70STdZcOH+He4NGCweGy8Ajom2ZVpXv
 4ysJ8qTERhlqE5gxTODe790bLTefPckuqBlyFezO+/neE7kGno
 9bFjTzBIoTJRR4w532ff2ex2k2A7E6FvlNm2nz+YXJXh5ZLg5r
 KGYtITYO3HrPyvYgt6HSXEuklvjkEYzCsqA7bGmhrh+WJR3HU8
 Tv+9TGJXtIT3/BoV+u/16Q7GI/+MobYjQz/5Zb+k/f1jx64h33
 Mcw92sxcJ0RVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 18:01 +0200, Mike Galbraith wrote: 
> On Thu, 2013-06-20 at 14:46 -0500, Dave Chiluk wrote: 
> > Running the below testcase shows each process consuming 41-43% of it's
> > respective cpu while per core idle numbers show 63-65%, a disparity of
> > roughly 4-8%.  Is this a bug, known behaviour, or consequence of the
> > process being io bound?
> 
> All three I suppose.

P.S.

perf top --sort=comm -C 3 -d 5 -F 250 (my tick freq)
56.65%    netserver
43.35%         pert

perf top --sort=comm -C 3 -d 5
67.16%  netserver
32.84%       pert

If you sample a high freq signal (netperf TCP_RR) at low freq (tick),
then try to reproduce the original signal, (very familiar) distortion
results.  Perf doesn't even care about softirq yada yada, so seems it's
a pure sample rate thing.

-Mike

