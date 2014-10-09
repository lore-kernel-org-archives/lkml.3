Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaJIV5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:57:09 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:54402 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaJIV5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:57:06 -0400
Message-ID: <543704AB.4030805@collabora.co.uk>
Date: Thu, 09 Oct 2014 23:56:59 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/5] regulator: dt-bindings: Add regulator-initial-mode
 support
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk> <1412775847-15213-4-git-send-email-javier.martinez@collabora.co.uk> <1412844355.1316.15.camel@AMDC1943> <5436A403.1050109@collabora.co.uk> <20141009190107.GY4609@sirena.org.uk>
In-Reply-To: <20141009190107.GY4609@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 09:01 PM, Mark Brown wrote:
> On Thu, Oct 09, 2014 at 05:04:35PM +0200, Javier Martinez Canillas wrote:
> 
>> Agree, Mark also pointed out that there is a difference between changing
>> how the regulator will behave on runtime vs changing how the regulator
>> will behave during system suspend. AFAIU from his explanation, the modes
>> defined in consumer.h only applies to the former and conceptually there
>> should be a difference between those two cases even when the Maxim PMIC
>> seems to mix it both in the data-sheet and by using the same field.
> 
> No, that's not accurate at all - you're still not getting the concepts
> of modes or suspend handling in the regulator API.  I really think you
> need to take a step back and try to understand what's currently there
> before trying to make changes here.  We've got a set of operations we
> can use to change the regulator configuration, if you look at the
> existing driver interface you'll see that these are matched with
> equivalent operations for setting the behaviour when in suspend
> (including a set_suspend_mode() operation).  
> 

I tried to say that there is a difference between the need to change
within the kernel a regulator configuration (e.g: change opmode from
normal to low power) when the system is going to enter in suspend state
vs setting a register at probe time that will force the PMIC to change
the regulator to low power mode on suspend without kernel intervention.

> Like I keep saying abstractions are really important to making sure the
> code is maintainable.
> 

Agree, I'll try to come up with a more sensible solution by using the
existing abstractions from the regulator framework.

Best regards,
Javier
