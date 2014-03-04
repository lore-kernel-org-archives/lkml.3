Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaCDRi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:38:57 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39849 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbaCDRiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:38:55 -0500
Message-ID: <53160F8F.9060405@ti.com>
Date: Tue, 4 Mar 2014 11:38:23 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>, Ohad Ben-Cohen <ohad@wizery.com>
CC: Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv4 4/7] hwspinlock/core: add common OF helpers
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>	<1389658764-39199-5-git-send-email-s-anna@ti.com>	<CAJAp7Oi7wD+VsMAd37gT04yZ4TH4ygXFmheDhvmWuanUjpBmVQ@mail.gmail.com>	<52F92524.3080402@ti.com>	<CAK=WgbY0wDtGCm71E8VXi2g5+VcGogHEy8jdekTRg8xtp6-3rQ@mail.gmail.com> <CAJAp7Ohf43hbKatCwS5Y1+OfEkJYWOkuhZhW-E_=t_9mfM+UaA@mail.gmail.com>
In-Reply-To: <CAJAp7Ohf43hbKatCwS5Y1+OfEkJYWOkuhZhW-E_=t_9mfM+UaA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 03/02/2014 02:19 PM, Bjorn Andersson wrote:
> On Sat, Mar 1, 2014 at 9:14 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> On Mon, Feb 10, 2014 at 9:14 PM, Suman Anna <s-anna@ti.com> wrote:
>>> On 02/07/2014 04:49 PM, Bjorn Andersson wrote:
>>>> It seems to be standard practice to pass the error value back to the
>>>> consumer, so you should
>>>> return ERR_PTR(ret); here instead of the NULL...
>>>
>>>
>>> I have modelled the return values in this function based on the return
>>> values in the existing hwspin_lock_request interfaces. I would need to
>>> change those functions as well.
>>>
>>> Ohad,
>>> Do you have any objections to the return code convention change?
>>
>> Unless strictly needed, I prefer we don't switch to the ERR_PTR code
>> convention, as it reduces code readability and increases chances of
>> user bugs.
>>
>> In our case, switching to ERR_PTR and friends seems only to optimize a
>> few error paths, and I'm not sure it's a big win over simplicity.
>
> When introducing the ability to reference a hwspin lock via a phandle
> in device tree it makes a big difference to be able to differ between
> the case of "initialization failed" or "device not yet probed"; so
> that the client knows if it should fail or retry later.
>

Can you confirm the changes you want me to make, so that I can refresh 
and post a v5 for 3.15?

regards
Suman

