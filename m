Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab3EPGnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 02:43:10 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:40883 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3EPGnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 02:43:05 -0400
MIME-Version: 1.0
In-Reply-To: <9F78FA13B8C7A749B307D9AECB279EB713E7B327F3@ITSVLEX06.it.maxim-ic.internal>
References: <1368640112-1417-1-git-send-email-abrestic@chromium.org>
	<A453F1AE3B5DC14DB19666C506CE75A710ABEB1EFF@ITSVLEX06.it.maxim-ic.internal>
	<9F78FA13B8C7A749B307D9AECB279EB713E7B327F3@ITSVLEX06.it.maxim-ic.internal>
Date: Wed, 15 May 2013 23:43:03 -0700
X-Google-Sender-Auth: q0VtT75XZs7HNKYHh4JcA6r5wXU
Message-ID: <CAL1qeaEFsZmR5Cpe3GE8djBhEib585ni7hxs=FtjddRXKYENxg@mail.gmail.com>
Subject: Re: [PATCH] ASoC: max98090: add digital mic mux to record path
From: Andrew Bresticker <abrestic@chromium.org>
To: Matthew Mowdy <Matthew.Mowdy@maximintegrated.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Dylan Reid <dgreid@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ralph Birt <Ralph.Birt@maximintegrated.com>,
        Evan Ragsdale <Evan.Ragsdale@maximintegrated.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

> Default Routing:
>
> Of note (software can confirm) I believe the default DAPM routing for the
> driver was intentional setup such that :
>
> Record:
>
> o   If a headset MIC is present, record from it.
>
> o   If not, digital MIC is the default record input.

While this may have been the intention, that's not what the driver is
currently doing.  This is how the capture route looks before this
patch:

HiFi Capture -> AIFOUT{L,R} -> LBEN{L,R}_MUX[0] -> DMIC{L,R}_ENA

So, since DMIC{L,R}_ENA are configured as supplies, they will always
be turned on during record when the loopback mux is set to 0 (i.e. no
loopback)  That's obviously wrong, so this patch changes the
DMIC{L,R}_ENA to muxes.

> The defaults can be modified by each end user as needed (for analog
> microphones, line inputs, etc.). Please insure any patch to the baseline
> driver reflects the correct operation of the digital microphone enable bits,
> and preserves the intended default operation.

Ok, I'll change it so that the DMIC{L,R} muxes aren't individually controllable.

Thanks,
Andrew
