Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbaGNWT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:19:27 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:59537 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540AbaGNWTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:19:23 -0400
MIME-Version: 1.0
In-Reply-To: <8761iztxzl.fsf@nemi.mork.no>
References: <87pph8kse7.fsf@nemi.mork.no>
	<53C3D7C3.7090505@redhat.com>
	<CA+55aFxYYKApOC+1TQkoxSzi-zTSB8OmkU=ypvNb_Gc2+K6Hmw@mail.gmail.com>
	<CA+55aFzHo4BEO8W0yza7g0YMgg-b=hPbk20-vpR3s==ydpmAOg@mail.gmail.com>
	<877g3fsm98.fsf@nemi.mork.no>
	<CA+55aFztNg4aFUnmqxoR-Hwva87D1TMOZ2Gyy8CVmEov9ToDQg@mail.gmail.com>
	<8761iztxzl.fsf@nemi.mork.no>
Date: Mon, 14 Jul 2014 15:19:22 -0700
X-Google-Sender-Auth: KhDhCMoQ_Ucv3XiLq0xMtOw_K6I
Message-ID: <CA+55aFzNWehvLk2izhnXg--ghOgG7SfMzpzFJcbVZg9duGdWPQ@mail.gmail.com>
Subject: Re: [BISECTED 3.16-rc REGREGRESSION] backlight control stopped working
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 2:46 PM, Bjørn Mork <bjorn@mork.no> wrote:
>
> Yes, the patch works as advertised for me.  Thanks.

Ok, so it should probably be tested by people who see the "move by
two" problem too.

> But this will break existing configs:
>
> Any setup using e.g "options video brightness_switch_enabled=Y" will
> barf on this, won't they?

Hmm. Probably. That said, that kind of breakage I think we might want
to live with, especially if it actually ends up causing them to test
the new default (which might just work for them).

But regardless, let's make sure that patch (or something _like_ it)
works for people who saw the reverse problem for you. Then the exact
syntax of whatever module parameter (if any) can be a separate
discussion.

Anyway, for 3.16 I think we should just do what we used to do (ie the
revert that Rafael apparently already has queued up), so this isn't
necessarily critical.

            Linus
