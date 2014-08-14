Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaHNSvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 14:51:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbaHNSvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 14:51:44 -0400
Date: Fri, 15 Aug 2014 02:51:28 +0800
From: Amos Kong <akong@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, hpa@linux.intel.com,
        ricardo.neri-calderon@linux.intel.com, tytso@mit.edu,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio: rng: add derating factor for use by hwrng core
Message-ID: <20140814185128.GA1894@z.redhat.com>
References: <87zjf88awc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjf88awc.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 04:39:07AM +0930, Rusty Russell wrote:
> The khwrngd thread is started when a hwrng device of sufficient
> quality is registered.  The virtio-rng device is backed by the
> hypervisor, and we trust the hypervisor to provide real entropy.
> 
> A malicious hypervisor is a scenario that's irrelevant -- such a setup
> is bound to cause all sorts of badness, and a compromised hwrng is not
> the biggest threat.
> 
> Given this, we are certain the quality of randomness we receive is
> perfectly trustworthy.  Hence, we use 100% for the factor, indicating
> maximum confidence in the source.
> 
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>


Reviewed-by: Amos Kong <akong@redhat.com>

> ---
> Pretty small and contained patch; would be great if it is picked up for
> 3.17.
> 
> v2: re-word commit msg
> 
> [Agreed, re-sending to Linus with SOB before jumping on plane]
> ---
>  drivers/char/hw_random/virtio-rng.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/char/hw_random/virtio-rng.c
> b/drivers/char/hw_random/virtio-rng.c
> index 0027137..2e3139e 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -116,6 +116,7 @@ static int probe_common(struct virtio_device *vdev)
> 		.cleanup = virtio_cleanup,
> 		.priv = (unsigned long)vi,
> 		.name = vi->name,
> +		.quality = 1000,
> 	};
> 	vdev->priv = vi;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
			Amos.
