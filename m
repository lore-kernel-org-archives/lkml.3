Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaGGFyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 01:54:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbaGGFy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 01:54:27 -0400
Date: Mon, 7 Jul 2014 11:23:52 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jason Cooper <jason@lakedaemon.net>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] hwrng: fetch randomness only after device init
Message-ID: <20140707055352.GB27024@grmbl.mre>
References: <cover.1404538109.git.amit.shah@redhat.com>
 <515a12ecc5fca5452bf0bfda4d54546d8fb5829c.1404538109.git.amit.shah@redhat.com>
 <CAGXu5j+j1LUv_rRpf=03nRfu=Sek5O8TUs8R066JvfbUgT9ZQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+j1LUv_rRpf=03nRfu=Sek5O8TUs8R066JvfbUgT9ZQQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Sun) 06 Jul 2014 [21:41:47], Kees Cook wrote:
> On Fri, Jul 4, 2014 at 10:34 PM, Amit Shah <amit.shah@redhat.com> wrote:
> > Commit d9e7972619334 "hwrng: add randomness to system from rng sources"
> > added a call to rng_get_data() from the hwrng_register() function.
> > However, some rng devices need initialization before data can be read
> > from them.
> >
> > This commit makes the call to rng_get_data() depend on no init fn
> > pointer being registered by the device.  If an init function is
> > registered, this call is made after device init.
> 
> Thanks, this seems pretty reasonable. One side-effect is that cycling
> between hwrngs via sysfs (when they have init functions) will cause
> them to add more entropy. I don't think this is a problem, but it is
> kind of a weird side-effect.

Yes, agreed.  Having a per-device bool that indicates whether the
initial randomness is obtained is quite a heavy solution for this
side-effect.  But I can put this in the commit log so it's clear..

> Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks!

		Amit
