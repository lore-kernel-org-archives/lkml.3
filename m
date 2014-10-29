Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870AbaJ2OTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:19:47 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:45819 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398AbaJ2OTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:19:06 -0400
MIME-Version: 1.0
In-Reply-To: <20141028213426.GE18557@sirena.org.uk>
References: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
	<20141027193229.GE18557@sirena.org.uk>
	<CAMo8Bf+Z9V8mkiC3JOupPQmi1EJUDKrb1qcNncDbsEbhjigbww@mail.gmail.com>
	<20141028154224.GX18557@sirena.org.uk>
	<CAMo8BfLpJ0bdmaFt9+gLQ_kEjB68XdjAJUw8f8s=Owv46h_yDQ@mail.gmail.com>
	<20141028173853.GD18557@sirena.org.uk>
	<CAMo8BfL+vW7BjC1bQPNjhuBMTcRTkf8_DDS3NO2HmBUnfHYAFQ@mail.gmail.com>
	<20141028213426.GE18557@sirena.org.uk>
Date: Wed, 29 Oct 2014 17:19:05 +0300
Message-ID: <CAMo8Bf+NT6HrtXzgx=9TBJwLYFJK1VE-fuBBuoUmmzchhOON2Q@mail.gmail.com>
Subject: Re: [PATCH] ASoC: add xtensa xtfpga I2S interface and platform
From: Max Filippov <jcmvbkbc@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 12:34 AM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Oct 28, 2014 at 09:11:34PM +0300, Max Filippov wrote:
>> On Tue, Oct 28, 2014 at 8:38 PM, Mark Brown <broonie@kernel.org> wrote:
>
>> > You *really* need to explain how it's supposed to work - right now it's
>> > not at all obvious, like I say the fact that this is a rarely used idiom
>> > is not helping.  For example when we tear down the stream we just assign
>> > the pointer in _stop() but don't bother with a sync until the stream is
>> > closed - why?
>
>> Because we can't wait in stop and syncing is not time critical, we can
>> do it any time before the stream becomes invalid.
>
> To be clear: the important part is that someone reading the code can
> understand what's going on.

Ok, I'll change it.

>> >> hw_params callback can change MCLK rate, so it has to disable and
>> >> enable the clock anyway, and since enable can fail it does not guarantee
>> >> that the clock will be left in the same state. Or should I adjust MCLK rate
>> >> w/o disabling the clock?
>
>> > So yet again: why not just enable the clock only when the device is in
>> > use?  If it's being configured it stands to reason that the device isn't
>> > actively in use...
>
>> Mark, I don't get it, sorry ): My clock synthesizer is I2C controlled, so
>> I can't prepare/unprepare it in the trigger callback. When should I do it?
>
> Runtime PM is the normal way of doing it.

Ok, thanks.

>> >> The level field in the control register is 4 bit wide, so the allowed range of
>> >> level is 0..15. FIFO size is 8192 entries, level = 1 corresponds to
>> >> FIFO size / 2, level = 14 -- to FIFO size of 0. I guess this function
>> >> won't get period_size of 0?
>
>> > So if the IP gets changed and the code gets blown up this could well
>> > explode then...  which doesn't seem entirely unlikely considering this
>> > is a FPGA platform so presumably this is easy to update.  To repeat this
>> > is about clarity and the code looking like it's probably hiding bugs as
>> > much as if the code actually works if you really sit down and study it.
>
>> The calculation does not depend on the actual hardware, but on the
>> constant definitions in the same file. They need to be updated if the
>> hardware changes. I'll try to rewrite it in a cleaner way.
>
> Right, my point is that if someone changes the hardware they'll just
> update the constants and then things will break.

Ok, I've rewritten it in a safer manner.

-- 
Thanks.
-- Max
