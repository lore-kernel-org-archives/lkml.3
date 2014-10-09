Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbaJIVk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:40:28 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:54371 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaJIVkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:40:23 -0400
Message-ID: <543700C1.7050909@collabora.co.uk>
Date: Thu, 09 Oct 2014 23:40:17 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 5/5] ARM: dts: Add initial regulator mode on exynos Peach
 boards
References: <20141008195112.GI4609@sirena.org.uk> <54369B59.8000509@collabora.co.uk> <20141009174848.GW4609@sirena.org.uk>
In-Reply-To: <20141009174848.GW4609@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

Thanks for your feedback.

On 10/09/2014 07:48 PM, Mark Brown wrote:
> On Thu, Oct 09, 2014 at 04:27:37PM +0200, Javier Martinez Canillas wrote:
> 
>> I see, I thought that an operating mode could be anything that alter the
>> regulator behavior either during runtime or when the system is suspended.
>> But under your definition, it is true that most max77802 regulators have
> 
> It's not just me, it's the code and all the users and documentation...
> 

Sorry, I didn't mean that you are not correct but more that I was wrong
on my assumptions.

>> only two modes: ON and OFF (and some of them have a third Low Power mode).
> 
> ...but let's be clear, only "on" (normal) and low power are modes here.
> Like I keep saying please think things through - if modes also include
> enable control why would they be treated separately in the API?
> 

Right, I got confused again by the terminology in the Maxim data-sheet that
list output OFF as an opmode but I understand that OFF is not a mode and
that the regulator API treats it separately.

>> I think though that a generic way to configure this enable control feature
>> is needed. Maybe adding a new pair of .{get,set}_suspend_control function
>> pointers to struct regulator_ops and an .initial_suspend_ctrl field to the
>> struct regulation_constraints?
> 
>> That way the core could parse a generic DT property and call the function
>> handlers but each driver can document in their own DT bindings what their
>> control values are and how those affects the regulators during suspend?
> 
> That maps poorly onto a lot of devices which have control schemes which
> are more complex than this, for example placing regulators into groups
> which are then controlled en masse or with internal sequencing options.
> There's also the general taste thing with an API that basically just
> consists of passing a random value through - there's a lack of
> generality there, it wouldn't be possible to write a generic user of the
> API which is a bit of a warning sign.
> 
> If you just care about the specific "this pin controls enable in sleep
> state" I'd suggest making an interface that very specifically does that.
> 

Yes, I'll not try to make it generic and will do something that is specific
to this device.

Best regards,
Javier
