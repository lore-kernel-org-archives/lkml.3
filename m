Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaHOUQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 16:16:05 -0400
Received: from ns.horizon.com ([71.41.210.147]:40720 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751138AbaHOUQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 16:16:03 -0400
Date: 15 Aug 2014 16:16:01 -0400
Message-ID: <20140815201601.2497.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: peterz@infradead.org, zhaoxiu.zeng@gmail.com
Subject: Re: [PATCH 1/1] GCD: add binary GCD algorithm
Cc: akpm@linux-foundation.org, dhowells@redhat.com, jwboyer@redhat.com,
        linux-kernel@vger.kernel.org, linux@horizon.com, mingo@kernel.org,
        takahiro.akashi@linaro.org
In-Reply-To: <20140815135855.GG19379@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I looked at wikipedia (I wasn't aware of this algorithm, clever
> though), and am still somewhat puzzled by your 'r'.
> 
> What's 'wrong' with their iterative version, or what's better about your
> 'r' stuff?

I need to look more carefully, but it looks nifty.

Basically, it's avoiding the usual issue of counting the lsbits to factor
out a power of 2.

Rather than taking out the common factors of 2 a bit at a time, to
reduce to the case where one is even and one is odd (i.e. ((a ^ b) & 1)
== 1), just find the low-order differing bit and use that instead of
"1" in the algorithm.  I.e. ((1 ^ b) & r) == r.

I have to see if there's a nicer way to arrange things, but it looks good.

What I'd like is a better way to automatically configure "divide is
slow" from an architecture.
