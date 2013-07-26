Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab3GZXNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 19:13:43 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:52818 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab3GZXNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 19:13:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130726224813.GB9858@sirena.org.uk>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
	<1374863133-6745-2-git-send-email-eu@felipetonello.com>
	<20130726185458.GX9858@sirena.org.uk>
	<CAGrhNMy7qZ8CbAjFX5Gv8OqYkit+Eqzr2zZTYXeQ-cNO22+pTQ@mail.gmail.com>
	<20130726224813.GB9858@sirena.org.uk>
Date: Fri, 26 Jul 2013 16:13:40 -0700
Message-ID: <CAGrhNMwGdMwhd5L2gGxQ=N=8nFk4L5txYmhEtLBVcFj-Etphnw@mail.gmail.com>
Subject: Re: [PATCH 1/4] ALSA: Added jack detection kcontrol support
From: Felipe Tonello <eu@felipetonello.com>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Fri, Jul 26, 2013 at 3:48 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jul 26, 2013 at 12:10:27PM -0700, Felipe Tonello wrote:
>> On Fri, Jul 26, 2013 at 11:54 AM, Mark Brown <broonie@kernel.org> wrote:
>
>> > This isn't ideal for multi-function jacks like headsets - it will report
>> > a single boolean value for the jack regardless of what's plugged in
>> > meaning userpace can't do things like figure out if a headset or
>> > headphone is present.  It's probably OK for any realistic input button
>> > since you're not going to get an input button without other things being
>> > present.
>
>> The KControl for Jack is boolean anyway. You can check it with "amixer
>> contents". user-space can figure out based on the control name. At
>> least PulseAudio does that way.
>
> No, it can't do that for headset jacks - these will be created with a
> single jack reporting multiple states, there's a state for headphone and
> a state for microphone.  The system can generally distinguish between
> having a headset or just plain headphones inserted and act accordingly
> (for example, recording from the built in microphone on a phone when
> used with normal headpones).
>
>> > What I'd expect to happen here is that for multi function jacks we
>> > create a control per function if the controls are valid.

Ok, so the idea is just to change the control to type integer instead
of boolean, right?
Because as you say, the user will be able to check the type of jack
based on the status value, right?

>
>> Do you mean based on snd_jack_types?
>
> Yes.  If there's only one function supported the current code is fine
> but for multiple functions it's going to discard useful information.

So, what do you suggest to do that? I'm not sure if I understand what
you are saying.
When you mean function, do you mean the SND_JACK_BTN_n or the the jack
types, such as SND_JACK_HEADPHONE, and so on?

If a codec creates a jack type SND_JACK_HEADSET (= SND_JACK_HEADPHONE
| SND_JACK_MICROPHONE). It should be created two controls, name +
"Headphone Jack" and name + "Microphone Jack"? If so, what about the
status to report? How to know which control to report?

Felipe Tonello
