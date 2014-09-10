Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023AbaIJEXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:23:47 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49955 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaIJEXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:23:46 -0400
MIME-Version: 1.0
X-Originating-IP: [218.164.130.137]
In-Reply-To: <CAFRkauBBmEKNnc3M-CPAWQ8yMZFo6W-wj-M1qMmn3hGAYL6sTg@mail.gmail.com>
References: <1410321039-26888-1-git-send-email-guodong.xu@linaro.org>
	<CAFRkauBBmEKNnc3M-CPAWQ8yMZFo6W-wj-M1qMmn3hGAYL6sTg@mail.gmail.com>
Date: Wed, 10 Sep 2014 12:23:45 +0800
Message-ID: <CAFRkauDnp0pEEFkzvUoD8i4Up5DaMJDM26uGihah86FxsO7Rsw@mail.gmail.com>
Subject: Re: [PATCH] regulator: remove unnecessary of_node_get() to parent
From: Axel Lin <axel.lin@ingics.com>
To: Guodong Xu <guodong.xu@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Support Opensource <support.opensource@diasemi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-10 12:20 GMT+08:00 Axel Lin <axel.lin@ingics.com>:
> 2014-09-10 11:50 GMT+08:00 Guodong Xu <guodong.xu@linaro.org>:
>> These of_node_get() were added to balance refcount decrements inside of
>> of_find_node_by_name().
>> See: commit c92f5dd2c42f ("regulator: Add missing of_node_put()")
>>
>> However of_find_node_by_name() was then replaced by of_get_child_by_name(),
>> which doesn't call of_node_put() against its input parameter.
>>
>> So, need to remove these unnecessary of_node_get() calls.
>
> The of_node_get() and of_node_put() is a pair.
> You need to either keep both or remove both.
>
>
> BTW,
> I think either the comment of of_get_child_by_name() needs fix or the
> implementation
> needs fix. The implementation does not increment refcount.

Ah, I see the of_node_get() and of_node_put() in __of_get_next_child.
So of_get_child_by_name() is correct.(both comment and implementation)
