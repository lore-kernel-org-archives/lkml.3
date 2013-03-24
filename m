Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab3CXVlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 17:41:55 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33110 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754767Ab3CXVlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 17:41:53 -0400
Message-ID: <514F7419.4010104@iki.fi>
Date: Sun, 24 Mar 2013 23:46:01 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:19.0) Gecko/20100101 SeaMonkey/2.16.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2] ADP1653 board code for Nokia RX-51
References: <201302171616.50152@pali> <20130306214440.GA11874@earth.universe> <20130307221827.GE31984@valkosipuli.retiisi.org.uk> <201303241519.49243@pali>
In-Reply-To: <201303241519.49243@pali>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pali,

Pali Rohár wrote:
> On Thursday 07 March 2013 23:18:27 Sakari Ailus wrote:
>> Hi guys,
>>
>> On Wed, Mar 06, 2013 at 10:44:41PM +0100, Sebastian Reichel 
> wrote:
>>> On Wed, Mar 06, 2013 at 09:20:16PM +0100, Pali Rohár wrote:
>>>> On Wednesday 06 March 2013 21:12:06 Pali Rohár wrote:
>>>>> On Sunday 17 February 2013 20:03:03 Aaro Koskinen wrote:
>>>>>> On Sun, Feb 17, 2013 at 04:16:49PM +0100, Pali Rohár 
> wrote:
>>>>>>> +/*
>>>>>>> + * arch/arm/mach-omap2/board-rx51-camera.c
>>>>>>> + *
>>>>>>> + * Copyright (C) 2008 Nokia Corporation
>>>>>>> + *
>>>>>>> + * Contact: Sakari Ailus <sakari.ailus@nokia.com>
>>>>>>> + *          Tuukka Toivonen
>>>>>>> <tuukka.o.toivonen@nokia.com>
>>>>>>
>>>>>> You should put these people to CC... Just to see if
>>>>>> the addresses are still valid (which I doubt).
>>>>>
>>>>> Ok, trying :-)
>>>>
>>>> I got "Delivery Status Notification (Failure)" for both
>>>> addresses.
>>
>> This is expected.
>>
>>> Sakari Ailus hosts some code on github [0], which has the
>>> following email address:
>>> sakari.ailus+gitorious@retiisi.org.uk
>>>
>>> I added it to this mail's CC.
>>>
>>> [0] https://gitorious.org/~sailus
>>
>> Nice to hear people are interested in this. ;-)
>>
>> The primary reason I haven't tried submitting this to mainline
>> is that ARM board code has a bad reputation these days. The
>> N900 does not have yet support for device tree (AFAIK), which
>> also would require a few bits and pieces on the flash driver
>> to work.
>>
>> Also the sensor and lens drivers would need at least some work
>> before being ready for submission to mainline for camera to
>> be usable. Unfortunately I haven't had recently time to work
>> on this. N9(50) support has higher priority for myself. That,
>> too, is pending the DT support for the device.
>>
>> There's indeed more up-to-date code in my repository. Even if
>> it's not too close to mainline anymore it should be a better
>> starting point than the old kernel from MeeGo.
>>
>> <URL:https://gitorious.org/omap3camera/pages/Home>
> 
> Hi,
> 
> this board code is same in your git repository and on meego obs.
> 
> Patch only adding support for adp1653 driver which is already in 
> upstream kernel.
> 
> Are there any other problems with this patch to go for upstream?

A few more things comes to mind. We depend a little bit on actual board
code; it's not only static data. That's the configuration of the
external clock from the ISP to the sensor. That should move to the
common clock framework so that the ISP registers the clock and the
sensor driver can then use it. AFAIR Laurent has done some work on that.

The peculiar detail of the rx51 is that there's a switch on the camera
CCP2 bus that selects either sensor (primary or secondary). Both sensors
are connected to the same receiver. That isn't properly modelled
currently at all, so that's why we have rx51_camera_set_xshutdown(). I
guess it'd still work if you only power (i.e. open) either of the
devices at a time, though.

That should be all.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
