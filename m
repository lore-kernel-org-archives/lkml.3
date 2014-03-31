Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbaCaXrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:47:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51692 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaCaXrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:47:20 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5339FE84.80503@roeck-us.net>
Date: Mon, 31 Mar 2014 16:47:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Manuel Krause <manuelkrause@netscape.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, rui.zhang@intel.com
CC: Jean Delvare <jdelvare@suse.de>, lm-sensors@lm-sensors.org
Subject: Re: 3.13.?: Strange / dangerous fan policy...
References: <531A1EEE.9090101@netscape.net> <531B3E4C.2040105@roeck-us.net> <531BB171.1060208@netscape.net> <2833205.f1U4jaAo8e@vostro.rjw.lan> <531D1A3A.4040500@netscape.net> <531F8735.1010203@netscape.net> <532B4DC5.4010705@netscape.net> <5339FC31.3040601@netscape.net>
In-Reply-To: <5339FC31.3040601@netscape.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 04:37 PM, Manuel Krause wrote:
> On 2014-03-20 21:21, Manuel Krause wrote:
>> On 2014-03-11 22:59, Manuel Krause wrote:
>>> On 2014-03-10 02:49, Manuel Krause wrote:
>>>> On 2014-03-09 18:58, Rafael J. Wysocki wrote:
>>>>> On Sunday, March 09, 2014 01:10:25 AM Manuel Krause wrote:
>>>>>> On 2014-03-08 16:59, Guenter Roeck wrote:
>>>>>>> On 03/08/2014 03:08 AM, Jean Delvare wrote:
>>>>>>>> On Fri, 7 Mar 2014 14:52:30 -0800, Guenter Roeck wrote:
>>>>>>>>> On Fri, Mar 07, 2014 at 11:04:29PM +0100, Manuel Krause
>>>>>>>>> wrote:
>> [SNIP]
>>
>> Long time no reply from you... Have I overseen a unwritten
>> convention? Or were my charts that unusable for your analysis/work?
>>
>> Two days ago, I tried the 3.14.0-rc7-vanilla. And the problem
>> persists. "Strange / dangerous fan policy..."
>>
>> Since kernel 3.13.6 I've managed to 'fix' the potential
>> overheating problem by manually issuing a:
>> "echo 1 > /sys/class/thermal/cooling_device3/cur_state" *)
>> _before_ obviously critical temperatures occur. Remind: This
>> particular setting may only work for my system! ...and keeps
>> working for 3.14-rc.
>>
>> In the following I'd like to present you a modified output of my
>> /sys/class/thermal, that I've written a script for (for my
>> system), that shows the results in the way of
>> linux/Documentation/thermal/sysfs-api.txt, point 3:
>> {I've uploded the files to pastebin, to not swamp you and the
>> lists with so many lines of logs.}
>>
>> For the last good kernel -- 3.12.14 -- in-use:
>>   http://pastebin.com/HL1PNcda
>> For my first bad kernel revision 3.13 -- at critical temp:
>>   http://pastebin.com/98hgf1a9
>> For the last bad kernel -- 3.14.0-rc7 -- at critical temp:
>>   http://pastebin.com/MuTwTnjD
>> For the last bad kernel -- 3.14.0-rc7 -- after issuing the
>>   *) command:
>>   http://pastebin.com/2peda54z
>>
>> Please, have a look at them! And maybe, give me hints on how I
>> can help you to further debug this issue, as my manual method
>> works but it's annoying.
>>
>> And, PLEASE CC: ME, as I'm not on the lists. Or lead this
>> Email-thread to someone in charge.
>>
>> Thank you for your work && best regards,
>> Manuel Krause
>>
>
> This is still BUG 71711
> https://bugzilla.kernel.org/show_bug.cgi?id=71711
>
> 3.12.15 works very well
> 3.13.7 fails
> 3.14.0-rc8 fails
>

Best you can do would really be to bisect the problem.
Unfortunately only you (or someone else with an affected system)
can do that. Once the culprit is known it would be much easier
to get it fixed.

To answer your earlier question: I don't think you did anything wrong.
I guess everyone else is just as clueless as I am (if not, speak up
and help ;-).

Guenter

