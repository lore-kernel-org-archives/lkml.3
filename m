Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaAOMVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:21:48 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64576 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaAOMVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:21:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMwXhNx94223cW-j8-0dBGY+y_wiYN4AM+ZSKvEgZCVY1ShgA@mail.gmail.com>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-4-git-send-email-lpapp@kde.org>
	<CACRpkdbAPYs=48RXr6r5kqkYj2V9GitRMT2BRKkn4_gT77wUEg@mail.gmail.com>
	<CAOMwXhNcmbk92TsNTGVQdfWrbVycVW++-+46+8onDZ5xPCD-Jw@mail.gmail.com>
	<CACRpkdbih0xQWqnuouhuiRCzYmou++76ex5zC1nh=iBQWJ9otA@mail.gmail.com>
	<CAOMwXhMtc44SpA5yoGBP38muMqPMi3EkxeAKh3V5c_H=3qoXhw@mail.gmail.com>
	<CAOMwXhNBNa4EKe8rVTtQeAwXGGwFaRu9az+4yHARdH1PnPW1yQ@mail.gmail.com>
	<CACRpkdap8GpdwMbj-H+UNA_KH60tQ+2uYznTKJgOE3AFdy3JvQ@mail.gmail.com>
	<CAOMwXhNx94223cW-j8-0dBGY+y_wiYN4AM+ZSKvEgZCVY1ShgA@mail.gmail.com>
Date: Wed, 15 Jan 2014 13:21:43 +0100
Message-ID: <CACRpkdaOy5vh=ZX-9TQAcCV4XWi_OP9ujY4p3fGJ4+LdVB3shQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: MAX6650/6651 support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 11:51 AM, Laszlo Papp <lpapp@kde.org> wrote:

> Hmm, this email seems about business stuff and how the community
> works, but I did not mean to question that...

Well you did ask to merge something I didn't consider a proper
implementation due to some time constraints so that is why I
brought this up.

> Either way, I would like to clarify my previous question as I could
> not manage to get the point through: Is it possible /technically/ to
> have a similar version with both kernel versions?

When it comes to pin control, no. Because it is developing at
a rapid pace. But the same goes soon for GPIO as well, as we're
refactoring the GPIO pace.

So the answer to the technical question is "it depends"
and it depends on the evolutional change rate in the core of
each subsystem. They can be stable for years and then suddenly
there are changes all over the place, so the back-portability is
sometimes there, sometimes not, and the outcome is
unpredictable.

> I am only interested
> in this on the technical ground to be able to evaluate if it is worth
> dealing with upstreaming at this point at all.

OK sorry if I was a bit explosive in this last reply. I defininately
think you should invest in upstreaming, even if the code you
upstream is not usable in your present company-internal codebase
and current deadlines. Because in the long term, if the thing
you're using it with lives long enough, you will get that
code back one day. And then you can move faster at that point.

Basically I think a person working at the inside of a company
should strive to have *something* booting and ticking using just
the mainline kernel, even if not all drivers are in place. If for
nothing else so for keeping track of what is happening upstream.

> If the answer is that, "the community has no care to give technical
> insight for old versions", that is also fine.

Gave some above I think even if it's not what you wanted. Here
is another thing, <linux/version.h> contains
#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
Conjuring a macro from a kernelversion matched to
LINUX_VERSION_CODE so that a driver can #if statements
to conditionally compile stuff for different kernels, like

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
  /* foo */
#else
  /* bar */
#endif

I *think* this is not supposed to be used to make the same code
compile on different kernel versions (rather for things like
glibc etc that need to behave differently with different kernel
baselines), but it *can* be used for e.g. creating kernel modules
that compile to different code on different kernels.

> Please do not get me wrong, this is not unwillingness, but
> currently it would require a huge investment compared to just get
> things done and draw the income for the wages. It is out-of-my-desire
> or my colleagues' of course, but the life is full of compromise as you
> also already know.

Yeah, I realize that not everyone can live to their desires,
which we could call an insight of weltschmerz or Dukkha. As I
am existentialist I try very hard, every day, to make the right choice
for each situation. But that is for each and every one of us to do.
Good luck!

Yours,
Linus Walleij
