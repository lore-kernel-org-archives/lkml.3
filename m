Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933AbaEFDIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:08:37 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42833 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbaEFDIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:08:34 -0400
Date: Tue, 6 May 2014 05:08:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com,
        robert.olsson@its.uu.se
Subject: Re: [PATCH 22/24] net, diet: Support simpler routing table
Message-ID: <20140506030833.GL2382@two.firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
 <1399328773-6531-23-git-send-email-andi@firstfloor.org>
 <20140505.230259.1803147080660592366.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505.230259.1803147080660592366.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 11:02:59PM -0400, David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Mon,  5 May 2014 15:26:11 -0700
> 
> > Add an optional fib_list that uses a simple list to store routes.
> > This is suitable for single homed client system which typically
> > have only a handful of routes.
> 
> Sorry I'm not applying this.
> 
> We had two routing table implementations for some time and it sucked,
> it meant two code paths and two places for bugs to hide.

FWIW it seems to me the trie code is very stable, there doesn't
seem to be any big changes in a long time.

> 
> I want only one data structure which does the job well, and we have
> that now.

I don't see any good way to slim the trie code down. Do you?

It's just inherently complex. Yes on many systems it's a good thing,
and the complexity is justified,
but on the tiny systems the bloat and code size just hurts.

If we can't get the bloat down these users will just desert us to lwip ...

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
