Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab3APBar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:30:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab3APBap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:30:45 -0500
Date: Wed, 16 Jan 2013 01:29:15 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk,
        snitzer@redhat.com, agk@redhat.com, neilb@suse.de
Subject: Re: Bcache v. whatever
Message-ID: <20130116012914.GA27245@agk-dp.fab.redhat.com>
Mail-Followup-To: Kent Overstreet <koverstreet@google.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk,
	snitzer@redhat.com, agk@redhat.com, neilb@suse.de
References: <20130114223202.GV26407@google.com> <1358241656.2383.2.camel@dabdike.int.hansenpartnership.com> <20130115205912.GA26407@google.com> <1358291738.10591.23.camel@dabdike.int.hansenpartnership.com> <20130115233347.GD26407@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115233347.GD26407@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 03:33:47PM -0800, Kent Overstreet wrote:
> I haven't been active on dm-devel, besides the occasional cross
> posting... not sure what activity you're referring to on the dm list,
 
A caching framework based on dm has been proposed by Joe Thornber (the
original author of dm).

Mike Snitzer is trying to adapt the performance tests for this dm-based
framework to include the latest bcache code that you just posted to
start to give us an idea of the circumstances in which each of them work
well (or badly).

1, Caching is a complicated feature: It's easy to get no benefit or even
a negative benefit from a cache if you use an inappropriate policy or
don't tune it to your I/O patterns.

2. We now have several independent/overlapping implementations of this
type of caching.  Comparing and contrasting them should help us to tease
out the critical design elements and optimisations and decide which of
them together or separately (or some hybrid) would enable the kernel to
support the widest range of situations users require with the minimum
of code and complexity.

3. We all want to move quickly now, perhaps even with something in the
next merge window if we can or otherwise the one after that.

Alasdair

