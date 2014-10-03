Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaJCKTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 06:19:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaJCKTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 06:19:03 -0400
Message-ID: <542E780B.7030103@redhat.com>
Date: Fri, 03 Oct 2014 12:18:51 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] input: alps: Reset mouse and ALPS driver immediately
 after first invalid packet
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com> <1412329392-5580-4-git-send-email-pali.rohar@gmail.com> <542E72A8.2030908@redhat.com> <201410031205.42927@pali>
In-Reply-To: <201410031205.42927@pali>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/03/2014 12:05 PM, Pali Rohár wrote:
> On Friday 03 October 2014 11:55:52 Hans de Goede wrote:
>> Hi,
>>
>> On 10/03/2014 11:43 AM, Pali Rohár wrote:
>>> For unknown reasons linux psmouse alps driver sometimes
>>> receive totally invalid packet sequences on Dell Latitude
>>> laptops. According to ALPS HW engineers these invalid
>>> packets do not come from ALPS devices. So it looks like bug
>>> in BIOS and EC incorrectly split keyboard and touchpad PS/2
>>> data when laptops are under heavy loads (big I/O together
>>> with powersave governor, running on battery).
>>>
>>> There are sequences of invalid packets (which are dropeed)
>>> and some sequences which look like valid. But these valid
>>> packets cause random trackstick button pressing, random
>>> cursor moving/jumping and in these condition it is not
>>> possible to use ALPS device (trackstick+touchpad).
>>>
>>> To prevent random button press and random cursor jumps
>>> immediately reset ALPS device after first invalid packet.
>>> This will cause that touchpad and trackstick will not
>>> respond for one or two seconds and it better then random
>>> cursor jumps.
>>
>> This one probably should have:
>>
>> Bug: https://bugzilla.redhat.com/show_bug.cgi?id=1145954
>>
> 
> Yes, in that bug is described same problem as on my E6440.
> 
>> And you may want to add Bug: tags to the relevant patches for
>> the launchpad issues too.
>>

OK, so lets just reference the RH bug then, and leave the others
out.

> 
> I just added links to famous ALPS bugs which looks like that one 
> which I have on my E6440. But I'm not sure if my patches will 
> resolve these problems on other machines too.
> 
>> While on the topic of tags, once we've agreed upon the return
>> value to use for the 2nd patch, can you please resend with a
>> "Cc: stable@vger.kernel.org" added to all 3 patches?
>>
> 
> I would like if somebody else can test patches on other machines 
> with ALPS devices. Specially this third if it does not break 
> something else.

In my experience with ALPS devices, they normally never cause
PSMOUSE_BAD_DATA errors, so I would not worry about regressing
because of that.

> Note that this third patch does not fixing problem correctly with 
> jumping & clicking. It just immediately reset ps/2 device if it 
> receive invalid packages. So it only try to prevent jumping & 
> clicking.

I understand, but that seems to be the best we can do for now.

> On my E6440 machine it somehow working. When driver 
> doing ps/2 reset keyboard, touchpad and trackstick not 
> responding.

Right, but I would expect that to be for only a short period of
time, or does the whole reset take a significant amount of time ?

> I think it is better then having random clicks but 
> somebody else really should try and test patches how it will work 
> on other machines.
> 
> Proper fix would be to understand why invalid packets are 
> received and try to force buggy component to not send these 
> invalid packets.

Regards,

Hans
