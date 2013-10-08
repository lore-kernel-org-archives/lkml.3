Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab3JHXB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 19:01:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab3JHXBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 19:01:54 -0400
Date: Tue, 8 Oct 2013 16:01:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Pavel Machek <pavel@ucw.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>
Subject: Re: [PATCHv2] Route kbd LEDs through the generic LEDs layer
Message-Id: <20131008160152.a98961b9e54bf1c45c1818dc@linux-foundation.org>
In-Reply-To: <20130904172621.GA5957@type.bordeaux.inria.fr>
References: <20130717152916.GI5883@type.bordeaux.inria.fr>
	<20130904172621.GA5957@type.bordeaux.inria.fr>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Sep 2013 19:26:21 +0200 Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> This permits to reassign keyboard LEDs to something else than keyboard "leds"
> state, by adding keyboard led and modifier triggers connected to a series
> of VT input LEDs, themselves connected to VT input triggers, which
> per-input device LEDs use by default.  Userland can thus easily change the LED
> behavior of (a priori) all input devices, or of particular input devices.
> 
> This also permits to fix #7063 from userland by using a modifier to implement
> proper CapsLock behavior and have the keyboard caps lock led show that modifier
> state.

I had a version of this in -mm for a long time and there was a
1000-message email discussion which I didn't have a hope of following.

Do you believe that the earlier controversies are now addressed and if
so, how?  Have the earlier participants in that discussion been cc'ed
and have they commented?

In other words, how are we generally getting along with those things?  

I'll put this version into -mm to get it a bit of linux-next exposure,
but I'm hoping that Dmitry will process it?

The one-line change to drivers/tty/vt/keyboard.c no longer applies -
LED_SHOW_MEM has vanished altogether.

