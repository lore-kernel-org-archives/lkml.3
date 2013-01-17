Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3ASAZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 19:25:43 -0500
Received: from ozlabs.org ([203.10.76.45]:52372 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab3ASAZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 19:25:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [RFCv2 00/12] Introduce host-side virtio queue and CAIF Virtio.
In-Reply-To: <87k3rcy2y2.fsf@rustcorp.com.au>
References: <20121206102750.GF10837@redhat.com> <877goc0wac.fsf@rustcorp.com.au> <CAJK669bP41oBhJ=MB64NS21Ag7XO5WswuTiVKCFTb96nvmyBiw@mail.gmail.com> <87pq1f2rj0.fsf@rustcorp.com.au> <87wqvl1g9s.fsf@rustcorp.com.au> <CAJK669Z-bGTeQe8qJpTJP7simbSvQ8cgFZefs5QRMkmxtFYY4g@mail.gmail.com> <87pq1c1uj4.fsf@rustcorp.com.au> <877gnk1ayv.fsf@rustcorp.com.au> <20130114173914.GB19207@redhat.com> <874nihzuoz.fsf@rustcorp.com.au> <20130116081606.GB11465@redhat.com> <87k3rcy2y2.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 17 Jan 2013 21:05:49 +1030
Message-ID: <87d2x4xfju.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
>> On Wed, Jan 16, 2013 at 01:43:32PM +1030, Rusty Russell wrote:
>>> "Michael S. Tsirkin" <mst@redhat.com> writes:
>>> >> +static int resize_iovec(struct vringh_iov *iov, gfp_t gfp)
>>> >> +{
>>> >> +	struct iovec *new;
>>> >> +	unsigned int new_num = iov->max * 2;
>>> >
>>> > We must limit this I think, this is coming
>>> > from userspace. How about UIO_MAXIOV?
>>> 
>>> We limit it to the ring size already;
>>
>> 1. do we limit it in case there's a loop in the descriptor ring?

I didn't get a chance to do these revisions, as I spent today debugging
the test framework.  I won't get any more work on it until next week, so
I've posted a rough series anyway for feedback (can also be found
in my pending-rebases branch on kernel.org).

Thanks!
Rusty.
