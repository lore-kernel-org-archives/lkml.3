Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaKGN0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:26:13 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:51374 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaKGN0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:26:10 -0500
Date: Fri, 7 Nov 2014 21:25:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org, nakam@linux-ipv6.org,
        yoshfuji@linux-ipv6.org
Subject: [PATCH 0/2] ipv4: Simplify raw_probe_proto_opt and avoid reading
 user iov twice
Message-ID: <20141107132553.GA20190@gondor.apana.org.au>
References: <20141106055023.GA28865@gondor.apana.org.au>
 <20141106064318.GW7996@ZenIV.linux.org.uk>
 <20141106064629.GA29321@gondor.apana.org.au>
 <20141106.162808.1546139916210194279.davem@davemloft.net>
 <20141107020025.GC9101@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107020025.GC9101@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave:

This series rewrites the function raw_probe_proto_opt in a more
readable fasion, and then fixes the long-standing bug where we
read the probed bytes twice which means that what we're using to
probe may in fact be invalid.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
