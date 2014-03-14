Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaCNS60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:58:26 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:57304 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbaCNS6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:58:25 -0400
Date: Fri, 14 Mar 2014 19:58:19 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        Jyri Sarha <jsarha@ti.com>
Cc: Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [alsa-devel] [PATCH v2 3/4] ASoC: simple-card: accept many DAI
 links
Message-ID: <20140314195819.2012c44b@armhf>
In-Reply-To: <2e7647de940f400a916e2f6c43f9811f@BY2PR03MB505.namprd03.prod.outlook.com>
References: <cover.1394533640.git.moinejf@free.fr>
	<d71a2b62b331302772d35b3cd35c6dc5da1e9e5d.1394533640.git.moinejf@free.fr>
	<2e7647de940f400a916e2f6c43f9811f@BY2PR03MB505.namprd03.prod.outlook.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 05:20:17 +0000
"Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com> wrote:

> I'm not sure why only the first link needs parsing the DAIFMT ?

In my machine, there is only one audio device and the CODECs don't need
any format, sysclk or TDM slot.

But, as Jyri asked it too, I will add these properties.

> On my LS1 platform there are two CODECs and two CPU SAI deivces,
> SGTL5000 <---> SAI
> CS42888  <---> ESAI
> 
> Could the many dai links feature support this case? 

As Jyri said: why not two simple-cards?

> I my understanding is correct here, this patch will support the
> Board, in which board there maybe only one CODEC supporting many
> DAIs...

The audio (platform) device of my machine has two outputs (I2S and
S/PDIF = CPU DAIs) which are connected to different CODECs (HDMI
transmitter and S/PDIF connector).

There must be two different HDMI CODECs because the format and rate
constraints of the wires (I2S and S/PDIF) are different.

There is only one playback stream.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
