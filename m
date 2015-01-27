Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbbA0Ukt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:40:49 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:46226 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbbA0Ukr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:40:47 -0500
MIME-Version: 1.0
In-Reply-To: <1422390694-12389-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <CACRpkda4SBof0EaZVWtEYaeb6j_BGAVj39kje+mBz90eB3qAwQ@mail.gmail.com>
	<1422390694-12389-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Tue, 27 Jan 2015 21:40:45 +0100
X-Google-Sender-Auth: T7DeYAgtbY6scHPFpjKZvR7cQRQ
Message-ID: <CAMuHMdW5Apvbe7+y2FW6O=JS7ZMUQsW6eFMc-ooiLvF3fqY0WA@mail.gmail.com>
Subject: Re: [RFC/PATCH] pinctrl: sh-pfc: Accept standard function, pins and
 groups properties
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niso@kth.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 9:31 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> +               if (of_find_property(np, "groups", NULL) ||
> +                   of_find_property(np, "pins", NULL)) {
> +                       pmx->func_prop_name = "function";
> +                       pmx->groups_prop_name = "groups";
> +                       pmx->pins_prop_name = "pins";
> +               } else {
> +                       pmx->func_prop_name = "renesas,function";
> +                       pmx->groups_prop_name = "renesas,groups";
> +                       pmx->pins_prop_name = "renesas,pins";
> +               }

Do we want to be clever and save memory?

        pmx->func_prop_name = "renesas,function";
        pmx->groups_prop_name = "renesas,groups";
        pmx->pins_prop_name = "renesas,pins";
        if (of_find_property(np, "groups", NULL) ||
            of_find_property(np, "pins", NULL)) {
                pmx->func_prop_name += strlen("renesas,");
                pmx->groups_prop_name += strlen("renesas,");
                pmx->pins_prop_name += strlen("renesas,");
        }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
