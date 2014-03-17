Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbaCQKTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:19:53 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:55599 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348AbaCQKTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:19:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Mar 2014 12:19:46 +0200
From: Jyri Sarha <jsarha@ti.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, Xiubo Li <Li.Xiubo@freescale.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
In-Reply-To: <d054780a0edf4b2338a52e48bff9144e19aa614f.1394883134.git.moinejf@free.fr>
References: <cover.1394883134.git.moinejf@free.fr>
 <d054780a0edf4b2338a52e48bff9144e19aa614f.1394883134.git.moinejf@free.fr>
Message-ID: <190d334218a324f12078f81d769322ca@kapsi.fi>
User-Agent: RoundCube Webmail/0.9.4
X-SA-Exim-Connect-IP: 217.30.184.182
X-SA-Exim-Mail-From: jsarha@ti.com
Subject: Re: [alsa-devel] [PATCH v3 4/4] ASoC: simple-card: Add DT
 documentation for multi-DAI links
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:26:47 +0000)
X-SA-Exim-Scanned: Yes (on mail.kapsi.fi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-15 13:30, Jean-Francois Moine wrote:
> There may be many couples of CPU/CODEC DAI links.
> The example 2 is extracted from the Cubox DT.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
[...]

This binding forces all the dai links to share the same card level 
properties. I find it problematic in these cases:

>> - simple-audio-card,format		: CPU/CODEC common audio format.
>> 					  "i2s", "right_j", "left_j" , "dsp_a"
>> 					  "dsp_b", "ac97", "pdm", "msb", "lsb"

The code allows having the format parameter in sub nodes too, but the 
document does no mention it. Adding a mention would solve this problem 
at least partly.

Neither does the document mention that 
"simple-audio-card,bitclock-inversion" and 
"simple-audio-card,frame-inversion" are also allowed in card level. 
Currently the code uses simple bit-wise-or from card-level and dai-level 
daifmt parameters, which may lead to broken daifmt setting. However, 
this on directly related to this patch.

>> - dai-tdm-slot-num			: Please refer to tdm-slot.txt.
>> - dai-tdm-slot-width			: Please refer to tdm-slot.txt.

These properties are actually only taken from sub-nodes so the document 
is broken but the code is ok.

In general this binding would look better if another sub-node level 
would added for dai-link related properties, including the cpu and codec 
sub-nodes, but that would break the backwards compatibility.

Best regards,
Jyri
