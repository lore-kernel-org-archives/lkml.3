Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab3FXMOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:14:20 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:57405 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091Ab3FXMOS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:14:18 -0400
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olivier CLERGEAUD <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Date: Mon, 24 Jun 2013 14:13:59 +0200
Subject: Re: [PATCH v2 1/4] pinctrl: abx500: suppress hardcoded value
Thread-Topic: [PATCH v2 1/4] pinctrl: abx500: suppress hardcoded value
Thread-Index: Ac5w1FE//BuqNJ1dQr2MytQb/mCZsQ==
Message-ID: <51C83807.8060705@st.com>
References: <1371737145-27662-1-git-send-email-patrice.chotard.st@gmail.com>
 <1371737145-27662-2-git-send-email-patrice.chotard.st@gmail.com>
 <CACRpkdaAT4vEtthPgfd=yptpoK9GPdMx5w6VaQNe0+2WySwy1g@mail.gmail.com>
In-Reply-To: <CACRpkdaAT4vEtthPgfd=yptpoK9GPdMx5w6VaQNe0+2WySwy1g@mail.gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 01:29 PM, Linus Walleij wrote:

> On Thu, Jun 20, 2013 at 4:05 PM,  <patrice.chotard.st@gmail.com> wrote:
> 
>> From: Patrice Chotard <patrice.chotard@st.com>
>>
>> Replace hardcoded value by corresponding #define's.
>>
>> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
> 
> This is not so good. The commit message is saying it
> replaces values by #defines but is actually replacing it
> by an enum.
> 
> Then you're in each instance calling
> 
> abx500_gpio_set_bits(struct gpio_chip *chip, u8 reg,
>                 unsigned offset, int val)
> 
> The last argument is a hardware register value, but here you
> case an enum abx500_gpio_direction to an integer and pass
> to this function.
> 
> It would be better if the patch did what it says: create a
> #define for ABX500_GPIO_INPUT and ABX500_GPIO_OUTPUT
> locally in drivers/pinctrl/pinctrl-abx500.c and use it locally
> instead of touching <mfd/abx500/ab8500-gpio.h>.


Ok, i'll resubmit this

> 
> Thanks,
> Linus Walleij

