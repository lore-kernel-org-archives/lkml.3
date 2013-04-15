Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab3DOLgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 07:36:43 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:59153 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab3DOLgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 07:36:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130415110601.GE6512@gmail.com>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
 <1365532783-27425-3-git-send-email-lee.jones@linaro.org> <CAH+eYFB_fYmCjvh5PXKRhd-FnaWfeu+LtH+q3VywhCk-PYhHVQ@mail.gmail.com>
 <20130415110601.GE6512@gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Mon, 15 Apr 2013 13:36:00 +0200
X-Google-Sender-Auth: _y7ooQjK1LI-8sMgZYN39Fk2zco
Message-ID: <CAH+eYFB2+oMPXsnzQVVrEK8CjKGVYFa_n4Wxr=CpdtJwFfOGYw@mail.gmail.com>
Subject: Re: [PATCH 3/8] dmaengine: ste_dma40: Actually write the runtime
 configuration to registers
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/15 Lee Jones <lee.jones@linaro.org>:
> On Fri, 12 Apr 2013, Rabin Vincent wrote:
>> 2013/4/9 Lee Jones <lee.jones@linaro.org>:
>> > Someone has spent a fair amount of effort writing a runtime configuration
>> > changing algorithm for DMA clients. However, the config appears to never
>> > actually make it to hardware. In order for the configuration to take hold
>> > we need to issue a d40_config_write(), as this is the routine which writes
>> > it into the hardware's registers.
>>
>> No, it's not.  This function is only for initial configuration which
>> should only be written when the channel is allocated.  In fact, by
>> calling it here in runtime_config, you are introducing a serious bug:
>> other logical channels on the same physical channel will stop because of
>> the SSLNK/SDLNK of the physical channel being zeroed.
>>
>> The runtime config already makes it the hardware in the existing code,
>> via d40_*_cfg().
>
> Sorry Rabin, but the only place I can see the config being written is
> in d40_config_write().
>
> Can you paste the line of code in d40_*_cfg() which actually writes
> the config to hardware please? I don't see it.

It's not that simple.  There are some pointers passed to d40_*_cfg() and
that function writes the configuration to the variables those pointers
point to (d40c->log_def.lcsp1, d40c->src_def_cfg, etc.).  Please read
the code to see how those variables end up being used later when the
LLIs are prepared for the HW.
