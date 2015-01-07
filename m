Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbbAGITc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:19:32 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:42564 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbbAGITb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:19:31 -0500
Message-ID: <54ACEC10.5000508@schinagl.nl>
Date: Wed, 07 Jan 2015 09:19:28 +0100
From: Olliver Schinagl <oliver@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Olliver Schinagl <oliver+list@schinagl.nl>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] input: make use of the input_set_capability helper
References: <1420615866-3528-1-git-send-email-oliver+list@schinagl.nl> <20150107075703.GE5256@dtor-ws>
In-Reply-To: <20150107075703.GE5256@dtor-ws>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dmitry,

On 07-01-15 08:57, Dmitry Torokhov wrote:
> Hi Olliver,
>
> On Wed, Jan 07, 2015 at 08:31:06AM +0100, Olliver Schinagl wrote:
>> From: Olliver Schinagl <oliver@schinagl.nl>
>>
>> Almost all of the speaker drivers under input manipulate the ev bits
>> directly, which is not needed, as there is a helper available.
>>
>> This patch makes use of the helper for the speaker drivers.
>>
>> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
>> ---
>>   drivers/input/misc/cm109.c         | 4 ++--
>>   drivers/input/misc/ixp4xx-beeper.c | 5 ++---
>>   drivers/input/misc/m68kspkr.c      | 5 ++---
>>   drivers/input/misc/pcspkr.c        | 5 ++---
>>   drivers/input/misc/pwm-beeper.c    | 5 +----
>>   drivers/input/misc/sparcspkr.c     | 6 ++----
>>   6 files changed, 11 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
>> index 9365535..8e41070 100644
>> --- a/drivers/input/misc/cm109.c
>> +++ b/drivers/input/misc/cm109.c
>> @@ -767,10 +767,10 @@ static int cm109_usb_probe(struct usb_interface *intf,
>>   	input_dev->keycodesize = sizeof(unsigned char);
>>   	input_dev->keycodemax = ARRAY_SIZE(dev->keymap);
>>   
>> -	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_SND);
>> -	input_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
>> +	input_set_capability(input_dev, EV_SND, SND_BELL | SND_TONE);
> No, input_set_capability() takes single event code, not bitmask. The
> fact that it works for these 2 values of SND events is pure coincidence
> (the old code wasn't much better though).
What do you suggest we should do then? Fix input_set_capability to take 
bit masks? or multiline events?
I'm not sure why __set_bits() wouldn't work for bitmasks, could you 
educate me?
>
>>   
>>   	/* register available key events */
>> +	input_dev->evbit[0] = BIT_MASK(EV_KEY);
> Would prefer __set_bit(EV_KEY, input_dev->evbit); here instead.
I only moved the EV_KEY bit from above to its appropiate place here. I 
can change this one (and others) to use __set_bit() for now for v2?

Olliver
>
> Thanks.
>

