Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbaCNI7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 04:59:16 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33318 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbaCNI7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 04:59:07 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.70.16]
In-Reply-To: <53160F8F.9060405@ti.com>
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>
 <1389658764-39199-5-git-send-email-s-anna@ti.com> <CAJAp7Oi7wD+VsMAd37gT04yZ4TH4ygXFmheDhvmWuanUjpBmVQ@mail.gmail.com>
 <52F92524.3080402@ti.com> <CAK=WgbY0wDtGCm71E8VXi2g5+VcGogHEy8jdekTRg8xtp6-3rQ@mail.gmail.com>
 <CAJAp7Ohf43hbKatCwS5Y1+OfEkJYWOkuhZhW-E_=t_9mfM+UaA@mail.gmail.com> <53160F8F.9060405@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 14 Mar 2014 10:58:45 +0200
Message-ID: <CAK=WgbbaF+=3euYNBd6FbKW62mCBs_fbDnRxkSNR9QknGZnwSw@mail.gmail.com>
Subject: Re: [PATCHv4 4/7] hwspinlock/core: add common OF helpers
To: Suman Anna <s-anna@ti.com>
Cc: Bjorn Andersson <bjorn@kryo.se>, Mark Rutland <mark.rutland@arm.com>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Tue, Mar 4, 2014 at 7:38 PM, Suman Anna <s-anna@ti.com> wrote:
>>>> Do you have any objections to the return code convention change?
>>>
>>> Unless strictly needed, I prefer we don't switch to the ERR_PTR code
>>> convention, as it reduces code readability and increases chances of
>>> user bugs.
>>>
>>> In our case, switching to ERR_PTR and friends seems only to optimize a
>>> few error paths, and I'm not sure it's a big win over simplicity.
>>
>>
>> When introducing the ability to reference a hwspin lock via a phandle
>> in device tree it makes a big difference to be able to differ between
>> the case of "initialization failed" or "device not yet probed"; so
>> that the client knows if it should fail or retry later.
>>
>
> Can you confirm the changes you want me to make, so that I can refresh and
> post a v5 for 3.15?

Sorry, I missed your replies for some reason.

I prefer we stick with the current error handling code because I find
the alternative inferior (as long as it's not strictly needed).

Thanks,
Ohad.
