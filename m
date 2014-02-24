Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaBXVR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 16:17:29 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:55348 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaBXVR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 16:17:26 -0500
MIME-Version: 1.0
In-Reply-To: <14991521.KzMVP7XS2h@geidi-prime>
References: <1516865.M993BQAYe4@geidi-prime>
	<530A931B.3020606@iki.fi>
	<14991521.KzMVP7XS2h@geidi-prime>
Date: Mon, 24 Feb 2014 22:17:25 +0100
Message-ID: <CADbOyBQ0U_TiovwMJJO1zQpr5PcwmB1O155P4nC6CmwhZjA=UQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Add ff-memless-next and make hid-lg4ff use it
From: Elias Vanderstuyft <elias.vds@gmail.com>
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: =?ISO-8859-1?Q?Michal_Mal=FD?= <madcatxster@prifuk.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Simon Wood <simon@mungewell.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 1:58 AM, Michal Malý <madcatxster@prifuk.cz> wrote:
> On Monday 24 of February 2014 02:32:27 Anssi Hannula wrote:
>>
>> I think we should extend the current ff-memless instead of duplicating
>> its functionality (even on a "for now" basis).
>>
>> Having looked at ff-memless-next briefly, it seems very similar to
>> ff-memless on its basic working principle, and therefore I don't really
>> see why extending ff-memless would be too cumbersome. Unless I'm missing
>> something - in that case, feel free to point it out to me :)
>
> Deciding whether to patch ff-memless or write a new driver from scratch was a
> perfect example of being caught between the rock and a hard place. I am not
> particularly fond of the fact that we would have two modules doing pretty much
> the same thing. My reasons for writing a separate module were:
> - Periodic effects. ff-memless doesn't do "real" periodic effects, it simply
> emulates them through rumble effect. Devices without rumble effect support
> require emulation through constant force effect. Just this was not something
> one could write in one afternoon:)
> - Conditional effects. These effects cannot be by nature combined into one
> overall force (at least not easily) so they have to be handled one by one -
> this is a concept ff-memless does not seem to consider. FFB devices have
> limits as to how many conditional (referred to as "uncombinable" in MLNX)
> effects can be active simultaneously, etc.
> All in all it seemed less error prone to write a new driver based on the ff-
> memless logic, test and deploy it on devices I have access to and once we are
> sure there are no nasty regressions port the rest of the drivers to the new
> API. Given the scope of the changes I am afraid that a "patch" to ff-memless
> would be pretty close to a rewrite anyway.

And add the fact that we already heavily tested the ff-memless-next driver.
Unless you do a diff between the original ff-memless.c and the current
ff-memless-next.c (which will result in a rather unintuitive patch),
it would be a huge waste of time to retest the modified (when doing
efforts to create an intuitive patch) ff-memless-next.c, considered my
total time spend on testing (and not to speak of the time that Michal
spent to fix the corresponding bugs.)
I know that might not be much of an argument, but on the other side,
my motivation to test again from scratch will be much lower (I can't
change much on that, I'm afraid), which would eventually lead to lower
reliability of the final product.

Elias
