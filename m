Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaKMDCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 22:02:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44955 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbaKMDCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 22:02:06 -0500
Message-ID: <85499f52ebd29581bf58b9cafbae6864.squirrel@www.codeaurora.org>
Date: Thu, 13 Nov 2014 03:02:04 -0000
Subject: Question on Compressed offload session
From: gsantosh@codeaurora.org
To: alsa-devel-bounces@alsa-project.org
Cc: "Mark Rutland" <mark.rutland@arm.com>, "Rob Herring" <robh@kernel.org>,
        "ALSA Development Mailing List" <alsa-devel@alsa-project.org>,
        "Kuninori Morimoto" <kuninori.morimoto.gx@renesas.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        "Magnus" <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        "Mark Brown" <broonie@kernel.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Olof Johansson" <olof@lixom.net>,
        "Kuninori Morimoto" <kuninori.morimoto.gx@gmail.com>
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The Question is for the compressed offload session.

For a generic codec driver during the startup function it will set some of
the hw_constraints rule similarly like this.

        snd_pcm_hw_constraint_list(substream->runtime, 0,
                    SNDRV_PCM_HW_PARAM_RATE,
                    &constraints_12_24);

pcm_lib.c will try to add the rule to the runtime structure by accessing
the pointers which will be initialized during opening of the session,
as The Constraints added by the codec driver will be updated in the

struct snd_pcm_hw_constraints of runtime structure which will be part of
substream handle.

But for the compressed offload I do not see the initialization done for HW
constraints, as done in pcm session

2092int snd_pcm_open_substream(struct snd_pcm *pcm, int stream,
2093			   struct file *file,
2094			   struct snd_pcm_substream **rsubstream)

most of the existing drivers which has the hw_constraint_list code will
not be applicable for compress offload session, how to solve this?

Regards,
Santosh M G.
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum,a Linux Foundation Collaborative Project


