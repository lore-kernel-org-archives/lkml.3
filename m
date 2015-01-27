Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbbA0Un7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:43:59 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:37667 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbbA0Un6 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 27 Jan 2015 15:43:58 -0500
Message-ID: <1422391425.4604.7.camel@stgolabs.net>
Subject: Re: [LKP] [mm] c8c06efa8b5: -7.6% unixbench.score
From: Davidlohr Bueso <dave@stgolabs.net>
To: Huang Ying <ying.huang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: LKP ML <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 27 Jan 2015 12:43:45 -0800
In-Reply-To: <1422344736.24875.47.camel@linux.intel.com>
References: <1420684064.6201.86.camel@linux.intel.com>
	 <1420771673.12346.16.camel@stgolabs.net>
	 <1420772606.6201.126.camel@linux.intel.com>
	 <1420776122.12346.18.camel@stgolabs.net>
	 <1422344736.24875.47.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 15:45 +0800, Huang Ying wrote:
> Hi, Davidlohr,
> 
> Any update on this?  The latest news I gotten is that you finally
> reproduced this.

The overall differences and cause of the issue is commit 37e9562453b
(locking/rwsem: Allow conservative optimistic spinning when readers have
lock). And since the performance issue occurs with writers-only, I'm
fine with the degradation,  we need to learn to live it. Real use cases
will use mutexes instead. Also, the mentioned commit fixes a much more
important problem than pathologically calling exec(2).

Now, this doesn't mean we cannot do _anything_ about it. I sent a
patcshet just a few days ago (sorry, I forgot to Cc you) that tries to
minimalize (I've recovered ~75% of the regression) the writer penalties:
https://lkml.org/lkml/2015/1/26/34

So all in all we don't really care for writer-only workloads, but hey,
while we're at it.

Thanks,
Davidlohr

