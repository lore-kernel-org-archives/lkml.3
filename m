Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab3CCVdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 16:33:08 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37321 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab3CCVdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 16:33:06 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxzN7=z7_iVQ=JvYms1WaCoX-hQ2jKNqLU2dLy63AYK1g@mail.gmail.com>
References: <CACxGe6sweLxtsW9OYb8m7esYguGmStEsuZc0tOgZN6H5Zfy1+g@mail.gmail.com>
 <CA+55aFxzN7=z7_iVQ=JvYms1WaCoX-hQ2jKNqLU2dLy63AYK1g@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 4 Mar 2013 05:32:45 +0800
X-Google-Sender-Auth: XDQNl2owltOhdb8MRJSfe75wNGM
Message-ID: <CACxGe6s=TW1W+S4715sf+N+t+dKjTVBk+mRVYC_74rRC0r4QvA@mail.gmail.com>
Subject: Re: [GIT PULL] gpio changes for v3.9; second round
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 2:50 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Mar 2, 2013 at 6:24 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> 2nd round of GPIO changes for Linux 3.9
>>
>> This branch contains a few bug fixes that I missed the first time around
>> and updates to the gpio_desc series included in the first pull request.
>>
>> ----------------------------------------------------------------
>> Gabriel Fernandez (1):
>>       gpio/stmpe: pass DT node to irqdomain
>
> This breaks the build for me. I get
>
>   drivers/gpio/gpio-stmpe.c: In function ‘stmpe_gpio_irq_init’:
>   drivers/gpio/gpio-stmpe.c:313:23: error: ‘struct gpio_chip’ has no
> member named ‘of_node’
>   drivers/gpio/gpio-stmpe.c:316:61: error: ‘struct gpio_chip’ has no
> member named ‘of_node’
>   drivers/gpio/gpio-stmpe.c: In function ‘stmpe_gpio_probe’:
>   drivers/gpio/gpio-stmpe.c:351:18: error: ‘struct gpio_chip’ has no
> member named ‘of_node’
>
> and I don't think this is a merge error.
>
> Should this driver depend on CONFIG_OF_GPIO, or should it have
> #ifdef's? Regardless, it's clearly broken right now.
>
> Unpulled.

Ugh. Well I clearly screwed that up. Sorry. I'll fix that right away.

g.
