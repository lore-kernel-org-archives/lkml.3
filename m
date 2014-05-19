Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaESPBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:01:06 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36269 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaESPBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:01:04 -0400
MIME-Version: 1.0
In-Reply-To: <1397137314-13523-1-git-send-email-robherring2@gmail.com>
References: <1397137314-13523-1-git-send-email-robherring2@gmail.com>
Date: Mon, 19 May 2014 17:01:03 +0200
X-Google-Sender-Auth: 0jQy7Vo7PFUtAVpe1TFWV7C-Fqg
Message-ID: <CAMuHMdURE+rJ4jPhPRwsKqn1egzoWpidzYc0aPP=aSGbjMj11g@mail.gmail.com>
Subject: Re: [PATCH v2] checkpatch: fix wildcard DT compatible string checking
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 3:41 PM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <robh@kernel.org>
>
> We attempt to search for compatible strings which use a variable
> token in the documented name such as <chip> or <soc>. While this
> was attempted to be handled, it's utterly broken.
>
> The desired forms of matching are:
>
> vendor,<chip>-*
> vendor,name<part#>-*
>
> For <chip>, lower case characters and numbers are permitted. For
> <part#>, only numeric values are allowed.
>
> With this change, the number of missing compatible strings reported in
> arch/arm/boot/dts is reduced from 1071 to 960.
>
> Reported-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Florian Vaussard <florian.vaussard@epfl.ch>
> Cc: Joe Perches <joe@perches.com>
> Cc: Andy Whitcroft <apw@canonical.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

As I came up with about the same patch while investigating why it didn't
work for me:

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
