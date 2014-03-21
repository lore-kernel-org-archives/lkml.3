Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965720AbaCUN21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:28:27 -0400
Received: from one.firstfloor.org ([193.170.194.197]:58701 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760684AbaCUN2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:28:21 -0400
Date: Fri, 21 Mar 2014 14:28:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Patrick McHardy <kaber@trash.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H.K. Jerry Chu" <hkchu@google.com>,
        Michael Dalton <mwdalton@google.com>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] csum experts, csum_replace2() is too expensive
Message-ID: <20140321132820.GM22728@two.firstfloor.org>
References: <1395341341.9114.93.camel@edumazet-glaptop2.roam.corp.google.com>
 <87a9cknwk4.fsf@tassilo.jf.intel.com>
 <1395406250.9114.142.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395406250.9114.142.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 05:50:50AM -0700, Eric Dumazet wrote:
> On Thu, 2014-03-20 at 18:56 -0700, Andi Kleen wrote:
> > Eric Dumazet <eric.dumazet@gmail.com> writes:
> > >
> > > I saw csum_partial() consuming 1% of cpu cycles in a GRO workload, that
> > > is insane...
> > 
> > 
> > Couldn't it just be the cache miss?
> 
> Or the fact that we mix 16 bit stores and 32bit loads ?

It should cause a small stall from not doing load-store
forwarding, but 1% of a serious workload would be surprising.

Are you sure it's not some skid effect?

-Andi
