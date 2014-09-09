Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaIIXHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 19:07:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbaIIXHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 19:07:10 -0400
Message-ID: <540F8816.5080908@redhat.com>
Date: Wed, 10 Sep 2014 01:07:02 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Duggan <aduggan@synaptics.com>
CC: linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Christopher Heiny <cheiny@synaptics.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: synaptics - add support for ForcePads
References: <20140908165520.GA35051@core.coreip.homeip.net> <540EAFD1.2040307@redhat.com> <20140909170636.GA28774@core.coreip.homeip.net> <540F7A19.3070704@synaptics.com> <20140909225725.GA18901@core.coreip.homeip.net>
In-Reply-To: <20140909225725.GA18901@core.coreip.homeip.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/10/2014 12:57 AM, Dmitry Torokhov wrote:
> On Tue, Sep 09, 2014 at 03:07:21PM -0700, Andrew Duggan wrote:
>> On 09/09/2014 10:06 AM, Dmitry Torokhov wrote:
>>> On Tue, Sep 09, 2014 at 09:44:17AM +0200, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 09/08/2014 06:55 PM, Dmitry Torokhov wrote:
>>>>> ForcePads are found on HP EliteBook 1040 laptops. They lack any kind of
>>>>> physical buttons, instead they generate primary button click when user
>>>>> presses somewhat hard on the surface of the touchpad. Unfortunately they
>>>>> also report primary button click whenever there are 2 or more contacts
>>>>> on the pad, messing up all multi-finger gestures (2-finger scrolling,
>>>>> multi-finger tapping, etc). To cope with this behavior we introduce a
>>>>> delay (currently 50 msecs) in reporting primary press in case more
>>>>> contacts appear.
>>>>>
>>>>> For now we are using DMI matching to detect ForcePads, hopefully we'll
>>>>> be able to figure a better way down the road.
>>>> What about using the pnp-id, in my experience with the recent lenovo
>>>> laptops that tends to be more reliable.
>>> Not sure. So far I only know of HP 1040 having it. FWIW:
>>>
>>> dtor@dtor-glaptop:~$ cat /sys/bus/pnp/drivers/i8042\ aux/00\:07/id
>>> SYN300d
>>> SYN0100
>>> SYN0002
>>> PNP0f13
>>>
>>> I think if we see generalities we can switch over later. I hope
>>> Chris/Andrew will come with a capability bit though :)
>>
>> The ForcePad capabilities bit is 1 << 15.
> 
> Awesome, thanks!
> 
> Then I guess the patch below is what we'll be needing for these devices.

Yep, the patch looks good to me.

Regards,

Hans
