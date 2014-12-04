Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbaLDP4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:56:47 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:46994 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaLDP4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:56:46 -0500
Date: Thu, 4 Dec 2014 23:56:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: netdev@vger.kernel.org, Jay Vosburgh <jay.vosburgh@canonical.com>,
        Thomas Graf <tgraf@suug.ch>, Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] arch_fast_hash: avoid indirect function calls
 and implement hash in asm
Message-ID: <20141204155610.GA22340@gondor.apana.org.au>
References: <e77237174e1b8d743ef5171e05abde82bc54af37.1417696901.git.hannes@stressinduktion.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e77237174e1b8d743ef5171e05abde82bc54af37.1417696901.git.hannes@stressinduktion.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 02:08:50PM +0100, Hannes Frederic Sowa wrote:
> By default the arch_fast_hash hashing function pointers are initialized
> to jhash(2). If during boot-up a CPU with SSE4.2 is detected they get
> updated to the CRC32 ones. This dispatching scheme incurs a function
> pointer lookup and indirect call for every hashing operation.

Just curious, is jhash actually faster than generic C CRC32 on
common platforms?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
