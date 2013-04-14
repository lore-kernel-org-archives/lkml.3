Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab3DNQff (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:35:35 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:36044 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3DNQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:35:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130412163810.GC18459@gmail.com>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
 <1365532783-27425-4-git-send-email-lee.jones@linaro.org> <CAH+eYFBk8y28e+NwOBpvpdFa29JRXbNpFgjwNumC8GRtB-e7VQ@mail.gmail.com>
 <20130412163810.GC18459@gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Sun, 14 Apr 2013 18:34:51 +0200
X-Google-Sender-Auth: AJW_Z2Dij_nfNEJYFrW5hLLiAe4
Message-ID: <CAH+eYFD4ZVrW4-UQf2YC0CmqMzWu2EtgLSeMA=3etR_u0o7faA@mail.gmail.com>
Subject: Re: [PATCH 4/8] dmaengine: ste_dma40: Do not configure channels
 during an channel allocation
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/12 Lee Jones <lee.jones@linaro.org>:
> So I need to devise another way, as this function cannot be called
> here either. Using the dmaengine API, allocating a channel and
> configuring it are to be completed using different calls. Using the
> API correctly, there is no way the driver can setup the channel
> with all of the relevant information during allocation time.
>
> The steps are as follows:
>
> dma_request_channel() - here we only allot a channel number and
>                         allocate the appropriate resources for the
>                         channel.
>
> dma_slave_config()    - this is where we're meant to configure the
>                         channel, so d40_config_write() needs to be
>                         called here, as only dma_slave_config() will
>                         carry the information required so as
>                         d40_*_cfg() can make the correct decisions.

The choice between whether a physical or a logical channel is used is
not something that is configurable via dma_slave_config().  And
d40_config_write() only needs that information, and that information is
available in dma_request_channel().  Therefore no more information
relevant to d40_config_write() will be obtained in dma_slave_config().
Hence d40_config_write() can be called in dma_request_channel().
