Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaKJG6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:58:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57130 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaKJG6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:58:22 -0500
Date: Mon, 10 Nov 2014 06:58:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org, mst@redhat.com
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
Message-ID: <20141110065817.GG7996@ZenIV.linux.org.uk>
References: <20141107221114.GB7996@ZenIV.linux.org.uk>
 <20141107234253.GE7996@ZenIV.linux.org.uk>
 <20141109211908.GF7996@ZenIV.linux.org.uk>
 <20141110.002020.1062493586889118565.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110.002020.1062493586889118565.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 12:20:20AM -0500, David Miller wrote:
> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Sun, 9 Nov 2014 21:19:08 +0000
> 
> > 1) does sparc64 access_ok() need to differ for 32bit and 64bit tasks?
> 
> sparc64 will just fault no matter what kind of task it is.
> 
> It is impossible for a user task to generate a reference to
> a kernel virtual address, as kernel and user accesses each
> go via a separate address space identifier.

Sure, but why do we have access_ok() there at all?  I.e. why not just have
it constant 1?
