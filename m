Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaIYHyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:54:36 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.40]:49642 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaIYHye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:54:34 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2014 03:54:34 EDT
Date: Thu, 25 Sep 2014 09:47:34 +0200 (CEST)
From: Nikolaus Voss <n.voss@weinmann-emt.de>
X-X-Sender: nv@fox.voss.local
To: Thierry Reding <thierry.reding@gmail.com>
cc: Bo Shen <voice.shen@atmel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: atmel-pwm: fix calculation of prescale value
In-Reply-To: <20140925065229.GD12423@ulmo>
Message-ID: <alpine.DEB.2.10.1409250934090.38376@fox.voss.local>
References: <20140924055851.CE51140656@mail.steuer-voss.de> <20140925065229.GD12423@ulmo>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Df-Sender: cG9zdGZpeEBzdGV1ZXItdm9zcy5kZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Thu, 25 Sep 2014, Thierry Reding wrote:
> Please Cc the linux-pwm@vger.kernel.org mailing list for PWM-related
> patches in the future.

ok, I ran get_maintainer.pl on an old kernel...

> Also a couple more comments:
>
> In the patch description: "pwm frequency" should be "PWM frequency".

ok.

>> +	div = (unsigned long long)clk_get_rate(atmel_pwm->clk) * period_ns;
>> +	do_div(div, (int)1e9);
>
> 1e9 should be NSEC_PER_SEC.
>

>> -		}
>> +		div >>= 1;
>> +		++pres;
>
> Unless you really need the prefix increment behaviour (you don't in this
> case) I prefer using the postfix operator because it is slightly more
> idiomatic.

ok (as I mostly do C++ programming, I prefer the prefix as it is usually
more efficient for user-defined types).

> No need for you to respin the patch, I've fixed up the above when
> applying.

Thanks!

Niko

