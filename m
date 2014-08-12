Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbaHLHzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:55:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbaHLHzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:55:22 -0400
Date: Tue, 12 Aug 2014 13:24:33 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, Amos Kong <akong@redhat.com>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [3.16 stable PATCH 1/2] virtio: rng: delay hwrng_register() till
 driver is ready
Message-ID: <20140812075433.GN4184@grmbl.mre>
References: <76f5c012de1f6adeb1f8c105db5dc21a6e99fbc4.1407827215.git.amit.shah@redhat.com>
 <20140812074135.GB22911@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812074135.GB22911@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 12 Aug 2014 [15:41:35], Greg KH wrote:
> On Tue, Aug 12, 2014 at 12:36:54PM +0530, Amit Shah wrote:
> > Instead of calling hwrng_register() in the probe routing, call it in the
> > scan routine.  This ensures that when hwrng_register() is successful,
> > and it requests a few random bytes to seed the kernel's pool at init,
> > we're ready to service that request.
> > 
> > This will also enable us to remove the workaround added previously to
> > check whether probe was completed, and only then ask for data from the
> > host.  The revert follows in the next commit.
> > 
> > There's a slight behaviour change here on unsuccessful hwrng_register().
> > Previously, when hwrng_register() failed, the probe() routine would
> > fail, and the vqs would be torn down, and driver would be marked not
> > initialized.  Now, the vqs will remain initialized, driver would be
> > marked initialized as well, but won't be available in the list of RNGs
> > available to hwrng core.  To fix the failures, the procedure remains the
> > same, i.e. unload and re-load the module, and hope things succeed the
> > next time around.
> > 
> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > (cherry picked from commit 5c06273401f2eb7b290cadbae18ee00f8f65e893)
> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > 
> > Conflicts:
> > 	drivers/char/hw_random/virtio-rng.c
> > 
> >   Context conflict due to not backporting two commits that changed
> >   struct layout.
> 
> What is this "Conflicts:" stuff for?  I don't need that...

To note the patch didn't cherry-pick as-is; anyway, sent a v2 without
that text.

Thanks,
		Amit
