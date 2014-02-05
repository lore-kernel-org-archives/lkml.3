Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbaBEUmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:42:43 -0500
Received: from mx5.gridway.net ([72.1.205.140]:36101 "EHLO mx5.gridway.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932441AbaBEUmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:42:38 -0500
X-Greylist: delayed 721 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Feb 2014 15:42:37 EST
Date: Wed, 5 Feb 2014 15:30:27 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v2.6.34-stable 004/213] crypto: ghash - Avoid null pointer
 dereference if no key is set
Message-ID: <20140205203027.GA23845@elliptictech.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
 <1391630568-49251-5-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1391630568-49251-5-git-send-email-paul.gortmaker@windriver.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [209.217.122.41]
X-Spam-Score: undef - 72.1.205.180 is whitelisted.
X-CanIt-Geo: ip=72.1.205.180; country=CA; region=ON; city=Ottawa; latitude=45.4167; longitude=-75.7000; http://maps.google.com/maps?q=45.4167,-75.7000&z=6
X-CanItPRO-Stream: base:outbound (inherits from base:default)
X-Canit-Stats-ID: Bayes signature not available
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-05 14:59 -0500, Paul Gortmaker wrote:
> From: Nick Bowler <nbowler@elliptictech.com>
> 
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
> 
> commit 7ed47b7d142ec99ad6880bbbec51e9f12b3af74c upstream.
> 
> The ghash_update function passes a pointer to gf128mul_4k_lle which will
> be NULL if ghash_setkey is not called or if the most recent call to
> ghash_setkey failed to allocate memory.  This causes an oops.  Fix this
> up by returning an error code in the null case.
> 
> This is trivially triggered from unprivileged userspace through the
> AF_ALG interface by simply writing to the socket without setting a key.

After all this time, I see this patch still manages to find its way,
occasionally, into the patch queue for older -stable. :)

It should be harmless to apply, but this patch doesn't actually fix
any real problem on kernels previous to 2.6.38 because the AF_ALG
userspace interface does not exist in these kernels.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
