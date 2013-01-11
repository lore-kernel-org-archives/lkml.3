Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab3AKPCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 10:02:25 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:40969 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab3AKPCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 10:02:23 -0500
MIME-Version: 1.0
In-Reply-To: <877gnk1ayv.fsf@rustcorp.com.au>
References: <871ug75vp1.fsf@rustcorp.com.au>
	<1354718230-4486-1-git-send-email-sjur@brendeland.net>
	<20121206102750.GF10837@redhat.com>
	<877goc0wac.fsf@rustcorp.com.au>
	<CAJK669bP41oBhJ=MB64NS21Ag7XO5WswuTiVKCFTb96nvmyBiw@mail.gmail.com>
	<87pq1f2rj0.fsf@rustcorp.com.au>
	<87wqvl1g9s.fsf@rustcorp.com.au>
	<CAJK669Z-bGTeQe8qJpTJP7simbSvQ8cgFZefs5QRMkmxtFYY4g@mail.gmail.com>
	<87pq1c1uj4.fsf@rustcorp.com.au>
	<877gnk1ayv.fsf@rustcorp.com.au>
Date: Fri, 11 Jan 2013 16:02:22 +0100
Message-ID: <CAJK669Zw1kZkJCS_Bs=emWtofj69m4XFDaNRhqY9DMdbi4MwZA@mail.gmail.com>
Subject: Re: [RFCv2 00/12] Introduce host-side virtio queue and CAIF Virtio.
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 7:37 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>virtio_host: host-side implementation of virtio rings (untested!)
>
>Getting use of virtio rings correct is tricky, and a recent patch saw
>an implementation of in-kernel rings (as separate from userspace).

How do you see the in-kernel API for this? I would like to see
something similar to my previous patches, where we extend
the virtqueue API. E.g. something like this:

struct virtqueue *vring_new_virtqueueh(unsigned int index,
				       unsigned int num,
				       unsigned int vring_align,
				       struct virtio_device *vdev,
				       bool weak_barriers,
				       void *pages,
				       void (*notify)(struct virtqueue *),
				       void (*callback)(struct virtqueue *),
				       const char *name);

int virtqueueh_get_iov(struct virtqueue *vqh,
		       struct vringh_iov *riov,
		       struct vringh_iov *wiov,
		       gfp_t gfp);

int virtqueueh_add_iov(struct virtqueue *vqh,
		       struct vringh_iov *riov,
		       struct vringh_iov *wiov);

I guess implementation of the host-virtqueue should stay in drivers/virtio?

Regards,
Sjur
