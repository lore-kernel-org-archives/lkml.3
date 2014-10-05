Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaJEOQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 10:16:11 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:57703 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaJEOQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 10:16:07 -0400
MIME-Version: 1.0
In-Reply-To: <20141005102056.05861325@recife.lan>
References: <cover.1412497399.git.knightrider@are.ma>
	<5bff3e029fe189f44222961dc04790d4f58a4659.1412497399.git.knightrider@are.ma>
	<20141005083358.072f5909.m.chehab@samsung.com>
	<CAKnK8-REGVgdgQM+2KP0ibrf_gHMm_UO3oLr0MRoiu=-7vXUPw@mail.gmail.com>
	<20141005102056.05861325@recife.lan>
Date: Sun, 5 Oct 2014 23:16:05 +0900
X-Google-Sender-Auth: 3raJfZmlZaNmQtD-7yxX_QufZKA
Message-ID: <CAKnK8-QewsVoqLvHz6=JkppxzbvS8-C6hecL7NzmAwBxY0pJuA@mail.gmail.com>
Subject: Re: [PATCH 02/11] tc90522 is a client
From: "AreMa Inc." <info@are.ma>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>, Hans De Goede <hdegoede@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Peter Senna Tschudin <peter.senna@gmail.com>, knightrider@are.ma
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> We started developing and publishing PT3 drivers (chardev and DVB versions)
>> on 2013 and have been submitting the patches to this community since then.
>> We were waiting for reviews.
>
>The reviews were sent, but it is really hard to review a big patch with
>14 files changed and 2952 insertions that weren't following the Linux DVB
>model, nor with the patches themselves were following the Kernel submission
>process.

Which patch are you talking about? We didn't receive any response since May.
I'm sure our recent patches conform the DVB model.

>I very much prefer if you could agree one with another around
>a series of patches that would improve the driver without causing
>regressions.

As you said, this is doable but very painful.

-Bud

2014-10-05 22:20 GMT+09:00 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> Em Sun, 05 Oct 2014 21:39:01 +0900
> "AreMa Inc." <info@are.ma> escreveu:
>
>> Mauro,
>>
>> As this _stable_ patch series is developed originally
>> (and already submitted for review) since 2013,
>> not based on Tsukada's patch you just linked,
>> it is difficult to split into one patch per logic.
>>
>> As you said, for example, to fix the Tsukada's patch of tuner - FE - bridge
>> communication, we need to fix all the files.
>
> Yes, it requires lots of work, although it is possible. We've done that in
> the past a few times, when such type of conflicts arise.
> It is always painful, though.
>
> I did it myself some time ago, in order to add support for some newer
> Siano hardware. The original patch submission were based on a diff between
> the driver at the Kernel and some internal development tree used by
> the chip manufacturer.
>
> I waited for ~2 years for the original author to fix. As he didn't,
> and I got some new hardware, I was forced to do the rebase myself.
> It took maybe one week or two of hard work to get it done.
>
>> We started developing and publishing PT3 drivers (chardev and DVB versions)
>> on 2013 and have been submitting the patches to this community since then.
>> We were waiting for reviews.
>
> The reviews were sent, but it is really hard to review a big patch with
> 14 files changed and 2952 insertions that weren't following the Linux DVB
> model, nor with the patches themselves were following the Kernel submission
> process.
>
> On every new review, a newer big blob were sent, sometimes repeating the
> same pattern that the reviewers asked to change.
>
> The entire review work is made by volunteers that have something else
> to do. So, if you want a quicker review, you need to make their lives
> easier, by splitting the drivers into smaller pieces and applying the
> changes they request (or technically arguing with them at the e-mail
> thread). Failing to do that makes the entire process longer.
>
>> However this July, a man named Tsukada, who has been annoying us since
>> the beginning of development (we invited him to merge/join the project,
>> in other words, opted him to be co-author), interrupted our submission
>> and started
>> speaking ill of us that we didn't want to split the driver and stopped
>> the development, etc.
>
> At least the public comments I saw, I didn't notice anything ill about
> you.
>
> Splitting the drivers into frontend, demod and bridge driver is indeed
> a requirement for DVB drivers submission. We do that even on devices
> like as as102, where they're all integrated at the same chip, as such
> split makes review a way easier, and decouples different logic functions
> into different modules.
>
>> This is not true. What we meant was that, it is too early to implement
>> Regmap I2C
>> for now (except if it is a firm consensus, surely we will do).
>
> Regmap I2C is an improvement, but not a mandatory requirement.
>
>> Unfortunately, you trusted him and put on the tree. If "backstabbing"
>> is permitted,
>> this will be a very bad precedence in our community.
>>
>> We can send per logic patches without breaking the compilation,
>> but we cannot guarantee the behaviour if you apply only one patch or two.
>> Thus, pulling the clean package from
>>
>>        https://github.com/knight-rider/ptx/tree/master/pt3_dvb
>>
>> is the best bet. Or, do you have the card with you?
>
> No, I don't have such card, nor I have any personal preference from
> your version or Tsukada's one.
>
> I might be ordering one and test here with my RF generators or ISDB-T
> live, but very likely I won't have any time for coding, as my duties
> as the maintainers require my attention on other things too. Also,
> the problem here is not the lack of a developer for it, but, instead,
> the lack of coordination between two developers.
>
> So, I very much prefer if you could agree one with another around
> a series of patches that would improve the driver without causing
> regressions.
>
> Thanks and Regards,
> Mauro
