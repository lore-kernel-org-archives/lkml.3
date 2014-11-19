Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaKSM7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 07:59:54 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:47766 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaKSM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 07:59:53 -0500
MIME-Version: 1.0
In-Reply-To: <1416400568-7512-1-git-send-email-b50113@freescale.com>
References: <1416400568-7512-1-git-send-email-b50113@freescale.com>
Date: Wed, 19 Nov 2014 10:59:51 -0200
Message-ID: <CAOMZO5DuJpEPALw60yC3kxEbdE_-fAbUG-3L+hZ+Oo1bd=0Kew@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8960: Add shared_lrclk and capless
 to device tree
From: Fabio Estevam <festevam@gmail.com>
To: Zidan Wang <b50113@freescale.com>
Cc: Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        patches@opensource.wolfsonmicro.com,
        Liam Girdwood <lgirdwood@gmail.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 10:36 AM, Zidan Wang <b50113@freescale.com> wrote:
> wm8960 codec has a wm8960_data struct which has two fields shared_lrclk and capless.
> The wm8960_data is get from platform_data and it is reasonable to set it from device
> tree when platform_data is null.
> And when shared_lrclk is set, LRCM will be enabled. But the following software reset
> in wm8960_probe will reset it to the default state. So LRCM operation should after
> software reset.
>
> Signed-off-by: Zidan Wang <b50113@freescale.com>
> ---
>  sound/soc/codecs/wm8960.c | 49 ++++++++++++++++++++++++++++++-----------------

I think you could a add
Documentation/devicetree/bindings/sound/wm8960.txt in a separate patch
and document these properties there.
