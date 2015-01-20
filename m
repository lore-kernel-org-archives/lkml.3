Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbbATVtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:49:55 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:58991 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbbATVtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:49:53 -0500
MIME-Version: 1.0
In-Reply-To: <xmqqmw5n5z8i.fsf@gitster.dls.corp.google.com>
References: <xmqqmw5n5z8i.fsf@gitster.dls.corp.google.com>
From: =?UTF-8?B?w4Z2YXIgQXJuZmrDtnLDsCBCamFybWFzb24=?= <avarab@gmail.com>
Date: Tue, 20 Jan 2015 22:49:32 +0100
Message-ID: <CACBZZX5s1rZ3exktbisseJSjF8-0=8ByMpBpARy6h+=iP7wEyA@mail.gmail.com>
Subject: Re: [ANNOUNCE] Git v2.3.0-rc0
To: Junio C Hamano <gitster@pobox.com>
Cc: Git Mailing List <git@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Jeff King <peff@peff.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 12:57 AM, Junio C Hamano <gitster@pobox.com> wrote:
> An early preview release Git v2.3.0-rc0 is now available for
> testing at the usual places.
[...]
> Jeff King (38):
[...]
>       parse_color: refactor color storage
[...]

I've had this in my .gitconfig since 2010 which was broken by Jeff's
v2.1.3-24-g695d95d:

    ;; Don't be so invasive about coloring ^M when I'm editing files
that
    ;; are supposed to have \r\n.
    [color "diff"]
       whitespace = 0

To test this replace \n with \r\n in a file. Before this patch you could do:

    git -c color.diff.whitespace=0 show

And just get:

    [red]-[/red]
    [green]+[/green]

As opposed to:

    git -c color.diff.whitespace=1 show

Which gives you:

    [red]-
    [green]+[/green][red]^M[/red]

Now that just produces:

    error: invalid color value: 0
    fatal: bad config variable 'color.diff.whitespace' in file
'/home/avar/.gitconfig' at line 16

Maybe breaking this is OK (but I can't find what the replacement is),
but the config or the the changelog doesn't mention breaking existing
config settings.
