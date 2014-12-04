Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbaLDPjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:39:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:51974 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaLDPjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:39:39 -0500
Date: Thu, 4 Dec 2014 15:39:38 +0000
From: Thomas Graf <tgraf@suug.ch>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Where exactly will arch_fast_hash be used
Message-ID: <20141204153938.GC32140@casper.infradead.org>
References: <20141204081147.GA19030@gondor.apana.org.au>
 <20141204152637.GA32140@casper.infradead.org>
 <20141204152929.GA22075@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204152929.GA22075@gondor.apana.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/14 at 11:29pm, Herbert Xu wrote:
> On Thu, Dec 04, 2014 at 03:26:37PM +0000, Thomas Graf wrote:
> >
> > As Daniel pointed out, this work originated for the OVS edge use
> > case where security is of less concern and the rehashing is
> > sufficient. Identifying collisions is less of interest as the user
> > space fall back provides a greater surface for an attack.
> 
> Well in that case the current setup I think is very misleading.
> It's inviting unsuspecting kernel developers to use it as a hash
> function for general hash tables, which AFAICS is something that
> it fails at miserably.

Well, it's called fast hash and not secure hash ;-) but a clear hint
definitely wouldn't hurt.

I wasn't aware of the distribution weakness of the lower bits. Do
you have a reference to more information?
