Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab3CEPj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:39:28 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:35519 "HELO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755230Ab3CEPj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:39:26 -0500
Message-ID: <513611AA.30304@epfl.ch>
Date: Tue, 05 Mar 2013 16:39:22 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>
Subject: Re: [PATCH v3 3/3] leds: leds-pwm: Defer led_pwm_set() if PWM can
 sleep
References: <1359381659-24454-1-git-send-email-florian.vaussard@epfl.ch> <1359381659-24454-4-git-send-email-florian.vaussard@epfl.ch> <20130130081728.GC13568@avionic-0098.mockup.avionic-design.de> <512E2F98.6070404@epfl.ch> <51347B06.8090604@epfl.ch> <20130304105806.GA28735@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130304105806.GA28735@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/04/2013 11:58 AM, Thierry Reding wrote:
> On Mon, Mar 04, 2013 at 11:44:22AM +0100, Florian Vaussard wrote:
>> Hi Bryan, Richard,
>>
>>> On 01/30/2013 09:17 AM, Thierry Reding wrote:
>>>> On Mon, Jan 28, 2013 at 03:00:59PM +0100, Florian Vaussard wrote:
>>>>> Call to led_pwm_set() can happen inside atomic context, like triggers.
>>>>> If the PWM call can sleep, defer using a worker.
>>>>>
>>>>> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
>>>>> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
>>>>> ---
>>>>>   drivers/leds/leds-pwm.c |   50
>>>>> +++++++++++++++++++++++++++++++++++++++-------
>>>>>   1 files changed, 42 insertions(+), 8 deletions(-)
>>>>
>>>> Bryan, I assume that you'll be taking this? It doesn't apply cleanly to
>>>> my tree, probably because of Peter's recent changes that you took
>>>> through your tree and Florian based his patches on top of that. The
>>>> conflict resolution should be trivial, though.
>>>>
>>>
>>> It seems that this patch was not taken. Could you pull it, as the other
>>> part is already in linux-pwm? Or is there any show stopper?
>>>
>>
>> Ping? Who should merge this?
>
> I assume Bryan will take it through the LED tree? Patches 1 & 2 went
> into v3.9-rc1 through the PWM tree.
>

This was also my assumption, but I never got the feedback from Brian on 
this patch.
The crach is still there, and the patch missed the merge window :)

Cheers,

Florian
