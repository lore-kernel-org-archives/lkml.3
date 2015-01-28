Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbbA1UWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:22:11 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44680 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbbA1UWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:22:06 -0500
MIME-Version: 1.0
In-Reply-To: <20150128110230.GQ21293@sirena.org.uk>
References: <1422442278-10405-1-git-send-email-tomeu.vizoso@collabora.com>
 <1422442278-10405-7-git-send-email-tomeu.vizoso@collabora.com> <20150128110230.GQ21293@sirena.org.uk>
From: Dylan Reid <dgreid@chromium.org>
Date: Wed, 28 Jan 2015 09:46:27 -0800
X-Google-Sender-Auth: vgIhHcyi9d5m8NkaXnJdP7rUDAs
Message-ID: <CAEUnVG6tKmdTt455w8g9C2_+XXpKz5=TR7=V8Lo3uJ3DKrOvag@mail.gmail.com>
Subject: Re: [PATCH v3 06/10] ASoC: tegra: Add a control for the headphone switch
To: Mark Brown <broonie@kernel.org>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Andrew Bresticker <abrestic@chromium.org>,
        Simon Glass <sjg@chromium.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Wolfram Sang <wsa@the-dreams.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 3:02 AM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Jan 28, 2015 at 11:51:04AM +0100, Tomeu Vizoso wrote:
>
>> To be used by userspace when the headphones jack is plugged in.
>
>>  static const struct snd_kcontrol_new tegra_max98090_controls[] = {
>> +     SOC_DAPM_PIN_SWITCH("Headphones"),
>>       SOC_DAPM_PIN_SWITCH("Speakers"),
>>  };
>
> Why is userspace doing this?  If this is supposed to be associated with
> the jack detection I'd expect us to be doing this in kernel.

This is only related to jack detection in that seeing a jack insert or
removal can cause userspace to set or unset it depending on the
current policy.
