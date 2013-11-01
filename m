Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3KAT7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:59:08 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55661 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab3KAT7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:59:06 -0400
Date: Fri, 1 Nov 2013 15:58:50 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Doug Ledford <dledford@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131101195850.GD8467@hmsreliant.think-freely.org>
References: <201310300525.r9U5Pdqo014902@ib.usersys.redhat.com>
 <20131030110214.GA10220@localhost.localdomain>
 <52710B09.6090302@redhat.com>
 <20131031183003.GC25894@hmsreliant.think-freely.org>
 <1383320566.1737.0.camel@bwh-desktop.uk.level5networks.com>
 <20131101160802.GB8467@hmsreliant.think-freely.org>
 <AE90C24D6B3A694183C094C60CF0A2F6026B73D3@saturn3.aculab.com>
 <20131101173701.GC8467@hmsreliant.think-freely.org>
 <1383335129.3042.10.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383335129.3042.10.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 12:45:29PM -0700, Joe Perches wrote:
> On Fri, 2013-11-01 at 13:37 -0400, Neil Horman wrote:
> 
> > I think it would be better if we just did the prefetch here
> > and re-addressed this area when AVX (or addcx/addox) instructions were available
> > for testing on hardware.
> 
> Could there be a difference if only a single software
> prefetch was done at the beginning of transfer before
> the while loop and hardware prefetches did the rest?
> 

I wouldn't think so.  If hardware was going to do any prefetching based on
memory access patterns it will do so regardless of the leading prefetch, and
that first prefetch isn't helpful because we still wind up stalling on the adds
while its completing
Neil

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
