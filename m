Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaGZUj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:39:56 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:43664 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaGZUjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 16:39:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140726201914.GB21842@x4>
References: <53D064C7.5050807@daenzer.net>
	<CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
	<53D1B1EF.7030603@daenzer.net>
	<20140725035527.GA30108@pg-vmw-gw1>
	<20140725140237.GB32669@home.goodmis.org>
	<CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
	<CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
	<CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
	<20140726193557.GA21842@x4>
	<CA+55aFyo=HVZGEYNmz9GHqLatFHiJYTviKz_dXjqCv8b_gGxBA@mail.gmail.com>
	<20140726201914.GB21842@x4>
Date: Sat, 26 Jul 2014 13:39:54 -0700
X-Google-Sender-Auth: dNZlVfQDLRepb5aQ4Tm3d5nbEcI
Message-ID: <CA+55aFyCh8B4kuc66_+wr8eM+kP7-hJ9utdtpLih661Xf8YGgQ@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 1:19 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
>
> Yes. The option only affects -g builds.

Ok, good. I'll wait a bit to hopefully get confirmation from Michel's
setup, but this does seem to be the solution.

> So, the option should only be enabled for debugging builds. Something
> like the following should be sufficient:

Actually, I prefer my patch that did it with cc-option checking, and
does it unconditionally.

Because if we do it even for non-debug builds - where it ostensibly
shouldn't matter - we then have that GCC_COMPARE_DEBUG thing working
regardless of configuration.

                Linus
