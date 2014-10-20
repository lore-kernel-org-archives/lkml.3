Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaJTHKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 03:10:43 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:46111 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaJTHKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 03:10:39 -0400
MIME-Version: 1.0
In-Reply-To: <1413670496-6387-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1413670496-6387-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 20 Oct 2014 09:10:37 +0200
X-Google-Sender-Auth: IXhTh0Ud9IVFqsMWsBQ7A0YJWiQ
Message-ID: <CAMuHMdV-2-t_NaH04pS4nRskDXswn7j2nuxSxp0gOAHfvTJ7FQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] video: fbdev: uvesafb.c: Cleaning up missing
 null-terminate by switching from strncpy to strzcpy
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Michal Januszewski <spock@gentoo.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 12:14 AM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Ensures that the string is null-terminate in connection with the
> use of strncpy, by switching from strncpy to strzcpy.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/video/fbdev/uvesafb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/video/fbdev/uvesafb.c b/drivers/video/fbdev/uvesafb.c
> index 509d452..3383b34 100644
> --- a/drivers/video/fbdev/uvesafb.c
> +++ b/drivers/video/fbdev/uvesafb.c
> @@ -1892,7 +1892,7 @@ static ssize_t show_v86d(struct device_driver *dev, char *buf)
>  static ssize_t store_v86d(struct device_driver *dev, const char *buf,
>                 size_t count)
>  {
> -       strncpy(v86d_path, buf, PATH_MAX);
> +       strzcpy(v86d_path, buf, sizeof(v86d_path));

I think strlcpy() should be good enough here?
Or am I missing a reason why the rest of the buffer should be zero-filled?

Nevertheless, I think this (or an alternative) change should be applied to
stable, as call_usermodehelper() might crash by writing to sysfs.

>         return count;
>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
