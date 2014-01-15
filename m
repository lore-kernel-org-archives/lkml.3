Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaAOSTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:19:04 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:45585 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbaAOSTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:19:01 -0500
Date: Wed, 15 Jan 2014 19:18:31 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Xiubo Li <Li.Xiubo@freescale.com>, broonie@kernel.org
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Problems with simple-card
Message-ID: <20140115191831.5965d17e@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiubo,

I did a mistake in the v1 of my 'ASoC: simple-card: simplify code': I
did not initialize the pointer to the asoc_simple_card_dai_init()
function when DT. Then, I fixed that, and the simple card does not work
for me.

First, without any 'format' in the DT, I get a fmt for each CPU / CODEC
DAI: SND_SOC_DAIFMT_CBS_CFS is always set. Well, some code is executed
for nothing, but this is not critical.

The main problem is about sysclk: when there is no clock in the DT,
you get the clock of the CPU or CODEC DAI. In my system, two clocks
are declared in the controller CPU DAI, but there is no .set_sysclk
pointer. So, snd_soc_dai_set_sysclk() returns -EINVAL and the card is
not created.

As I don't know why you need these fmt and sysclk, may you have a
look at these problems?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
