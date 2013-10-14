Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3JNLz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:55:28 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:53441 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab3JNLz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:55:27 -0400
MIME-Version: 1.0
In-Reply-To: <20131014110908.GP2443@sirena.org.uk>
References: <1381724633-29586-1-git-send-email-yizhang@marvell.com>
	<20131014110908.GP2443@sirena.org.uk>
Date: Mon, 14 Oct 2013 19:55:26 +0800
Message-ID: <CAK=oMXeKq-MbKcvM8ZsMF9R7Nj76boxHhKU6duUy4HxZ-=7Wpg@mail.gmail.com>
Subject: Re: [PATCH] regmap: irq: clear status when disable irq
From: Yi Zhang <yizhang.mrvl@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yi Zhang <yizhang@marvell.com>, zhangwm@marvell.com,
        linux-kernel@vger.kernel.org, zhouqiao@marvell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/14 Mark Brown <broonie@kernel.org>:
> On Mon, Oct 14, 2013 at 12:23:53PM +0800, Yi Zhang wrote:
>
>> Change-Id: I371201f365c5a8470073a393068cfeb4e3d14a03
>
> Don't include noise like this in upstream submissions.
>
 Thanks Mark, it's my fault; I'll remove it;
>> +             /* Ack masked but set interrupts */
>> +             reg = d->chip->status_base +
>> +                     (i * map->reg_stride * d->irq_reg_stride);
>> +             ret = regmap_read(d->map, reg, &d->status_buf[i]);
>> +             if (ret != 0)
>> +                     dev_err(d->map->dev, "Failed to read IRQ status: %d\n",
>> +                             ret);
>
> No, this isn't good - it'll read the hardware interrupt status again.
> This will break any devices that are clear on read since enabled
> interrupts will also be read.  I'd suggest unconditionally acknowledging
> all masked interrupts as the simplest approach, obviously it'd be better
> to only acknowledge newly masked interrupts but that is more complex to
> implement.
Yes, you are right; I'll change according to your advice and send it out later;
thanks very much for pointing this;
