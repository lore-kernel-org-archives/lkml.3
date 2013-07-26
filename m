Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab3GZWsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:48:55 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36058 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab3GZWsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:48:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130726224526.GA9858@sirena.org.uk>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
	<1374863133-6745-5-git-send-email-eu@felipetonello.com>
	<20130726185609.GY9858@sirena.org.uk>
	<CAGrhNMzaBcUb4GHLXr5uR2g4YNSD60vcDpDKQO=S9H2jAx6pgA@mail.gmail.com>
	<20130726224526.GA9858@sirena.org.uk>
Date: Fri, 26 Jul 2013 15:48:52 -0700
Message-ID: <CAGrhNMxb2-o9LFpdbsSgL5hLhLBxcm6cBR8nBypWj2UEaJv9hA@mail.gmail.com>
Subject: Re: [PATCH 4/4] ALSA: oxygen: Updating jack implementation according
 new ALSA Jacks
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

On Fri, Jul 26, 2013 at 3:45 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jul 26, 2013 at 12:02:51PM -0700, Felipe Tonello wrote:
>> On Fri, Jul 26, 2013 at 11:56 AM, Mark Brown <broonie@kernel.org> wrote:
>
>> >>       snd_jack_new(chip->card, "Headphone",
>> >> -                  SND_JACK_HEADPHONE, &data->hp_jack);
>> >> +                  SND_JACK_HEADPHONE, 0, &data->hp_jack);
>> >>       xonar_ds_handle_hp_jack(chip);
>
>> > ...this really ought to be done as part of the commit that adds the
>> > parameter since it breaks the build until this patch is applied.
>
>> But that's why is a patch series. But as you say, are you suggesting
>> me to propose this changes in one patch only?
>
> This one should be squashed in, as should the part of the ASoC change
> that adjusts for the call into the core API.  The general idea with a
> patch series is to split things into smaller chunks so they're easier to
> understand and review but still keep things working with each change so
> that things like git bisect continue to be usable.

Sure.

>
> So I guess something like one patch that changes the core jack API to
> add the index and support jack creation, one to remove the HDA custom
> implementation and one to add support for specifying the index to the
> ASoC API and adjust all its users.

I squashed into the HDA one. Perhaps I should send it again?

I don't know why, but my gmail is messing with the thread. If you
think it's better I can send a v3 with no --in-reply-to option.

Felipe Tonello
