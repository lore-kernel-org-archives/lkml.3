Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbaGBRuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:50:14 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:41846 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711AbaGBRuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:50:09 -0400
Date: Wed, 2 Jul 2014 19:51:54 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        lgirdwood@gmail.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ASoC: tda998x: add a codec to the HDMI transmitter
Message-ID: <20140702195154.47d6f6b4@armhf>
In-Reply-To: <20140702165628.GO20799@lunn.ch>
References: <20140702183841.7c964832@armhf>
	<20140702165628.GO20799@lunn.ch>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014 18:56:28 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> How well will this work with Russell concept of a front end and two
> backends? Can you uses your CODEC twice, once with the I2S backend and
> a second time with the S/PDIF backend?

Hi Andrew,

The TDA998x CODEC has two functions:
- it sets the possible formats and rates when the screen connects and
- it sets the audio input port when audio streaming starts.

I tested this CODEC with both DAPM and DPCM. If the audio subsystem
asks for streaming on both I2S and S/PDIF, only the last call is served
(this depends on the order of the DAI links in the audio card creation
table).

As I told to Russell, DPCM just asks for a 'system' DAI (front-end),
but it also asks for some additional code in the kirkwood DMA driver
because all PCMs are activated on streaming start.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
