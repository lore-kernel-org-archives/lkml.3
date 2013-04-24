Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab3DXOIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:08:00 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:54192 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab3DXOIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:08:00 -0400
Message-ID: <5177E57C.3010802@cogentembedded.com>
Date: Wed, 24 Apr 2013 18:00:28 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        mian.yousaf.kaukab@stericsson.com, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 04/10] usb: musb: ux500: harden checks for platform data
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org> <1366729394-11406-5-git-send-email-lee.jones@linaro.org> <5176E927.908@cogentembedded.com> <20130424065344.GB17416@gmail.com>
In-Reply-To: <20130424065344.GB17416@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-04-2013 10:53, Lee Jones wrote:

>>>   	struct musb_hdrc_platform_data *plat = dev->platform_data;
>>> -	struct ux500_musb_board_data *data = plat->board_data;
>>> +	struct ux500_musb_board_data *data;

>>> -	param_array = data->dma_rx_param_array;
>>> +	param_array = (data) ? data->dma_rx_param_array : NULL;

>>     Why enclose a simple variable in parens?

> Because 'data' is a pointer, so it contains a memory location,

    Pointer points to memory location, not contains it.

> but if
> 'plat->board_data' is NULL, then 'data' will be NULL (essentially
> memory location 0x00000000).

    So what?

> So if we were to read-in to 'struct ux500_musb_board_data *data', by
> index 'dma_rx_param_array', which I believe is '0' in this case:

> struct ux500_musb_board_data {
>          void    **dma_rx_param_array;
>          void    **dma_tx_param_array;
>          bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
> };

> ... then we're saying take the data from this memory location:

> param_array = *((0x00000000)->(0x0));

> Which will cause a kernel Oops, due to the fact that address 0x0 isn't
> allocated to us, so you get something like:

> "Unable to handle kernel NULL pointer dereference at virtual address 00000000"

    We're not dereferencing 'data', so I completely fail to follow you.

> Hope that helps.

    Not at all.

> Kind regards,
> Lee

WBR, Sergei

