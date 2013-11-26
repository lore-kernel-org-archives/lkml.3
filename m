Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab3KZTwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:52:00 -0500
Received: from mail.active-venture.com ([67.228.131.205]:61354 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019Ab3KZTv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:51:56 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <5294FBD5.8030005@roeck-us.net>
Date: Tue, 26 Nov 2013 11:51:49 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Wim Van Sebroeck <wim@iguana.be>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-watchdog@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] watchdog: core: Fix watchdog_init_timeout() when
 invalid param / valid dt
References: <1385490173-7511-1-git-send-email-dianders@chromium.org>	<1385490173-7511-2-git-send-email-dianders@chromium.org>	<5294EF42.3090001@roeck-us.net> <CAD=FV=W0Op73P2f5KSWhOG+34N8OyeKUzS17ot3BTtzULApv8A@mail.gmail.com>
In-Reply-To: <CAD=FV=W0Op73P2f5KSWhOG+34N8OyeKUzS17ot3BTtzULApv8A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 11:23 AM, Doug Anderson wrote:
> Guenter,
>
> Thanks for your reviews!
>
> On Tue, Nov 26, 2013 at 10:58 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On 11/26/2013 10:22 AM, Doug Anderson wrote:
>>>
>>> There was a minor bug in watchdog_init_timeout() where it would return
>>> an error code if someone specified an invalid parameter on the
>>> command line but then there was a valid parameter in the device tree
>>> as "timeout-sec".
>>>
>>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>>
>>
>> I thought that was on purpose.
>>
>> Problem as I see it is that users would expect the timeout to be set to
>> the provided parameter, which would be silently ignored and replaced
>> by timeout-sec if the parameter is wrong and timeout-sec is specified.
>> Seems to me that the user should be informed about the problem,
>> and not be permitted to provide invalid parameters.
>
> Wow, really?  ...so it's on purpose that the function will properly
> read the device tree entry and fill it in but still return an error?
>
I said "I thought ...", which wasn't meant to imply that I know.
Maybe Wim should comment and provide directions.

> I guess that can make some sense (treating device tree as an extension
> of the "default"), though it's non-obvious enough to me that it feels
> like it deserves some documentation.  I'd also question the value of
> the return code from this function anyway.  I'd vote for:
>
> 1. If param is non-zero and invalid, dev_warn() in this function.
>
> 2. If "timeout-sec" is specified in device tree and invalid,
> dev_warn() in this function.
>
Makes sense to me. Again up to Wim to provide direction.

> Function doesn't need to return an error code.  ...or if we keep it
> then nobody should be looking at it.  They should be putting their
> default in "timeout" before calling the function and trusting that the
> function will do the right thing and update it as needed.
>
>
> In practice only one caller ever checks this result in the code I'm
> looking at (at91sam9_wdt) and it's a little confusing what that's
> trying to do.  It does look like it would be broken by my suggestions
> above.  I guess it's trying to do:
> 1. device tree first (always passes 0 as the "param")
> 2. a value based on the patting heartbeat second.
> 3. the value WDT_HEARTBEAT third (starts in ->timeout)
>
I thought the idea was to give drivers the ability to handle errors
this way. Notice the "thought" ... I may be wrong.

>
> In any case I'm OK with just dropping this patch.  The code looked
> wrong and so I thought I'd fix it up, but I have no real need to see
> it land (we don't use kernel parameters for things like this) in
> Chrome OS.  I'm also happy to spin it if there is some interest.
>

It is really be up to Wim to decide what to do, so I'll defer to him.

Thanks,
Guenter

