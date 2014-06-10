Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936325AbaFJHka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:40:30 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:57606 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933993AbaFJHk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:40:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140605155614.GA18376@sepie.suse.cz>
References: <1399639944-20551-1-git-send-email-mmarek@suse.cz>
	<1399639944-20551-4-git-send-email-mmarek@suse.cz>
	<CAFLxGvyz-aX8rTveo9W3mqsQxPeg8cb7Oq59UiC1kMz4qTiYwg@mail.gmail.com>
	<538EEA3D.1080105@suse.cz>
	<538F1B41.3060904@suse.cz>
	<20140605155614.GA18376@sepie.suse.cz>
Date: Tue, 10 Jun 2014 09:40:26 +0200
X-Google-Sender-Auth: 6ddnFs6XYagfM5M8JL-AYbqTbuA
Message-ID: <CAMuHMdU0PQsKkYuFpxca1u7+tPbkxQsnNJ1b5-L-aJG9ZCyyEA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] kbuild: Use relative path for $(objtree)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Thu, Jun 5, 2014 at 5:56 PM, Michal Marek <mmarek@suse.cz> wrote:
> --- a/arch/um/Makefile
> +++ b/arch/um/Makefile
> @@ -111,8 +111,7 @@ endef
>  KBUILD_KCONFIG := $(HOST_DIR)/um/Kconfig
>
>  archheaders:
> -       $(Q)$(MAKE) -C '$(srctree)' KBUILD_SRC= \
> -               ARCH=$(HEADER_ARCH) O='$(objtree)' archheaders
> +       $(Q)$(MAKE) KBUILD_SRC= ARCH=$(HEADER_ARCH) archheaders

Should the logic in https://lkml.org/lkml/2014/6/1/17 be changed as well?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
