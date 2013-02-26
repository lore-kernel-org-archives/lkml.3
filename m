Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab3BZV5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 16:57:40 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:33235 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3BZV5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 16:57:38 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx9HkRGfMx6pfR2xsTf0vof_yyrT4ks5TzMKoEpS7w=5g@mail.gmail.com>
References: <18738.1361836265@warthog.procyon.org.uk>
	<20130226005955.GA19686@kroah.com>
	<20130226023332.GA29282@srcf.ucam.org>
	<20130226030249.GB23834@kroah.com>
	<20130226031338.GA29784@srcf.ucam.org>
	<20130226033156.GA24999@kroah.com>
	<20130226033803.GA30285@srcf.ucam.org>
	<20130226035416.GA1128@kroah.com>
	<20130226040456.GA30717@srcf.ucam.org>
	<20130226041324.GA7241@kroah.com>
	<20130226042338.GA30944@srcf.ucam.org>
	<CA+55aFx9HkRGfMx6pfR2xsTf0vof_yyrT4ks5TzMKoEpS7w=5g@mail.gmail.com>
Date: Tue, 26 Feb 2013 22:57:38 +0100
X-Google-Sender-Auth: fGxP_YnzGJA42_7kCarD9dJPliw
Message-ID: <CAMuHMdV4DbX_i6Ye5v7ObR0no-eDhBzqYrsqVtR5PAXQTVSmVQ@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 5:43 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Feb 25, 2013 at 8:23 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> If the user has explicitly enrolled a hash then they're stepping outside
>> the trust model.
>
> This is the kind of totally bogus crap that no sane person should ever
> spout. Stop it.
>
> If the user has explicitly enrolled a hash, then that should be the
> *primary* trust model, dammit. That should be very much what you
> should care about first and foremost, and that should be your goal in
> life. That's when the user says "I'm in control of my own machine, and
> I want to trust *this*".
>
> It's not about "stepping outside of the trust model". Quite the
> reverse. It's about actually being *part* of the trust model, and
> taking control of your own machine. It's the *good* scenario. It's
> what you should encourage users to do.

Indeed.

But explicitly enrolling your own hash is not enough to take control.
You must also remove the other hashes that are already present, since
you don't control what's signed using the corresponding private keys.

BTW, I assume UEFI checks itself if enrolled hashes have been revoked,
so it must phone home to some server? That must be disabled as well.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
