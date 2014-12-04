Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaLDP3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:29:47 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:39237 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaLDP3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:29:45 -0500
Date: Thu, 4 Dec 2014 23:29:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Graf <tgraf@suug.ch>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Where exactly will arch_fast_hash be used
Message-ID: <20141204152929.GA22075@gondor.apana.org.au>
References: <20141204081147.GA19030@gondor.apana.org.au>
 <20141204152637.GA32140@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204152637.GA32140@casper.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 03:26:37PM +0000, Thomas Graf wrote:
>
> As Daniel pointed out, this work originated for the OVS edge use
> case where security is of less concern and the rehashing is
> sufficient. Identifying collisions is less of interest as the user
> space fall back provides a greater surface for an attack.

Well in that case the current setup I think is very misleading.
It's inviting unsuspecting kernel developers to use it as a hash
function for general hash tables, which AFAICS is something that
it fails at miserably.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
