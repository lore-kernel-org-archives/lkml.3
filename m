Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaKXMD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:03:29 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:34446 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaKXMDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:03:25 -0500
MIME-Version: 1.0
In-Reply-To: <1416829787-14252-5-git-send-email-mst@redhat.com>
References: <1416829787-14252-1-git-send-email-mst@redhat.com>
	<1416829787-14252-5-git-send-email-mst@redhat.com>
Date: Mon, 24 Nov 2014 13:03:24 +0100
X-Google-Sender-Auth: _dSoPuhVqYbwiHy17fXKocV0p20
Message-ID: <CAMuHMdWiCqbaOs-oBW3QU+_d3GsH19A2Ynv9EB_eF2sTvcWy4w@mail.gmail.com>
Subject: Re: [PATCH v3 04/41] virtio: memory access APIs
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, Nicholas Bellinger <nab@linux-iscsi.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        Anup Patel <anup.patel@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
        stephen hemminger <stephen@networkplumber.org>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 12:52 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> virtio 1.0 makes all memory structures LE, so
> we need APIs to conditionally do a byteswap on BE
> architectures.
>
> To make it easier to check code statically,
> add virtio specific types for multi-byte integers
> in memory.
>
> Add low level wrappers that do a byteswap conditionally, these will be
> useful e.g. for vhost.  Add high level wrappers that
> query device endian-ness and act accordingly.

> diff --git a/include/linux/virtio_byteorder.h b/include/linux/virtio_byteorder.h
> new file mode 100644
> index 0000000..824ed0b
> --- /dev/null
> +++ b/include/linux/virtio_byteorder.h

> +static inline u16 __virtio16_to_cpu(bool little_endian, __virtio16 val)
> +{
> +       if (little_endian)
> +               return le16_to_cpu((__force __le16)val);
> +       else
> +               return (__force u16)val;
> +}

What's wrong with just using le16-to_cpu() ...

> --- a/include/uapi/linux/virtio_ring.h
> +++ b/include/uapi/linux/virtio_ring.h

>  /* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
>  struct vring_desc {
>         /* Address (guest-physical). */
> -       __u64 addr;
> +       __virtio64 addr;

... and __le64?

There's already lots of precedence or this, even in include/uapi/.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
