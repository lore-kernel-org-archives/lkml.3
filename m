Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab3JLDOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 23:14:30 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:58852 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab3JLDO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 23:14:29 -0400
MIME-Version: 1.0
Date: Sat, 12 Oct 2013 11:14:27 +0800
Message-ID: <CAK=oMXetPxaQ-MeL9L9+182X220ivu2G5+i-42kqtAUjbfvg2w@mail.gmail.com>
Subject: [Question]should we not ignore the masked interrupt in regmap?
From: yi zhang <yizhang.mrvl@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yi Zhang <yizhang@marvell.com>, zhouqiao@marvell.com, zhangwm@marvell.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark:

Sorry to trouble you, I have a question about the interrupt handling
of regmap framework;
in the regmap_irq_thread(), from the following code, we only handle
the unmasked interrupt;


256                 data->status_buf[i] &= ~data->mask_buf[i];


but in the following sequence,  irq storm will happen;
do you think we should do a change here to handle all the interrupt here?
thanks very much;

1) interrupt is triggered;
2) a thread disables it(then the mask bit is set);
3) _Then_ the interrupt thread is executed, it _ignore _ and doesn’t
handle this interrupt;
   because the interrupt is not ACKed, the interrupt status is not cleared;
4) in Marvell's PMIC, the interrupt line to SOC is always asserted,
then irq storm happens;

------------------------
Yi Zhang
