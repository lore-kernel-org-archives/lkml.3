Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3IYK2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:28:30 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37688 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3IYK23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:28:29 -0400
Date: Wed, 25 Sep 2013 11:28:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Wei Yongjun <weiyj.lk@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        yongjun_wei@trendmicro.com.cn, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: twl6040: drop devm_free_irq of devm_ allocated irq
Message-ID: <20130925102825.GE5132@lee--X1>
References: <CAPgLHd-xSjXvn51RUP+dY-9_pK=HhHzb_R6rb4mKcLufms_jQA@mail.gmail.com>
 <CAK9yfHxo=zWxvH2KoUiMfys5MXfkJiCcF3L7yO_zHTOq5dm9qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9yfHxo=zWxvH2KoUiMfys5MXfkJiCcF3L7yO_zHTOq5dm9qg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013, Sachin Kamat wrote:

> On 25 September 2013 13:07, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >
> > -       devm_free_irq(&client->dev, twl6040->irq_ready, twl6040);
> > -       devm_free_irq(&client->dev, twl6040->irq_th, twl6040);
> >         regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
> 
> Now that the freeing of irq will happen after regmap_del_irq_chip,
> wouldn't this cause any ordering related issues?

I don't believe there is a requirement to free all associated IRQs
before deleting an irqchip.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
