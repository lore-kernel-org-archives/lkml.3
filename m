Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaKFRdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:33:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46526 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaKFRdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:33:36 -0500
Date: Thu, 6 Nov 2014 17:33:33 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH 3/4] macvtap: Use iovec iterators
Message-ID: <20141106173333.GZ7996@ZenIV.linux.org.uk>
References: <20141106082704.GB29800@gondor.apana.org.au>
 <E1XmIQW-0007mb-J4@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1XmIQW-0007mb-J4@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 04:28:20PM +0800, Herbert Xu wrote:

> +		if (copy_to_iter(&vnet_hdr, sizeof(vnet_hdr), iter))
>  			return -EFAULT;

Again, wrong calling conventions.  It returns how much has it copied.

> +		ret = copy_to_iter(&veth, sizeof(veth), iter);
> +		if (ret || !iov_iter_count(iter))
>  			goto done;
Ditto.
