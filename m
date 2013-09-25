Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab3IYKKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:10:36 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:56093 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab3IYKKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:10:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-xSjXvn51RUP+dY-9_pK=HhHzb_R6rb4mKcLufms_jQA@mail.gmail.com>
References: <CAPgLHd-xSjXvn51RUP+dY-9_pK=HhHzb_R6rb4mKcLufms_jQA@mail.gmail.com>
Date: Wed, 25 Sep 2013 15:40:33 +0530
Message-ID: <CAK9yfHxo=zWxvH2KoUiMfys5MXfkJiCcF3L7yO_zHTOq5dm9qg@mail.gmail.com>
Subject: Re: [PATCH] mfd: twl6040: drop devm_free_irq of devm_ allocated irq
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, yongjun_wei@trendmicro.com.cn,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2013 13:07, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> -       devm_free_irq(&client->dev, twl6040->irq_ready, twl6040);
> -       devm_free_irq(&client->dev, twl6040->irq_th, twl6040);
>         regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);

Now that the freeing of irq will happen after regmap_del_irq_chip,
wouldn't this cause any ordering related issues?


-- 
With warm regards,
Sachin
