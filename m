Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaKXKRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:17:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39494 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaKXKRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:17:53 -0500
Date: Mon, 24 Nov 2014 10:17:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@infradead.org
Subject: Re: [PATCH 17/17] rds: switch rds_message_copy_from_user() to
 iov_iter
Message-ID: <20141124101750.GF7996@ZenIV.linux.org.uk>
References: <20141119.165340.2162829993279387495.davem@davemloft.net>
 <20141120214753.GR7996@ZenIV.linux.org.uk>
 <20141120.182339.972861702759954603.davem@davemloft.net>
 <20141121.122615.1091044030302005883.davem@davemloft.net>
 <20141122042856.GZ7996@ZenIV.linux.org.uk>
 <20141122043920.GQ30478@ZenIV.linux.org.uk>
 <1416794418.7215.74.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416794418.7215.74.camel@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 02:00:18AM +0000, Ben Hutchings wrote:
> On Sat, 2014-11-22 at 04:39 +0000, Al Viro wrote:
> [...]
> > -		ret = rds_page_copy_from_user(sg_page(sg), sg->offset + sg_off,
> > -					      iov->iov_base + iov_off,
> > -					      to_copy);
> [...]
> 
> It looks like rds_page_copy{,_from,_to}_user() are all unused after this
> change, so you could delete them.

Maybe.  Or maybe add a saner wrapper for rds_page_copy_from_user()...  Separate
story, anyway.
