Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaI2Nh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:37:58 -0400
Received: from rhcavuit02.kulnet.kuleuven.be ([134.58.240.130]:41536 "EHLO
	cavuit02.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754862AbaI2Nh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:37:57 -0400
X-KULeuven-Envelope-From: bart.tanghe@thomasmore.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: B68C31280CE.A3029
X-KULeuven-Information: Katholieke Universiteit Leuven
Message-ID: <542960AE.1040200@thomasmore.be>
Date: Mon, 29 Sep 2014 15:37:50 +0200
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From: Bart Tanghe <bart.tanghe@thomasmore.be>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: matt.porter@linaro.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-rpi-kernel@lists.infradead.org
Subject: Re: [resend rfc v3] pwm: add BCM2835 PWM driver
References: <1398689686-30317-1-git-send-email-bart.tanghe@thomasmore.be> <20140825131908.GG4163@ulmo.nvidia.com> <5408395E.2030305@thomasmore.be> <54088008.9080200@wwwdotorg.org> <20140926071109.GA31106@ulmo> <54257C25.2000308@wwwdotorg.org> <20140929053311.GA12506@ulmo>
In-Reply-To: <20140929053311.GA12506@ulmo>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-29 07:33, Thierry Reding wrote:
> On Fri, Sep 26, 2014 at 08:45:57AM -0600, Stephen Warren wrote:
>> On 09/26/2014 01:11 AM, Thierry Reding wrote:
>>> On Thu, Sep 04, 2014 at 09:06:48AM -0600, Stephen Warren wrote:
> [...]
>>>> Oh dear. It sounds like we need at least some form of clock driver for the
>>>> platform then. I still don't think there's complete documentation for the
>>>> HW, even though a lot of register docs were published which presumably cover
>>>> the clock HW? Equally, given that the VC firmware assumes it owns most of
>>>> the HW, it seems best to manipulate the clocks through the firmware
>>>> interface rather than directly touching the HW. Unfortunately, I don't
>>>> believe there's any ABI guarantee on the firmware interface. Perhaps we can
>>>> get one?
>>>
>>> Urgs... this VC firmware seems to be more of a headache that I thought
>>> it was. How is this handled in other drivers? Surely PWM isn't the first
>>> one that needs clocks?
>>
>> For the other clocks, I've set up dummy fixed-rate clocks in the DT and/or
>> "clock driver" code to satisfy references by phandle or clock name
>> respectively. Since the other drivers don't actually manipulate the clock
>> rates etc., this is enough for the drivers.
> 
> Given that this driver only queries the clock frequency adding a fixed-
> rate clock to the device tree should work as well. Then the calls to
> clk_prepare_enable() and clk_disable_unprepare() can still be added as
> appropriate so that the driver doesn't need to change if a proper clock
> driver ever gets added.
> 
> Or am I missing anything? Perhaps the issue is that the default clock
> rate for the PWM clock isn't usable? That would still not prevent the
> driver from being merged.
> 
> Thierry
> 
The pwm clock is default unusable. To let the pwm clock run, It's necessary to change some 
clock registers. I've added the clk_prepare_enable and the clk_disable_unprepare functions. So the 
driver is able to work with a proper clock driver in the future.

Bart
  
