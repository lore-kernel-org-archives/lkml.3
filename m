Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbaH0Gx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 02:53:57 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33271 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbaH0Gx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 02:53:56 -0400
MIME-Version: 1.0
In-Reply-To: <cf0e029ae99d4b48a432e5c1669ddc15@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1408950961-19177-1-git-send-email-Li.Xiubo@freescale.com>
	<20140826090426.GA31558@leverpostej>
	<cf0e029ae99d4b48a432e5c1669ddc15@BY2PR0301MB0613.namprd03.prod.outlook.com>
Date: Tue, 26 Aug 2014 23:53:56 -0700
Message-ID: <CAGoOwPSTJaT0UA4yaYR0x49C8UHbmKAR8PzUfV9ZWVW5XBfV5w@mail.gmail.com>
Subject: Re: [PATCH] ASoC: fsl-sai: using 'lsb-first' property instead of 'big-endian-data'.
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "timur@tabi.org" <timur@tabi.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 7:12 PM, Li.Xiubo@freescale.com
<Li.Xiubo@freescale.com> wrote:
> > > This property used for configuring whether the LSB or the MSB is transmitted
> > > first for the fifo data.
> >
> > I don't follow the rationale for this change.
> >
> > This looks like a pointless renaming.
> >
> > Why is this any better?
> >
>
> This is originally to indicate whether the LSB firstly or MSB firstly will be
> transmitted to the CODEC or received from the CODEC, and there has nothing
> Relation to the memory data.
>
> Generally, if the audio data in big endian format, which will be using the bytes
> Reversion ? Here this can only be used to bits reversion.

That's why I suggested previously: mention it in the commit comment.

People will have no idea about what's the exact reason for this change.
Any functional enhancement? Or a bug fix(more likely for this one).
I'm not sure what I described in the previous mail is correct or not.
But you probably should have added it into the commit comments.

And Xiubo, this patch still hasn't fixed the issue of breaking the old DT,
although system can pass during the probe() section.

Thank you,
Nicolin
