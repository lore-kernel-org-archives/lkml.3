Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab3CDJi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:38:58 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:49730 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab3CDJi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:38:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAFRkauDBR-P48oG0vk=HzE+dJ3wV4oVGBUpeo5jOUmBJ1rNgRw@mail.gmail.com>
References: <1362376059.414.1.camel@phoenix>
	<CAD6h2NSnH68_2iXd5g3vxuoADdWkQhiFCjXHbKKAg3KgA5wgQQ@mail.gmail.com>
	<CAFRkauDBR-P48oG0vk=HzE+dJ3wV4oVGBUpeo5jOUmBJ1rNgRw@mail.gmail.com>
Date: Mon, 4 Mar 2013 17:38:56 +0800
Message-ID: <CAD6h2NSHeOCwC7vsUUSh5S6VNM5kxUzRioFWjFeXmNXgFXJM+g@mail.gmail.com>
Subject: Re: [PATCH RFT] pinctrl: single: Fix build error
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 March 2013 17:18, Axel Lin <axel.lin@ingics.com> wrote:
> 2013/3/4 Haojian Zhuang <haojian.zhuang@linaro.org>:
>> On 4 March 2013 13:47, Axel Lin <axel.lin@ingics.com> wrote:
>>> If pcs->is_pinconf is false, it means does not support pinconf.
>>> If pcs->is_pinconf is true, is_generic flag is always true.
>>>
>>> This patch fixes below build error:
>>>
>>>   CC [M]  drivers/pinctrl/pinctrl-single.o
>>> drivers/pinctrl/pinctrl-single.c: In function 'pcs_probe':
>>> drivers/pinctrl/pinctrl-single.c:1441:3: error: assignment of member 'is_generic' in read-only object
>>> make[2]: *** [drivers/pinctrl/pinctrl-single.o] Error 1
>>> make[1]: *** [drivers/pinctrl] Error 2
>>> make: *** [drivers] Error 2
>>>
>>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>>> ---
>>>  drivers/pinctrl/pinctrl-single.c |    6 +++---
>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
>>> index 4cdcf85..e35dabd 100644
>>> --- a/drivers/pinctrl/pinctrl-single.c
>>> +++ b/drivers/pinctrl/pinctrl-single.c
>>> @@ -734,6 +734,7 @@ static const struct pinconf_ops pcs_pinconf_ops = {
>>>         .pin_config_dbg_show = pcs_pinconf_dbg_show,
>>>         .pin_config_group_dbg_show = pcs_pinconf_group_dbg_show,
>>>         .pin_config_config_dbg_show = pcs_pinconf_config_dbg_show,
>>> +       .is_generic = true,
>>
>> There's two cases for is_generic. Your fix only make thing worse.
>
> AFAICT, in current code ( linux-next 20130304, before applying this patch):
> if match->data is false, pcs->is_pinconf is also false which means
> pinconf isn't supported.
>
> In the case pcs->is_pinconf is true, is_generic actually is *always*
> true in current code.
>
You're right. Your fix could work.

Reviewed-by: Haojian Zhuang <haojian.zhuang@linaro.org>
