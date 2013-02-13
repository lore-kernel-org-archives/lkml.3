Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288Ab3BMMuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:50:44 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48303 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab3BMMun convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:50:43 -0500
MIME-Version: 1.0
In-Reply-To: <87ehgklds9.fsf@rustcorp.com.au>
References: <1360494273-27889-1-git-send-email-sjur.brandeland@stericsson.com>
	<1360494273-27889-3-git-send-email-sjur.brandeland@stericsson.com>
	<87vc9zfic8.fsf@rustcorp.com.au>
	<81C3A93C17462B4BBD7E272753C105792458EDD161@EXDCVYMBSTM005.EQ1STM.local>
	<87ehgklds9.fsf@rustcorp.com.au>
Date: Wed, 13 Feb 2013 13:50:41 +0100
Message-ID: <CAJK669YQ+x5zXSZA1FQHkRrcCt+SgZP-M_ea-Ey8ziGLhq9cqQ@mail.gmail.com>
Subject: Re: [PATCH vringh 2/2] caif_virtio: Introduce caif over virtio
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "David S. Miller" <davem@davemloft.net>, Ohad Ben-Cohen <ohad@wizery.com>,
        Vikram ARV <vikram.arv@stericsson.com>,
        Dmitry TARNYAGIN <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Erwan YVIN <erwan.yvin@stericsson.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Wed, Feb 13, 2013 at 11:16 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Sjur BRENDELAND <sjur.brandeland@stericsson.com> writes:
>>> > +static inline void ctx_prep_iov(struct cfv_napi_context *ctx)
>>> > +{
>>> > +  if (ctx->riov.allocated) {
>>> > +          kfree(ctx->riov.iov);
>>> > +          ctx->riov.iov = NULL;
>>> > +          ctx->riov.allocated = false;
>>> > +  }
>>> > +  ctx->riov.iov = NULL;
>>> > +  ctx->riov.i = 0;
>>> > +  ctx->riov.max = 0;
>>> > +}
>>>
>>> Hmm, we should probably make sure you don't have to do this: that if
>>> allocated once, you can simply reuse it by setting i = 0.
>>
>> Yes, I had problems getting the alloc/free of iov right. This is
>> perhaps the least intuitively part of the API. I maybe it's just me, but
>> I think some more helper functions and support from vringh in this
>> area would be great.
>
> Yes, I've neatened my git tree, an in particular added a commit which
> covers this explicitly, and one for the -EPROTO when we get unexpected
> r/w bufs.  I've appended them below.

Great, thanks. This helps a lot. I picked up your patch-sett yesterday
so my V2 patch-set is using this already.
...
> +static inline void vringh_iov_init(struct vringh_iov *iov,
> +                                  struct iovec *iovec, unsigned num)
> +{
> +       iov->used = iov->i = 0;
> +       iov->off = 0;
> +       iov->max_num = num;
> +       iov->iov = iovec;
> +}

How about supporting struct vringh_kiov and struct kvec as well?
I currently get the following complaints with my V2 patch-set:

drivers/net/caif/caif_virtio.c:486:2: warning: passing argument 1 of
‘vringh_iov_init’ from incompatible pointer type [enabled by default]
...

Thanks,
Sjur
