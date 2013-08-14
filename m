Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab3HNLxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:53:32 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:46668 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3HNLxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:53:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130814143152.6586492341a573f87c64a5df@canb.auug.org.au>
References: <20130814143152.6586492341a573f87c64a5df@canb.auug.org.au>
Date: Wed, 14 Aug 2013 13:53:30 +0200
Message-ID: <CANq1E4QKtbLoGhgZSPNM2QW_j38FiRjm5wNotZn8fnvouQQDpQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the tip tree with the omap_dss2 tree
From: David Herrmann <dh.herrmann@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Aug 14, 2013 at 6:31 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the tip tree got a conflict in
> drivers/video/simplefb.c between commit dbb5ff4c2300 ("simplefb: add
> support for a8b8g8r8 pixel format") from the omap_dss2 tree and commit
> 5ef76da644bf ("fbdev: simplefb: add init through platform_data") from the
> tip tree.
>
> I fixed it up (I think - see below, please check - I used the latter
> version of the above file) and can carry the fix as necessary (no action
> is required).

Looks good. Thanks!
David

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --git a/include/linux/platform_data/simplefb.h b/include/linux/platform_data/simplefb.h
> index 53774b0..c395d4c 100644
> --- a/include/linux/platform_data/simplefb.h
> +++ b/include/linux/platform_data/simplefb.h
> @@ -27,6 +27,7 @@
>         { "a8r8g8b8", 32, {16, 8}, {8, 8}, {0, 8}, {24, 8}, DRM_FORMAT_ARGB8888 }, \
>         { "x2r10g10b10", 32, {20, 10}, {10, 10}, {0, 10}, {0, 0}, DRM_FORMAT_XRGB2101010 }, \
>         { "a2r10g10b10", 32, {20, 10}, {10, 10}, {0, 10}, {30, 2}, DRM_FORMAT_ARGB2101010 }, \
> +       { "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {24, 8}, DRM_FORMAT_ABGR8888 }, \
>  }
>
>  /*
