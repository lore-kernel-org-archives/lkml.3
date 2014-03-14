Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaCNLQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 07:16:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48997 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbaCNLQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:16:27 -0400
Message-ID: <5322E4FC.7060605@ti.com>
Date: Fri, 14 Mar 2014 13:16:12 +0200
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, Xiubo Li <Li.Xiubo@freescale.com>,
        <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [alsa-devel] [PATCH v2 3/4] ASoC: simple-card: accept many DAI
 links
References: <cover.1394533640.git.moinejf@free.fr> <d71a2b62b331302772d35b3cd35c6dc5da1e9e5d.1394533640.git.moinejf@free.fr>
In-Reply-To: <d71a2b62b331302772d35b3cd35c6dc5da1e9e5d.1394533640.git.moinejf@free.fr>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 11:36 AM, Jean-Francois Moine wrote:
> Some simple audio cards may have many DAI links.
> This patch extends the simple-card driver for handling such cards.
>
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
[...]

Why can't you just use two simple-card instances in your setup?

You need to update the DT-binding document too when you are changing the 
binding. That way it would also be easier to follow what you are trying 
to accomplish here.

The sysclk and tdm properties appear to only work in the dais of the 
first dai-link and __asoc_simple_card_dai_init() will not be called for 
other dais at all. The DT-binding of this implementation would look 
pretty hairy to me.

Best regards,
Jyri

