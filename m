Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaKFGnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 01:43:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45443 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKFGnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 01:43:23 -0500
Date: Thu, 6 Nov 2014 06:43:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org,
        Masahide Nakamura <nakam@linux-ipv6.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: ipv4: Use standard iovec primitive in raw_probe_proto_opt
Message-ID: <20141106064318.GW7996@ZenIV.linux.org.uk>
References: <20141105035536.GO7996@ZenIV.linux.org.uk>
 <20141105.155054.2198151263164321219.davem@davemloft.net>
 <20141105210745.GT7996@ZenIV.linux.org.uk>
 <20141105.165719.835728206041332333.davem@davemloft.net>
 <20141106032533.GU7996@ZenIV.linux.org.uk>
 <20141106055023.GA28865@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106055023.GA28865@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 01:50:23PM +0800, Herbert Xu wrote:
> +	/* We only need the first two bytes. */
> +	err = memcpy_fromiovecend((void *)&icmph, msg->msg_iov, 0, 2);
> +	if (err)
> +		return err;
> +
> +	fl4->fl4_icmp_type = icmph.type;
> +	fl4->fl4_icmp_code = icmph.code;

That's more readable, but that exposes another problem in there - we read
the same piece of userland data twice, with no promise whatsoever that we'll
get the same value both times...
