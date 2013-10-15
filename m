Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab3JOMDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 08:03:33 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:38405 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab3JOMDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 08:03:31 -0400
MIME-Version: 1.0
In-Reply-To: <20131015114812.GY2443@sirena.org.uk>
References: <1381813438-5386-1-git-send-email-yizhang@marvell.com>
	<20131015114812.GY2443@sirena.org.uk>
Date: Tue, 15 Oct 2013 20:03:28 +0800
Message-ID: <CAK=oMXfMAafBcFOF=Ct2_ZfYNY6eYW7oHV4kBeQA=hUSf5VnPw@mail.gmail.com>
Subject: Re: [PATCH] regmap: irq: clear status when disable irq
From: Yi Zhang <yizhang.mrvl@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yi Zhang <yizhang@marvell.com>, zhouqiao@marvell.com, zhangwm@marvell.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/15 Mark Brown <broonie@kernel.org>:
> On Tue, Oct 15, 2013 at 01:03:58PM +0800, Yi Zhang wrote:
>
>> +                     bits_length = d->map->format.val_bytes * BITS_PER_BYTE;
>> +                     for (j = 0; j < bits_length; j++) {
>> +                             d->mask_buf[i] &= (0x1 << j);
Yes, this line is wrong, I shouldn't change the mask_buf; I'll change it;
my fault; sorry;
>> +                             if (!d->mask_buf[i])
>> +                                     ret = regmap_update_bits(d->map, reg,
>> +                                                              (0x1 << j), 0);
>> +                             if (ret != 0)
>> +                                     dev_err(d->map->dev, "Failed to ack 0x%x: %d\n",
>> +                                             reg, ret);
>
> I don't entirely understand this code - what's the loop doing?  It
> looks like it's trying to acknowledge things bit by bit but it's doing
> this by updating mask_buf so it looks like it'll corrupt the set of
> masked interrupts.  After the zeroth iteration any bits other than bit 0
> should get cleared by the &= (0x1 << j).  I'd have expected to just
> write mask_buf back or something similar.
>
> It's possible I'm missing something here but if that is the case perhaps
> some comments would be good.
