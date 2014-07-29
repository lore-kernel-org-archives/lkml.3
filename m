Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaG2NmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:42:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38114 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbaG2NmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:42:06 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: =?iso-8859-1?Q?Michal_Mal=FD?= <madcatxster@devoid-pointer.net>
CC: "simon@mungewell.org" <simon@mungewell.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Elias Vanderstuyft <elias.vds@gmail.com>
Subject: Re: [v2] input: drv260x: Add TI drv260x haptics driver
Thread-Topic: [v2] input: drv260x: Add TI drv260x haptics driver
Thread-Index: AQHPqoRzccs1z7hlMk6AmjOpJP7QQQ==
Date: Tue, 29 Jul 2014 13:41:57 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49DB2A71@DFLE09.ent.ti.com>
References: <1406566403-1436-1-git-send-email-dmurphy@ti.com>
 <5adf0339146a7b655a77053195aa892c.squirrel@mungewell.org>
 <00FC9A978A94B7418C33AFAE8A35ED49DB1A79@DFLE09.ent.ti.com>
 <2696156.zc98nP9bBH@sigyn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal

Thanks for the feedback

On 07/29/2014 07:09 AM, Michal Malý wrote:
> On Monday 28 of July 2014 21:21:26 Murphy, Dan wrote:
>> Dmitry
>>
>> On 07/28/2014 12:59 PM, simon@mungewell.org wrote:
>>>>> The initial driver supports the devices
>>>>> real time playback mode.  But the device
>>>>> has additional wave patterns in ROM.
>>>>
>>>> As it presented the device appears to be a memoryless device, however
>>>> you present it to the rest of the system as if it can support playback
>>>> of multiple effects simultaneously, which is incorrect.
>>>>
>>>> My guess that you need to engage the memoryless input library to schedule
>>>> handling multiple effects for your device, including ramping up, ramping
>>>> down, stopping playback when effects runs out, etc.
>>>
>>> Hi Dan,
>>> Elias and Michal (cc'ed) are working on a kernel/userland library to
>>> handle sending multiple force feedback signals to 'simple' devices,
>>> perhaps you should engage with them.
>>>
>>> Simon
> 
> Hi Dan,
> 
> since I spent some time trying to improve the memoryless library I can 
> hopefully provide you with some hints.
> 
> If I'm reading this right, your device cannot play more than one effect at once 
> but it can operate eihter in RTP mode where the user controls the operation of 
> the motors directly on in an automated mode where the device follows some pre-
> programmed waveform. These two modes are mutually exclusive.

Actually there is one other mode here, that is the ability to program in a
waveform to be played.  So that makes 3 modes I have to think about supporting.

I know there are products out there that would like to and do customize their feedback
based on certain user actions.

For the custom mode I could use the FF_CUSTOM id but not sure
how that fits into the Periodic structure.  If I can get two out of 3 that would be
great.

> 
> If my understanding of the problem is correct, you will struggle both with 
> memoryless library and your own imlementation. The memoryless library is quite 
> simplistic and it doesn't have any sort of "passthrough" mode so you would not 
> be able to do anything besides RTP that way.
> 
> On the other hand if you decide to write your own implementation of effect 
> handling you will end up duplicating a lot of code that already exists in the 
> memoryless library and has been proven to work.
> 
> A possible solution for the problem would be to separate the functions that 
> control effect timing from the memoryless library and make them globally 
> accessible. I believe that this would simplify any customized haptic 
> implementation considerably and it might be a decent interim solution before 
> the project Simon mentioned is ready.

How far are you on finishing the project?
If it is only a little bit out I can just keep with the memless RTP mode
as a start and then implement the other functions once the solution is accepted.

Dan

> 
> If there is anybody interested in such a solution I can probably whip up a 
> patch for it quite quickly.
> 
> Regards,
> Michal
> 


-- 
------------------
Dan Murphy
