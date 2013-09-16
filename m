Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab3IPIJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:09:47 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:61440 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3IPIJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:09:43 -0400
MIME-Version: 1.0
In-Reply-To: <1379317437-28329-2-git-send-email-keescook@chromium.org>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
	<1379317437-28329-2-git-send-email-keescook@chromium.org>
Date: Mon, 16 Sep 2013 10:09:42 +0200
X-Google-Sender-Auth: bTWzhsUoctNoXY_Yen7Xqc_ZAi0
Message-ID: <CAMuHMdUw7J6TmQ=13_zoC=rvGy0PZwd8VF5t3g8pjPQX5WaVUg@mail.gmail.com>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, George Spelvin <linux@horizon.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Beulich <JBeulich@suse.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 9:43 AM, Kees Cook <keescook@chromium.org> wrote:
> All users of %n are calculating padding size when using seq_file, so
> instead use the new last_len member for discovering the length of the
> written strings.

Would it make sense to provide a seq_pad(...) function instead, to avoid
exposing more seq_file internals to its callers?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
