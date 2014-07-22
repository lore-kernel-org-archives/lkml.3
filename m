Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbaGVRJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 13:09:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbaGVRJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 13:09:31 -0400
Date: Tue, 22 Jul 2014 22:38:34 +0530
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@lakedaemon.net,
        Amos Kong <akong@redhat.com>
Subject: Re: [PATCH v2 3/4] virtio: rng: delay hwrng_register() till driver
 is ready
Message-ID: <20140722170834.GA23129@grmbl.mre>
References: <cover.1405942162.git.amit.shah@redhat.com>
 <91cb7c5b87cf2ba5ef1bacd55a7ee7bc827293a2.1405942162.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91cb7c5b87cf2ba5ef1bacd55a7ee7bc827293a2.1405942162.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 21 Jul 2014 [17:15:51], Amit Shah wrote:
> Instead of calling hwrng_register() in the probe routing, call it in the
> scan routine.  This ensures that when hwrng_register() is successful,
> and it requests a few random bytes to seed the kernel's pool at init,
> we're ready to service that request.
> 
> This will also enable us to remove the workaround added previously to
> check whether probe was completed, and only then ask for data from the
> host.  The revert follows in the next commit.
> 
> There's a slight behaviour change here on unsuccessful hwrng_register().
> Previously, when hwrng_unregister() failed, the probe() routine would

typo: should be hwrng_register().

Please fix this up when picking up the patch.

Thanks,

> fail, and the vqs would be torn down, and driver would be marked not
> initialized.  Now, the vqs will remain initialized, driver would be
> marked initialized as well, but won't be available in the list of RNGs
> available to hwrng core.  To fix the failures, the procedure remains the
> same, i.e. unload and re-load the module, and hope things succeed the
> next time around.
> 
> Signed-off-by: Amit Shah <amit.shah@redhat.com>

		Amit
