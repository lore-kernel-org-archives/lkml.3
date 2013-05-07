Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab3EGNad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:30:33 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:54266 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab3EGNac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:30:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_kpAVzcq4uP2a9qBaWoUbBhC1mfqb2++wQ06Tf67yB2A@mail.gmail.com>
References: <CAPgLHd-av2Yg44ARcSGr_zOajO-U611y3N4_Sn7J5Z+=OfVFcg@mail.gmail.com>
	<CAD6h2NQRqcZ7RW=cCcATD2g3Vi0nszYnjppsX-VQmQgT1se+3w@mail.gmail.com>
	<CAPgLHd_kpAVzcq4uP2a9qBaWoUbBhC1mfqb2++wQ06Tf67yB2A@mail.gmail.com>
Date: Tue, 7 May 2013 21:30:30 +0800
Message-ID: <CAD6h2NT8VHrV8i=W7gi_EtJkNUgkH+MtAAdA6K1ydqwEpnPaoQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: single: fix error return code in pcs_parse_one_pinctrl_entry()
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, grant.likely@linaro.org,
        Rob Herring <rob.herring@calxeda.com>, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2013 20:57, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> On 05/07/2013 08:11 PM, Haojian Zhuang wrote:
>> On 7 May 2013 20:06, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>>
>>> Fix to return a negative error code from the error handling
>>> case instead of 0, as done elsewhere in this function.
>>>
>>> Introduced by commit 9dddb4df90d136429b6d6ddefceb49a9b93f6cd1
>>> (pinctrl: single: support generic pinconf)
>>>
>>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>> ---
>>>  drivers/pinctrl/pinctrl-single.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
>>> index 5f2d2bf..b9fa046 100644
>>> --- a/drivers/pinctrl/pinctrl-single.c
>>> +++ b/drivers/pinctrl/pinctrl-single.c
>>> @@ -1166,7 +1166,8 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
>>>         (*map)->data.mux.function = np->name;
>>>
>>>         if (pcs->is_pinconf) {
>>> -               if (pcs_parse_pinconf(pcs, np, function, map))
>>> +               res = pcs_parse_pinconf(pcs, np, function, map);
>>> +               if (res)
>>>                         goto free_pingroups;
>>>                 *num_maps = 2;
>>>         } else {
>>>
>> It seems that you don't change anything. pcs_parse_pinconf() returns
>> either 0 or negative value.
>>
>> If it returns negative value, it will goto free_pingroups label w/wo
>> your change. So I don't understand why your change is necessary.
>
> return res as the error code. before this change, 0 will be return
> in this case.
>
>
Yes, I didn't return the error code.

Acked-by: Haojian Zhuang <haojian.zhuang@linaro.org>

Regards
Haojian
