Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935822Ab3BTQGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:06:25 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49140 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964852Ab3BTQGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:06:20 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.123.174]
In-Reply-To: <1360669793-6921-2-git-send-email-sjur.brandeland@stericsson.com>
References: <1360669793-6921-1-git-send-email-sjur.brandeland@stericsson.com> <1360669793-6921-2-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 20 Feb 2013 18:05:56 +0200
Message-ID: <CAK=Wgbb0EeiCh504jsoX+izzi+ZogfEDttz2cHRd4pVXvQunQw@mail.gmail.com>
Subject: Re: [PATCHv2 vringh 1/3] remoteproc: Add support for vringh (Host vrings)
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>,
        netdev@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Tue, Feb 12, 2013 at 1:49 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Add functions for creating, deleting and kicking host-side virtio rings.
>
> The host ring is not integrated with virtiqueues and cannot be managed
> through virtio-config.

Is that an inherent design/issue of vringh or just a description of
the current vringh code ?

> Remoteproc must export functions for handling the host-side virtio rings.

Have you considered exporting this via virtio instead ?

> The functions rproc_virtio_get_vringh(), rproc_virtio_del_vringh(),
> rproc_virtio_kick_vringh() are added to remoteproc_virtio.c.

I wonder if this is the way we want things to work.

Following this design, virtio drivers that use these rproc_* functions
will be coupled with the remoteproc framework.

One issue with this is what happens if, e.g., a VIRTIO_ID_CAIF vdev is
added by other than remoteproc (e.g. by virtio_pci or virtio_mmio).
Not sure how probable this really is, and whether there's anything
that prevents this, but things will go awry if this happens.

But maybe the important aspect to consider is whether we really want
to couple virtio drivers (such as the upcoming caif one) with the
remoteproc framework.

If you'll take a look at the rpmsg virtio driver, there's nothing
there which couples it with remoteproc. It's just a standard virtio
driver, that can be easily used with traditional virtio hosts as well.

This is possible of course thanks to the abstraction provided by
virtio: remoteproc only implements a set of callbacks which virtio
invokes when needed.

Do we not want to follow a similar design scheme with vringh ?

I have some other questions as well but maybe it's better to discuss
first the bigger picture.

Thanks!
Ohad.
