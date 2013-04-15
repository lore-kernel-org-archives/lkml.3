Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554Ab3DOMlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:41:22 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:57131 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753638Ab3DOMlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:41:21 -0400
Message-ID: <516BF56A.5010401@stericsson.com>
Date: Mon, 15 Apr 2013 14:41:14 +0200
From: =?ISO-8859-1?Q?Bengt_J=F6nsson?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: ab8500: Fix get_mode for shared mode regulators
References: <1365424274.21989.2.camel@phoenix> <516BB444.7010508@stericsson.com> <CAFRkauDHn88Y8cAemTNVCXW6WUVqvFfhw1iY174nepNymiU8Nw@mail.gmail.com> <CAFRkauDhqwcHtJU_uBf8wMmKr8DohHZnU6DNPBnzZhTp9-eBfg@mail.gmail.com> <516BE5AE.3020703@stericsson.com> <CAFRkauBzvdGrYizNZXivrzCdQ0btUamFL2hLjLX4rzS6fWhsWA@mail.gmail.com>
In-Reply-To: <CAFRkauBzvdGrYizNZXivrzCdQ0btUamFL2hLjLX4rzS6fWhsWA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 02:13 PM, Axel Lin wrote:
>> I guess what you don't like with the current approach is that the driver
>> returns REGULATOR_MODE_IDLE in some cases where the mode register is set to
>> LP. But I think, with patch applied, the control may be wrong in some cases
>> because the regulator framework will call get_mode and see that the mode is
>> already correct and not call set_mode so lp_mode_req will not get updated. I
> I got your point now.
>
> My point is get_mode() should always return "correct" status by
> reading register value.
> And as you mentioned, regulator_set_mode() did check current mode and won't call
> set_mode callback if current mode is the same as the target mode.
> And that is why this patch won't work.
>
> However, Make get_mode() return "incorrect" status to avoid above
> issue looks wrong to me.
>
> Regards,
> Axel
I understand your point of view, but I think that the framework (as it 
is currently implemented) expects to get the requested mode of the 
regulator in this case, not the actual mode (in the shared mode 
register).The alternative could be to change the framework in some way.

Any ideas? Otherwise I propose to keep the code and maybe add a comment.

Regards,

Bengt
