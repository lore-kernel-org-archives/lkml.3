Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaELHV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:21:28 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:42262 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaELHV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:21:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140510124053.6bfffd5cb30aa88a7464d080@skynet.be>
References: <20140510124053.6bfffd5cb30aa88a7464d080@skynet.be>
Date: Mon, 12 May 2014 09:21:27 +0200
X-Google-Sender-Auth: 1rmwzzG965mmjPoEkqnxQGR17Qw
Message-ID: <CAMuHMdVWcdLibyXe6mUNigRV4Li7qwC+kjwEK5P-vxiix6RdSA@mail.gmail.com>
Subject: Re: [PATCH 1/1 RESEND] arch/m68k/apollo/config.c: convert printk to pr_foo()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2014 at 12:40 PM, Fabian Frederick <fabf@skynet.be> wrote:
> no level printk converted to pr_info
>
> This is untested
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Thanks, will queue for v3.16...

> --- a/arch/m68k/apollo/config.c
> +++ b/arch/m68k/apollo/config.c
> @@ -65,8 +65,8 @@ int __init apollo_parse_bootinfo(const struct bi_record *record)
>
>  static void __init dn_setup_model(void)
>  {
> -       printk("Apollo hardware found: ");
> -       printk("[%s]\n", apollo_models[apollo_model - APOLLO_DN3000]);
> +       pr_info("Apollo hardware found: ");
> +       pr_cont("[%s]\n", apollo_models[apollo_model - APOLLO_DN3000]);

...with this merged into one line.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
