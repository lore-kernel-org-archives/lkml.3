Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388Ab3K0Bf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:35:28 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:27826 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3K0BfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:35:22 -0500
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTzufSIdKK4A==
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: nouveau/ NV11: 3.12 freezes if X.org is started headless
Date: Wed, 27 Nov 2013 01:35:14 +0000
User-Agent: KMail/1.13.7 (Linux/3.12-1.slh.3-aptosid-686; KDE/4.8.4; i686; ; )
Cc: David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
References: <201311262303.26996.s.L-H@gmx.de> <201311270018.14980.s.L-H@gmx.de> <CAKb7UviWkEPnfgi3biTw6OqiSDU7Nnp9FYARMYv_S2h2zLU2LA@mail.gmail.com>
In-Reply-To: <CAKb7UviWkEPnfgi3biTw6OqiSDU7Nnp9FYARMYv_S2h2zLU2LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201311270135.19139.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wednesday 27 November 2013, Ilia Mirkin wrote:
> On Tue, Nov 26, 2013 at 7:18 PM, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
> > Hi
> >
> > On Tuesday 26 November 2013, Ilia Mirkin wrote:
> >> On Tue, Nov 26, 2013 at 6:03 PM, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
> >> > v3.11 is fine, with and without monitor attached.
> >> > v3.12 is fine as long as X.org isn't started (but may fail to reboot
> >> >       cleanly). If a monitor is connected I don't observe any problems,
> >> >       it freezes without a monitor connected.
> >> > v3.13-rc1-95-gb975dc3 appears not to freeze without a monitor anymore
> >> >       (I didn't confirm that it's fine with a monitor attached), but I
> >> >       end up with the following Oops (this is before X.org is started).
> 
> One more idea -- try it with nouveau.runpm=0 -- I've had some odd
> results with it on my older cards (but I don't remember hangs, but I
> also didn't spend a lot of time on it, just plopped the option in and
> moved on). This is a feature that got in in 3.12, and is really the
> only major nouveau-affecting change in that kernel for your card
> revision.

You're spot on, that does the trick.

# cat /sys/module/nouveau/parameters/agpmode 
-1
# cat /sys/module/nouveau/parameters/runpm 
0

  v3.13-rc1-95-gb975dc3 
+ http://cgit.freedesktop.org/~darktama/nouveau/commit/?id=0397aaaa009092427dc60aea8b3c21c00526d8ba
+ nouveau.runpm=0
is now stable, with and without a monitor attached; as is

  3.12.1 || v3.12.1-62-g4615252 (stable-queue.git)
+ nouveau.runpm=0

I don't need to override the agpmode parameter.

Thanks a lot!

Regards
	Stefan Lippers-Hollmann
