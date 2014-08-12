Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaHLFcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:32:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbaHLFcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:32:46 -0400
Date: Tue, 12 Aug 2014 11:01:58 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, Amos Kong <akong@redhat.com>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [3.16 stable PATCH 1/1] virtio-rng: fix multi-device startup
Message-ID: <20140812053158.GJ4184@grmbl.mre>
References: <5ef3aa4ea1932b7655d9db5a0139b8a2922af0db.1407760907.git.amit.shah@redhat.com>
 <20140811225527.GB10721@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811225527.GB10721@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 12 Aug 2014 [06:55:27], Greg KH wrote:
> On Mon, Aug 11, 2014 at 06:11:47PM +0530, Amit Shah wrote:
> > This is a 3.16-only patch.  The linux.git fix is
> > 5c06273401f2eb7b290cadbae18ee00f8f65e893, which fixes this issue in a
> > different way.
> 
> Why "different"?  Why can't I take that original patch instead?  What is
> different in this patch, and why?

The commit referenced moves the hwrng_register() call to the ->scan()
callback instead of it being in probe().  This was done to ensure the
virtio-rng devices can contribute to the initial system entropy
introduced in commit d9e7972619334.

That patch is quite small too, but will need a slight conflict
resolution due to the previous two code-shuffling patches, and also
the following revert.

However, I decided against the backport of the ->scan() method, since
it wasn't designed to solve this regression, it happens to solve it,
and it actually introduces new functionality.  I would be happy to
provide a backport of the relevant patches, if you think that would be
alright.

Thanks,

		Amit
