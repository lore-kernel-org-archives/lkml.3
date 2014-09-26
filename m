Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaIZSTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:19:54 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:65394 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbaIZSTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:19:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140926180111.GA3911@core.coreip.homeip.net>
References: <20140926180111.GA3911@core.coreip.homeip.net>
Date: Fri, 26 Sep 2014 11:19:51 -0700
X-Google-Sender-Auth: e7XmKG9Slmw0BnYdPeb2z2JbqsU
Message-ID: <CA+55aFzD0Vo2c74_M-k-0Q6kGRd8btYDM34vnYA-UOP6Mko2QA@mail.gmail.com>
Subject: Re: [git pull] Input updates for 3.17-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 11:01 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> to receive updates for the input subsystem. You will get a small fixup to
> i8042 adding Asus X450LCP to the nomux list.

Side note: I'm wondering how painful it would be to just make nomux
the default.

I think it's getting to be a legacy issue, since the traditional
reason for it (afaik) is just having both an external PS/2 port _and_
a touchpad connnected to the same controller. And even when that
happens, it seems that as often as not, the bug reports in this area
have been about the touchpad _not_ working due to us incorrectly
thinking it's muxed.

I dunno. Maybe mux mode is used more than I think it is, and it would
cause tons of problems. But I do find myself wondering whether we'd be
better off not doing mux by default, and making the DMI check instead
check for systems that *do* want muxing.

Hmm? Am I just being crazy?

               Linus
