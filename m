Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3EUJE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:04:27 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.29]:36382 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab3EUJEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:04:24 -0400
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2013 05:04:24 EDT
Message-ID: <519B3571.3070601@ladisch.de>
Date: Tue, 21 May 2013 10:50:57 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: good1.2guy@gmail.com
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [Alsa-devel] add support for syba 7.1 surround sound card
References: <51804394.a36cec0a.2c7d.291b@mx.google.com>
In-Reply-To: <51804394.a36cec0a.2c7d.291b@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

good1.2guy@gmail.com wrote:
> Summary: add support for syba 7.1 surround sound card
> Keywords: syba via VT1723 Tremor
> Kernel: 3.8.8-203.fc18.x86_64

What are these three lines for?

> add support for syba 7.1 surround sound card
> actually the card only has 6 dmas, so it is really only 5.1

The website shows a daughterboard.

> added code to force_rate setting to not fail EBUSY when the dmas are running.
> suggest using force_rate with pulseaudio to avoid loops with error logging.

This sounds as if it has nothing to do with this particular SYBA card
but affects all VT1723 cards.  Please move it into a separate patch.

And there should be no reason for a module parameter; if this is a bug
in the driver and/or in PulseAudio, it should be just fixed.

> Signed-off-by: psmith2004@yahoo.com

Real names only.

Please read Documentation/SubmittingPatches.

> +static void syba_quirk_open(struct snd_ice1712 *ice)
> +{
> +	unsigned long flags;

It's common to have an empty line here.

> +	spin_lock_irqsave(&ice->reg_lock, flags);
> +	outb(0xff, ICEREG1724(ice, AC97_CFG));
> +	udelay(500);
> +	outb(ice->eeprom.data[ICE_EEP2_ACLINK], ICEREG1724(ice, AC97_CFG));
> +	spin_unlock_irqrestore(&ice->reg_lock, flags);
> +}

What is the reason for this quirk?
Is it possible that this might be needed for other cards using a AC'97
codec?


Regards,
Clemens
