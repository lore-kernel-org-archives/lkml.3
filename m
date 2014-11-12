Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaKLErs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:47:48 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:58711 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaKLErq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:47:46 -0500
Date: Wed, 12 Nov 2014 12:47:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Amos Kong <akong@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        rusty@rustcorp.com.au, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/6] hw_random: fix unregister race.
Message-ID: <20141112044725.GA24812@gondor.apana.org.au>
References: <1415030186-18303-1-git-send-email-akong@redhat.com>
 <1415030186-18303-5-git-send-email-akong@redhat.com>
 <20141110134727.GA8578@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141110134727.GA8578@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 09:47:27PM +0800, Herbert Xu wrote:
> On Mon, Nov 03, 2014 at 11:56:24PM +0800, Amos Kong wrote:
> >
> > @@ -98,6 +99,8 @@ static inline void cleanup_rng(struct kref *kref)
> >  
> >  	if (rng->cleanup)
> >  		rng->cleanup(rng);
> 
> You need a compiler barrier here to prevent reordering.

Michael Büsch pointed out that we should actually have a memory
barrier here.  I thought we didn't need it because I was only
worried about the code in my original complaint.  However, expecting
driver writers to use correct synchronisation primitives is surely
asking too much.

So let's add an smp_wmb() here to ensure all side-effects of
cleanup is visible.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
