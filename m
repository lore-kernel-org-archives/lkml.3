Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaKJNr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:47:57 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:59057 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaKJNrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:47:55 -0500
Date: Mon, 10 Nov 2014 21:47:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Amos Kong <akong@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        rusty@rustcorp.com.au, m@bues.ch, mb@bu3sch.de, mpm@selenic.com,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/6] hw_random: fix unregister race.
Message-ID: <20141110134727.GA8578@gondor.apana.org.au>
References: <1415030186-18303-1-git-send-email-akong@redhat.com>
 <1415030186-18303-5-git-send-email-akong@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415030186-18303-5-git-send-email-akong@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 11:56:24PM +0800, Amos Kong wrote:
>
> @@ -98,6 +99,8 @@ static inline void cleanup_rng(struct kref *kref)
>  
>  	if (rng->cleanup)
>  		rng->cleanup(rng);

You need a compiler barrier here to prevent reordering.

> +	rng->cleanup_done = true;

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
