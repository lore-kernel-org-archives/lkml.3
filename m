Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab3CLRvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:51:47 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:41043 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355Ab3CLRvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:51:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzFLDcN-1GKae6Xqrns59K1xOD_HPzuv2Lv1__fZpqFMw@mail.gmail.com>
References: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
	<alpine.LRH.2.02.1303121510270.25612@tundra.namei.org>
	<20130312041641.GE18595@thunk.org>
	<CA+55aFzFLDcN-1GKae6Xqrns59K1xOD_HPzuv2Lv1__fZpqFMw@mail.gmail.com>
Date: Tue, 12 Mar 2013 18:51:44 +0100
X-Google-Sender-Auth: RRPze5wdhlAF2RStTnStK3nZwkg
Message-ID: <CAMuHMdXaf_wfmwpQ4O5v+n8vd4uwddDANyZna4ufK10JxZhSvA@mail.gmail.com>
Subject: Re: linux-next: unneeded merge in the security tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Git Mailing List <git@vger.kernel.org>,
        Junio C Hamano <gitster@pobox.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 6:13 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> Why not just force the head of the security tree to be v3.9-rc2?  Then
>> you don't end up creating a completely unnecessary merge commit, and
>> users who were at the previous head of the security tree will
>> experience a fast forward when they pull your new head.
>
> So I think that may *technically* be the right solution, but it's a
> rather annoying UI issue, partly because you can't just do it in a
> single operation (you can't do a pull of the tag to both fetch and
> fast-forward it), but partly because "git reset --hard" is also an
> operation that can lose history, so it's something that people should
> be nervous about, and shouldn't use as some kind of standard "let's
> just fast-forward to Linus' tree" thing.

In many cases, "git rebase x" does the exact same thing as
"git reset --hard x", with an added safeguard: if you forgot to upstream
something, it'll boil up on top of "x".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
