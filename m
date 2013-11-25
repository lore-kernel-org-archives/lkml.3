Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3KYI7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:59:16 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:36503 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3KYI5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:57:35 -0500
Message-ID: <52931103.7030107@linaro.org>
Date: Mon, 25 Nov 2013 09:57:39 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] clocksource: Do not drop unheld reference on device node
References: <1382136588-15320-1-git-send-email-treding@nvidia.com> <20131122161607.GA5088@ulmo.nvidia.com> <528F86F2.40706@linaro.org> <20131122192257.GX28642@pengutronix.de> <52926F6F.3050104@linaro.org> <20131125072923.GB28642@pengutronix.de>
In-Reply-To: <20131125072923.GB28642@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 08:29 AM, Uwe Kleine-König wrote:
> Hello Daniel,
>
> On Sun, Nov 24, 2013 at 10:28:15PM +0100, Daniel Lezcano wrote:
>> On 11/22/2013 08:22 PM, Uwe Kleine-König wrote:
>>> On Fri, Nov 22, 2013 at 05:31:46PM +0100, Daniel Lezcano wrote:
>>>> On 11/22/2013 05:16 PM, Thierry Reding wrote:
>>>>> On Sat, Oct 19, 2013 at 12:49:48AM +0200, Thierry Reding wrote:
>>>> Yes. Sounds like I missed it.
>>>>
>>>> This regression has been introduced by:
>>>>
>>>> commit 326e31eebe61dc838e031ea16968b2cfb43443e3
>>>> Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>>>> Date:   Tue Oct 1 11:00:53 2013 +0200
>>>>
>>>>      clocksource: Put nodes passed to CLOCKSOURCE_OF_DECLARE
>>>> callbacks centrally
>>>>
>>>>      Instead of letting each driver call of_node_put do it centrally in the
>>>>      loop that also calls the CLOCKSOURCE_OF_DECLARE callbacks. This is less
>>>>      prone to error and also moves getting and putting the references
>>>> into the
>>>>      same function.
>>>>
>>>>      Consequently all respective of_node_put calls in drivers are removed.
>>>>
>>>>      Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>>>>      Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>>>      Acked-by: David Brown <davidb@codeaurora.org>
>>> Still all but the hook in clocksource_of_init of this commit was
>>> correct, right? (Well, but this buggy hunk makes the commit log wrong.)
>>
>> I don't understand your comment, can you elaborate ?
> My patch added an of_node_put in clocksource_of_init and dropped several
> of_node_puts in drivers. This thread is about the first being wrong. My
> question was if dropping the others was correct.

Yes, Thierry's patch removes the of_node_puts but I am also wondering if 
we shouldn't just revert the patch 326e31eebe61dc838e instead.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

