Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaKJJFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:05:13 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:62232 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaKJJFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:05:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] ASoC: simple-card: add multi-CODECs in DT
Date: Mon, 10 Nov 2014 10:04:54 +0100
Message-ID: <88485116.3X2aHuesdU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141110100526.76790f55@armhf>
References: <cover.1415605716.git.moinejf@free.fr> <3271244.uSgBKXChSS@wuerfel> <20141110100526.76790f55@armhf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:M1FCafN1DlwqBDjca7l8PP+soIt+5tLAJnCZ3P5vj+t
 qAQoPA79UQ6KzqwfkBvNqD3skmRKcnWwQLwW1Zr3D3wbznjWVR
 FHOU5rNI0pO9VDYToYVeaGChjJTWeDtEQVdv2wcGnUYhpepwo4
 gm7RkdxLcZQO0Zpt7G+SIO2yZH02FV5chA5NJoJI9lsPnKj6cM
 2xSMS8dBL4bfqQaGLgBItNHr51PybNKa7i2e/nTdrmUAoXqusC
 HAa0K+KrwfGnyVa6410UWvKa9GsnylN10QxkQrXI6cy8qmFS2U
 1aCTTo6ET2aVhqxqqKPqbkRBMamrqWnCEZTeGjuJ6CQauJcDoP
 /X5s9zhSwYHI2nTLyN8U=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 November 2014 10:05:26 Jean-Francois Moine wrote:
> On Mon, 10 Nov 2014 09:39:57 +0100
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Sunday 09 November 2014 12:22:21 Jean-Francois Moine wrote:
> > > -- sound-dai                            : phandle and port of CPU/CODEC
> > > +either
> > > +  - sound-dai                          : phandle and port of CPU/CODEC
> > > +or
> > > +  - sound-dais                         : list of phandle and port of CODECs
> > 
> > Is it really necessary to change the property name here? I woudl think
> > that you can make it all work more consistently with just the existing
> > 'sound-dai' property, just extend it to allow multiple codecs
> 
> This was an idea from Benoit Cousson:
> 
>  "Something like that:
> 
>    sound-dais = <&spdif_codec 1>, <&hdmi 0>;
> 
>  That being said, it will require changing the name with a plural form,"
> 
> As I coded it, both names are accepted for a single or many codecs.

I don't see a strong reason for coming up with a plural form. If you really
have to, then please list the old form as a deprecated alias and make the
document talk about "sound-dais" as the preferred form independent of the
number of arguments.

	Arnd
