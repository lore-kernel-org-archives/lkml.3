Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaHJVIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 17:08:35 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:58042 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHJVId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 17:08:33 -0400
MIME-Version: 1.0
In-Reply-To: <1404338448.14741.8.camel@joe-AO725>
References: <20140702130210.fd40d67f0819cfb5f3e9e5ca@linux-foundation.org>
	<1404331746.14624.95.camel@joe-AO725>
	<20140702131534.c613f55f79519b3862f79e40@linux-foundation.org>
	<1404338448.14741.8.camel@joe-AO725>
Date: Sun, 10 Aug 2014 23:08:31 +0200
X-Google-Sender-Auth: K6-UyM-P0MtbwsBWKkfKhRDpi5Y
Message-ID: <CAMuHMdV1TXLmuAofwrUuT-KKUfkEYdXsM34VRrfhB6FxXfdeeg@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Add test for commit id formatting style in
 commit log
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Thu, Jul 3, 2014 at 12:00 AM, Joe Perches <joe@perches.com> wrote:
> Commit logs have various forms of commit id references.
>
> Try to standardize on a 12 character long lower case
> commit id along with a description of parentheses and
> the quoted subject line
>
> ie: commit 0123456789ab ("commit description")

Now this is in mainline, checkpatch starts complaining about my "too long"
(40 chars) commit IDs in commit messages :-(

40 chars may be too long (but it's quick to copy-and-paste, as "git show"
shows that by default), but 12 sounds a bit short, as that's only 48 bits.

According to the Birthday Paradox (en.wikipedia.org/wiki/Birthday_problem),
there's a probability of 50% of a collision if you use 48 bits IDs in a
repository with ca. 16 milion (2^24) objects. A Linux kernel repository
counts ca. 4 million objects, so we're getting close...

So soon we'll get "error: short SHA1 is ambiguous".

BTW, is there actually an easy way to make "git show" show all options for
an ambiguous SHA1?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
