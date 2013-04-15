Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3DOMNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:13:55 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:33833 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab3DOMNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:13:54 -0400
MIME-Version: 1.0
X-Originating-IP: [122.121.49.149]
In-Reply-To: <516BE5AE.3020703@stericsson.com>
References: <1365424274.21989.2.camel@phoenix>
	<516BB444.7010508@stericsson.com>
	<CAFRkauDHn88Y8cAemTNVCXW6WUVqvFfhw1iY174nepNymiU8Nw@mail.gmail.com>
	<CAFRkauDhqwcHtJU_uBf8wMmKr8DohHZnU6DNPBnzZhTp9-eBfg@mail.gmail.com>
	<516BE5AE.3020703@stericsson.com>
Date: Mon, 15 Apr 2013 20:13:53 +0800
Message-ID: <CAFRkauBzvdGrYizNZXivrzCdQ0btUamFL2hLjLX4rzS6fWhsWA@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab8500: Fix get_mode for shared mode regulators
From: Axel Lin <axel.lin@ingics.com>
To: =?ISO-8859-1?Q?Bengt_J=F6nsson?= <bengt.g.jonsson@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess what you don't like with the current approach is that the driver
> returns REGULATOR_MODE_IDLE in some cases where the mode register is set to
> LP. But I think, with patch applied, the control may be wrong in some cases
> because the regulator framework will call get_mode and see that the mode is
> already correct and not call set_mode so lp_mode_req will not get updated. I
I got your point now.

My point is get_mode() should always return "correct" status by
reading register value.
And as you mentioned, regulator_set_mode() did check current mode and won't call
set_mode callback if current mode is the same as the target mode.
And that is why this patch won't work.

However, Make get_mode() return "incorrect" status to avoid above
issue looks wrong to me.

Regards,
Axel
