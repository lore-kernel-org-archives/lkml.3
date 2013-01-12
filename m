Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3ALBRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 20:17:33 -0500
Received: from ozlabs.org ([203.10.76.45]:33619 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab3ALBRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 20:17:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjurbren@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [RFCv2 00/12] Introduce host-side virtio queue and CAIF Virtio.
In-Reply-To: <CAJK669Zw1kZkJCS_Bs=emWtofj69m4XFDaNRhqY9DMdbi4MwZA@mail.gmail.com>
References: <871ug75vp1.fsf@rustcorp.com.au> <1354718230-4486-1-git-send-email-sjur@brendeland.net> <20121206102750.GF10837@redhat.com> <877goc0wac.fsf@rustcorp.com.au> <CAJK669bP41oBhJ=MB64NS21Ag7XO5WswuTiVKCFTb96nvmyBiw@mail.gmail.com> <87pq1f2rj0.fsf@rustcorp.com.au> <87wqvl1g9s.fsf@rustcorp.com.au> <CAJK669Z-bGTeQe8qJpTJP7simbSvQ8cgFZefs5QRMkmxtFYY4g@mail.gmail.com> <87pq1c1uj4.fsf@rustcorp.com.au> <877gnk1ayv.fsf@rustcorp.com.au> <CAJK669Zw1kZkJCS_Bs=emWtofj69m4XFDaNRhqY9DMdbi4MwZA@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sat, 12 Jan 2013 10:56:16 +1030
Message-ID: <871udr1c2f.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sjur Brændeland <sjurbren@gmail.com> writes:
> How do you see the in-kernel API for this? I would like to see
> something similar to my previous patches, where we extend
> the virtqueue API. E.g. something like this:

> struct virtqueue *vring_new_virtqueueh(unsigned int index,
> 				       unsigned int num,
> 				       unsigned int vring_align,
> 				       struct virtio_device *vdev,
> 				       bool weak_barriers,
> 				       void *pages,
> 				       void (*notify)(struct virtqueue *),
> 				       void (*callback)(struct virtqueue *),
> 				       const char *name);

I was just going to create _kernel variants of all the _user helpers,
and let you drive it directly like that.

If we get a second in-kernel user, we create wrappers (I'd prefer not to
overload struct virtqueue though).

Cheers,
Rusty.
