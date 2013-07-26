Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553Ab3GZTKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 15:10:31 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45395 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab3GZTK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 15:10:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130726185458.GX9858@sirena.org.uk>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
	<1374863133-6745-2-git-send-email-eu@felipetonello.com>
	<20130726185458.GX9858@sirena.org.uk>
Date: Fri, 26 Jul 2013 12:10:27 -0700
Message-ID: <CAGrhNMy7qZ8CbAjFX5Gv8OqYkit+Eqzr2zZTYXeQ-cNO22+pTQ@mail.gmail.com>
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

On Fri, Jul 26, 2013 at 11:54 AM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jul 26, 2013 at 11:25:30AM -0700, Felipe F. Tonello wrote:
>
>> +
>> +     /* Update ALSA KControl interface */
>> +     snd_kctl_jack_report((struct snd_card *)jack->kctl->private_data, jack->kctl, !!status);
>
> This isn't ideal for multi-function jacks like headsets - it will report
> a single boolean value for the jack regardless of what's plugged in
> meaning userpace can't do things like figure out if a headset or
> headphone is present.  It's probably OK for any realistic input button
> since you're not going to get an input button without other things being
> present.

The KControl for Jack is boolean anyway. You can check it with "amixer
contents". user-space can figure out based on the control name. At
least PulseAudio does that way.

>
> What I'd expect to happen here is that for multi function jacks we
> create a control per function if the controls are valid.

Do you mean based on snd_jack_types?

Felipe Tonello
