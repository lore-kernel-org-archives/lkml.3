Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaELSwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:52:08 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:35409 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaELSwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:52:07 -0400
Message-ID: <1399920710.4337.26.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/1] net/wireless/ibss.c: replace memcpy by
 ether_addr_copy
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        akpm <akpm@linux-foundation.org>
Date: Mon, 12 May 2014 20:51:50 +0200
In-Reply-To: <1399918029.9240.19.camel@joe-AO725>
References: <20140512193050.1ba6a301b20af3f4e7e43870@skynet.be>
	 <1399917025.9240.16.camel@joe-AO725>
	 <20140512200033.87712053add71ca2cf35fe79@skynet.be>
	 <1399918029.9240.19.camel@joe-AO725>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-12 at 11:07 -0700, Joe Perches wrote:
> On Mon, 2014-05-12 at 20:00 +0200, Fabian Frederick wrote:
> > On Mon, 12 May 2014 10:50:25 -0700
> > Joe Perches <joe@perches.com> wrote:
> > 
> > > On Mon, 2014-05-12 at 19:30 +0200, Fabian Frederick wrote:
> > > > This patch also fixes some comment checkpatch warnings
> > > 
> > > Hello Fabian.
> > > 
> > > For all the patches that replace memcpy(foo, bar, ETH_ALEN)
> > > with ether_addr_copy, did you use a tool to verify both
> > > arguments are __aligned(2) or did you do the verification
> > > visually?
> > 
> > Hello Joe,
> > 
> > I only replaced ETH_ALEN/memcpy .
> > AFAICS ETH_ALEN is defined 6 ...
> 
> The difference here is that both arguments to
> ether_addr_copy, like all the is_<foo>_ether_addr
> helpers, must be __aligned(2).  memcpy has
> no alignment requirement.
> 
> Please verify that all these changes are to
> __aligned(2) arguments.

Seriously though, who cares. Only two of these patches really touch
paths where performance matters - and one of those is the lib80211 one
which is practically only used for certain ancient Intel devices, which
probably don't run on anything but IA where I'd guess the whole thing
doesn't really matter anyway.

I certainly don't see the benefit in changing all those other files,
particularly since it's not just that we have to verify alignment *now*,
we also have to add alignment attributes so that we don't break
alignment in the future.

Additionally doesn't even really save much typing:

memcpy(x, y, ETH_ALEN);
ether_addr_copy(x, y);

Finally, some of these patches are doing comment reformatting, which
clearly is out of scope for them.

As a consequence, I'm considering the net/wireless/util.c one, but none
of the others.

johannes

