Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbaKZLdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 06:33:15 -0500
Received: from smtp-out-231.synserver.de ([212.40.185.231]:1057 "EHLO
	smtp-out-231.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaKZLdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:33:14 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7007
Message-ID: <5475BA76.8080809@metafoo.de>
Date: Wed, 26 Nov 2014 12:33:10 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Zidan Wang <b50113@freescale.com>, broonie@kernel.org
CC: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        ckeepax@opensource.wolfsonmicro.com, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH] ASoC: wm8960: LRCM operation should after
 software reset
References: <1416999740-21805-1-git-send-email-b50113@freescale.com>
In-Reply-To: <1416999740-21805-1-git-send-email-b50113@freescale.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 12:02 PM, Zidan Wang wrote:
> When shared_lrclk is set, LRCM will be enabled. But the following software
> reset in wm8960_probe will reset it to the default state. So LRCM operation
> should after software reset.

It's probably a better idea to move the reset (together with the other 
register updates) to the I2C driver probe.

- Lars
