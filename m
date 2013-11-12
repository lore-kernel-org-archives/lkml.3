Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3KLOJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:09:46 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58868 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3KLOJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:09:43 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1311112031220.30673@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org>
	<20130917183628.534494408@linutronix.de>
	<CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com>
	<alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de>
	<87txhg3ftx.fsf@igel.home>
	<CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com>
	<alpine.DEB.2.02.1311041305540.28335@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1311042032130.16975@ayla.of.borg>
	<alpine.DEB.2.02.1311061237430.23353@ionos.tec.linutronix.de>
	<CAMuHMdXDA2MRbR3GmD3KWC-iE6jnWX4uvbf1qeMd7RYX3O8f_g@mail.gmail.com>
	<alpine.DEB.2.02.1311071655240.23353@ionos.tec.linutronix.de>
	<ecf977d9ccbd241723a606423267bb2d@biophys.uni-duesseldorf.de>
	<CAMuHMdVXk0NpinvqEszqL63fZEt3rOk6ZR9ogz0aHEzmEaW22A@mail.gmail.com>
	<alpine.DEB.2.02.1311111421400.30673@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1311112031220.30673@ionos.tec.linutronix.de>
Date: Tue, 12 Nov 2013 15:09:42 +0100
X-Google-Sender-Auth: gLSD5CqT454ubS5MWHwphcGZOpQ
Message-ID: <CAMuHMdX+dGkOK==kfJAzmnfjz35gTNCazB84nhL4SmxTWX9tjQ@mail.gmail.com>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Mon, Nov 11, 2013 at 8:34 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Finally found the issue. The patch below fixes the problem here. The
> little missing detail is, that I zapped GET_CURRENT() assuming blindly
> that this is only needed for the preempt_count hackery. But in fact
> the world and some more depends on it which leads to interesting
> explosions.

Yes, GET_CURRENT() sets up the current task in %a2.

Many thanks for tracking this down!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
