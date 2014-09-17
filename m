Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaIQJao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:30:44 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:56502 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaIQJan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:30:43 -0400
Date: Wed, 17 Sep 2014 17:30:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Amos Kong <akong@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, m@bues.ch,
        mb@bu3sch.de, mpm@selenic.com, rusty@rustcorp.com.au,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] fix stuck in accessing hwrng attributes
Message-ID: <20140917093004.GB1213@gondor.apana.org.au>
References: <1410796949-2221-1-git-send-email-akong@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410796949-2221-1-git-send-email-akong@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 12:02:26AM +0800, Amos Kong wrote:
> If we read hwrng by long-running dd process, it takes too much cpu
> time and almost hold the mutex lock. When we check hwrng attributes
> from sysfs by cat, it gets stuck in waiting the lock releaseing.
> The problem can only be reproduced with non-smp guest with slow backend.
> 
> This patchset resolves the issue by changing rng_dev_read() to always
> schedule 10 jiffies after release mutex lock, then cat process can
> have chance to get the lock and execute protected code without stuck.

Sorry I'm not going to accept your fix which simply papers over
the problem.

Please bite the bullet and convert this over to RCU.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
