Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaKYIJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 03:09:35 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5019 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaKYIJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 03:09:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 25 Nov 2014 00:08:23 -0800
Message-ID: <5474391F.6030908@nvidia.com>
Date: Tue, 25 Nov 2014 17:09:03 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?windows-1252?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>
Subject: Re: [PATCH] gpio: remove const modifier from gpiod_get_direction()
References: <1416900045-2304-1-git-send-email-acourbot@nvidia.com> <20141125080122.GY4431@pengutronix.de>
In-Reply-To: <20141125080122.GY4431@pengutronix.de>
X-NVConfidentiality: public
X-Originating-IP: [10.19.57.128]
X-ClientProxiedBy: DRBGMAIL101.nvidia.com (10.18.16.20) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 05:01 PM, Uwe Kleine-König wrote:
> Hello Alexandre,
>
> just some minor nitpicking on the commit log:
>
> On Tue, Nov 25, 2014 at 04:20:45PM +0900, Alexandre Courbot wrote:
>> Although gpiod_get_direction() can be considered side-effect free for
>> consumers, its internals involve setting or clearing bits in the
>> affected GPIO descriptor, for which we need to force-cast the const
>> descriptor parameter. This could lead to incorrect behavior is the
> s/ is/ if/, and I think s/parameter/variable to non-const/
>
>> compiler decide to optimize here, so remove this const parameter. The
> s/decide/decides/; s/parameter/attribute/
>
>> intent is to make gpiod_get_direction() private anyway, so it does not
>> really matter.
>>
>> Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks ; I should have proof-read myself...

Sending a v2 with a fixed log and your Ack so Linus can just pick the 
patch as-is.
