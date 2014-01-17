Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaAQJWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:22:40 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54471 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaAQJWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:22:36 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 17 Jan 2014 01:22:28 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: gcc tickets for sparse attributes
Message-ID: <20140117092223.GC577@leaf>
References: <52D8BF2C.9090604@zytor.com>
 <1389947596.4354.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389947596.4354.2.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 09:33:16AM +0100, Johannes Berg wrote:
> On Thu, 2014-01-16 at 21:27 -0800, H. Peter Anvin wrote:
> 
> > However, I would also like support for the context extensions, but I'm
> > not knowledgeable enough to describe the semantics accurately.  Would
> > anyone be willing to file a ticket describing how the context extension
> > works well enough that it could be implemented?
> 
> IMHO the context extension doesn't work well enough in sparse to
> document and implement as is. It would be much better if it actually was
> able to differentiate between contexts, rather than treating each one
> the same.

That would certainly be nice, but that's something actually much more
easily done in GCC than in Sparse, given the types of information GCC
already has available to implement features like alias analysis.

In any case, the spec I wrote up assumes a distinction between contexts,
but allows for an initial implementation like Sparse's that ignores the
distinction.

> This would avoid the problem that locking one lock and
> unlocking another (in the kernel's __acquire/ __release mechanism) could
> still result in a warning.

That would actually *not* produce a warning, though it should.  In
general, I *think* an implementation like Sparse's that ignores the
distinction between locks should produce false negatives but not false
positives.

- Josh Triplett
