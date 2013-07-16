Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab3GPBCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 21:02:23 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:49072 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab3GPBCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 21:02:21 -0400
MIME-Version: 1.0
In-Reply-To: <1373876954-30437-1-git-send-email-geert@linux-m68k.org>
References: <1373876954-30437-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 15 Jul 2013 18:02:20 -0700
X-Google-Sender-Auth: 8ntem3Oa4HEDgi03DxRCDGBFb6k
Message-ID: <CA+55aFxGymOvvaYfOg22AdHpxEOuOctfC8vRW+_u=vtua8Dksg@mail.gmail.com>
Subject: Re: [PATCH] logo: Remove trailing whitespace from logo_linux_clut224.ppm
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 1:29 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Commit ad81f0545ef01ea651886dddac4bef6cec930092 ("Linux 3.11-rc1")
> replaced the Standard 224-color Linux logo, and introduced lots of
> trailing whitespace. Remove it again.

The logo is temporary, and I'd rather keep it the way it is so that a
simple revert will fix things up again..

That said, even if it wasn't temporary, I think we might be better off
with the raw format that the netpbm tools generate these days. It was
actually slightly annoying to get that big diff from a small edit, and
it was the result of either the original logo ASCII representation
having been cleaned up excessively before, or possibly just the netpbm
tools having changed their output radically.

Of course, it would be even better if we actually used some saner
format. I'm not exactly artistic, so making that whole silly logo
change took more time than it really should have. But what was
*really* painful was to fight the horrible ppm format conversion
issues, and how we only accept that legacy ascii version etc.

I guess it doesn't matter, since it's not like that thing normally
changes, so it's likely not really worth fixing. But it did make me go
"does it really have to be this arcane?"

              Linus
