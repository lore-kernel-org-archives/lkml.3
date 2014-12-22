Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaLVMFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 07:05:37 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:53465 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaLVMFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 07:05:35 -0500
Date: Mon, 22 Dec 2014 23:05:16 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Amos Kong <akong@redhat.com>
Cc: linux-crypto@vger.kernel.org, virtualization@lists.linux-foundation.org,
        rusty@rustcorp.com.au, kvm@vger.kernel.org, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 REPOST 0/6] fix hw_random stuck
Message-ID: <20141222120515.GD21045@gondor.apana.org.au>
References: <1418028640-4891-1-git-send-email-akong@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418028640-4891-1-git-send-email-akong@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 04:50:34PM +0800, Amos Kong wrote:
> When I hotunplug a busy virtio-rng device or try to access
> hwrng attributes in non-smp guest, it gets stuck.
> 
> My hotplug tests:
> 
> | test 0:
> |   hotunplug rng device from qemu monitor
> |
> | test 1:
> |   guest) # dd if=/dev/hwrng of=/dev/null &
> |   hotunplug rng device from qemu monitor
> |
> | test 2:
> |   guest) # dd if=/dev/random of=/dev/null &
> |   hotunplug rng device from qemu monitor
> |
> | test 4:
> |   guest) # dd if=/dev/hwrng of=/dev/null &
> |   cat /sys/devices/virtual/misc/hw_random/rng_*
> |
> | test 5:
> |   guest) # dd if=/dev/hwrng of=/dev/null
> |   cancel dd process after 10 seconds
> |   guest) # dd if=/dev/hwrng of=/dev/null &
> |   hotunplug rng device from qemu monitor
> |
> | test 6:
> |   use a fifo as rng backend, execute test 0 ~ 5 with no input of fifo

All applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
