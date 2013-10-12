Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750799Ab3JLMu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 08:50:59 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:53624 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3JLMu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 08:50:58 -0400
MIME-Version: 1.0
In-Reply-To: <20131012123217.GK2443@sirena.org.uk>
References: <CAK=oMXetPxaQ-MeL9L9+182X220ivu2G5+i-42kqtAUjbfvg2w@mail.gmail.com>
	<20131012123217.GK2443@sirena.org.uk>
Date: Sat, 12 Oct 2013 20:50:57 +0800
Message-ID: <CAK=oMXeyqGcQOOnCmZBfg3GhdmO+uREiGut-L9yk53aQ3p7FZQ@mail.gmail.com>
Subject: Re: [Question]should we not ignore the masked interrupt in regmap?
From: yi zhang <yizhang.mrvl@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yi Zhang <yizhang@marvell.com>, zhouqiao@marvell.com, zhangwm@marvell.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/12 Mark Brown <broonie@kernel.org>:
> On Sat, Oct 12, 2013 at 11:14:27AM +0800, yi zhang wrote:
>
>> 1) interrupt is triggered;
>> 2) a thread disables it(then the mask bit is set);
>> 3) _Then_ the interrupt thread is executed, it _ignore _ and doesn’t
>> handle this interrupt;
>>    because the interrupt is not ACKed, the interrupt status is not cleared;
>> 4) in Marvell's PMIC, the interrupt line to SOC is always asserted,
>> then irq storm happens;
>
> This sounds like you need the workaround activated by init_ack_masked.
> It's basically the hardware failing to implement masking sensibly - the
> general expectation for a mask bit is that it will have no effect on the
> actual state of the interrupt, only on if it's reported.
Thanks Mark;

As I understand it, this "init_ack_masked" is used in initialization
(please correct me if I'm wrong);
but if the sequence above happens not in the initialization, then what
should we do to handle this?
could you please give us advice?

thanks very much;
