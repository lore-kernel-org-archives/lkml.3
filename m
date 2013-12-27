Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab3L0KKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 05:10:32 -0500
Received: from mail.eclipso.de ([217.69.254.102]:49724 "HELO mail.eclipso.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754208Ab3L0KKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 05:10:30 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Dec 2013 05:10:30 EST
Date: Fri, 27 Dec 2013 11:05:26 +0100
MIME-Version: 1.0
Message-ID: <8191a78f885837fe5c89d9ffb6dd251a@mail.eclipso.de>
X-Mailer: eclipso.eu/7.3.0
X-Sender-IP: 82.217.125.67
From: "Roy Spliet" <rspliet@eclipso.eu>
Subject: Re: nouveau nvaa clock missing break?
Reply-To: "Roy Spliet" <rspliet@eclipso.eu>
To: "Kees Cook" <keescook@google.com>
Cc: <bskeggs@redhat.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
In-Reply-To: <CAGXu5j+mBiXj2+iPKGU+Ffb3oXqL+cH8JULH_hoORJNiQgQQFQ@mail.gmail.com>
References: <CAGXu5j+mBiXj2+iPKGU+Ffb3oXqL+cH8JULH_hoORJNiQgQQFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kees,

Thanks for your feedback. Let me first reassure you that this fall-through is indeed intentional: vdiv should be set regardless of the clock source. A comment line would definitely be in place though for future nouveau hackers.
In read_pll, post_div can never be zero in valid execution. If the register-read returns zero, the GPU has either fallen off the bus, or crashed because someone set a divider of 0. I agree that this is not very robust and will probably lead to a divide-by-zero on hardware failure. Checking it doesn't harm I bet!
I will propose a patch addressing these issues as soon as I find some free time. Thanks again for the feedback. Yours,

Roy

--- Ursprüngliche Nachricht ---
Von: Kees Cook <keescook@google.com>
Datum: 20:51:22 26-12-2013
An: Roy Spliet <rspliet@eclipso.eu>
Betreff: nouveau nvaa clock missing break?

> Hi,
>
> Just curious if this code is missing a "break" or not...
>
> /drivers/gpu/drm/nouveau/core/subdev/clock/nvaa.c: 373 in nvaa_clock_prog()
>
>
>         switch (priv->vsrc) {
>         case nv_clk_src_cclk:
>                 mast |= 0x00400000;
>         default:
>                 nv_wr32(clk, 0x4600, priv->vdiv);
>         }
>
> Coverity noticed it as CID 1135671. If it's intentional, it might be
> nice to add a "fall through" comment there.
>
> Coverity also complained about read_pll (CID 1135670) where post_div
> could (unlikely) be 0 and used for a divide-by-zero.
>
> Thanks!
>
> -Kees
>
> --
> Kees Cook
> Chrome OS Security
>


