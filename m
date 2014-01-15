Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaAOKvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:51:48 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37940 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaAOKvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:51:45 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdap8GpdwMbj-H+UNA_KH60tQ+2uYznTKJgOE3AFdy3JvQ@mail.gmail.com>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-4-git-send-email-lpapp@kde.org>
	<CACRpkdbAPYs=48RXr6r5kqkYj2V9GitRMT2BRKkn4_gT77wUEg@mail.gmail.com>
	<CAOMwXhNcmbk92TsNTGVQdfWrbVycVW++-+46+8onDZ5xPCD-Jw@mail.gmail.com>
	<CACRpkdbih0xQWqnuouhuiRCzYmou++76ex5zC1nh=iBQWJ9otA@mail.gmail.com>
	<CAOMwXhMtc44SpA5yoGBP38muMqPMi3EkxeAKh3V5c_H=3qoXhw@mail.gmail.com>
	<CAOMwXhNBNa4EKe8rVTtQeAwXGGwFaRu9az+4yHARdH1PnPW1yQ@mail.gmail.com>
	<CACRpkdap8GpdwMbj-H+UNA_KH60tQ+2uYznTKJgOE3AFdy3JvQ@mail.gmail.com>
Date: Wed, 15 Jan 2014 10:51:45 +0000
X-Google-Sender-Auth: nmP-4-YbUU1YaqW87oV6YLwXWLY
Message-ID: <CAOMwXhNx94223cW-j8-0dBGY+y_wiYN4AM+ZSKvEgZCVY1ShgA@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 10:05 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Tue, Jan 14, 2014 at 6:17 PM, Laszlo Papp <lpapp@kde.org> wrote:
>
> [CC:ing Jon Corbet on this as he's better at the consensus process
> and may correct me here.]
>
>> I have just had a quick look and I am now worried.... It seems that
>> the pinctrl system was not as mature in 3.2 that I need to support as
>> these days... The short term task of mine is to get it working for
>> that release, and trying to upstream all this is an additional
>> bonus....
>
> I am just a community maintainer, I do not worry very much about
> your company's infatuation with ancient kernel releases, so please
> do not bring such issues to us. We only develop and worry about
> the mainline kernel, Torvald's HEAD, with stability fixes going into
> the -stable kernels (not new stuff like this).
>
>> Hence, my question is: would it be acceptable to leave the gpio
>> functionality clearly separate and keep the pinctrl functionality on
>> top of it?
>
> What do you mean?
>
> These are two orthogonal subsystems with some GPIO-to-pin
> criss-cross APIs, I'm just asking that you implement both APIs:
> GPIO and pin control.
>
> Please look at other combined drivers in drivers/pinctrl
> and you will see what I mean.
>
>> Failing that, is it somehow possible to get this functionality nicely
>> working with both versions?
>
> The kernel development process is not suited to such things.
> This is not how we work, we don't want people to develop
> *new features* on old kernels, that is just insane.
>
>> The definite target is 3.2.1 for us as of now.
>
> I'm sorry to tell you that your organization does not understand
> how the mainline community develop new features. If you want to
> work with the community you develop new features on the HEAD,
> last kernel release (v3.12, soon v3.13) or directly on top of the
> pin control development tree in this case.
>
> The fact that some person or function in your company think it
> is a good idea to base development on kernel v3.2.x does not
> concern me, nor anyone else in the community.
>
> I mean, of course it is interesting to know odd stuff about the
> remote corners of kernel development, but it doesn't influence our
> behavior.
>
>> I would appreciate any suggestion about it. The pinctrl system was
>> introduced in 3.1 if I am not mistaken, and 3.2 has lotta less drivers
>> around, etc... Not quite sure about the core foundation though.
>
> If a company decides to work on a fork from the community
> that is their problem, basically. Then they assume all forward-porting
> and maintenance costs, sometimes also a huge cost of
> backward-porting entire subsystems and an increasing threshold
> to migrate to new kernel releases as time goes by.
>
> I'm not saying this is necessarily a bad decision for the company,
> but it means forking and disconnecting from the community,
> we will not come around and work like you do.
>
> I have seen this behaviour in many companies, and what they
> typically do not realize is that working this way comes with a
> cost because they are still dependent on new features only
> developed upstream and they often do not realize the issue of
> escalting maintenance cost as the fork widens over time.
>
> Then we have the ontology problem:
> The suggestion from any system manager (or similar
> function/role) in an organization that they want to lock down
> development to a certain older kernel version that "they know
> is stable" or "have agreed upon" or something like that is a
> complete fallacy, they are not the architects and developers of
> the Linux kernel and they are not competent to make such
> statements, to put one thing very clear.
>
> The only people that can make such statements you will find
> in the MAINTAINERS file of the kernel and that's it. Very simple.
> Usually they will tell you to do your development on the very
> latest kernel.
>
> It might be that someone pays your wages to work and think
> counter to this very simple rule, but that is another thing, that
> is not the truth or the way the world works, it is just a power
> relation in the working place and while I do realize that this is a
> fact of life, it doesn't change the way the community works.
>
> Yours,
> Linus Walleij

Hmm, this email seems about business stuff and how the community
works, but I did not mean to question that...

I believe I am aware some (most?) of this, but thank you for your
explanation either way. It is useful for the readers. Fwiw, I have
been a remote part of the Nokia Maemo/MeeGo Linux kernel fork and
work. I also developed USB drivers 5-6 years ago where
(out-of-my-desire), we could not upstream drivers for our devices.

Either way, I would like to clarify my previous question as I could
not manage to get the point through: Is it possible /technically/ to
have a similar version with both kernel versions? I am only interested
in this on the technical ground to be able to evaluate if it is worth
dealing with upstreaming at this point at all. I was not expecting you
to accept my situation which is again out-of-my-desire why we have to
stick to an older version.

If the answer is that, "the community has no care to give technical
insight for old versions", that is also fine. No harm done there. I
just thought it would not hurt asking because it could be a potential
benefit for the community if I could manage both without maintain two
separate drivers. The world of course continues further on [1] if we
cannot. Please do not get me wrong, this is not unwillingness, but
currently it would require a huge investment compared to just get
things done and draw the income for the wages. It is out-of-my-desire
or my colleagues' of course, but the life is full of compromise as you
also already know.

Thank you for your answer either way. Cheers.

[1] https://plus.google.com/103895730806848715870/posts/1q34T1iYU4j
