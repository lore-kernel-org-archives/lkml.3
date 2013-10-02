Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3JBBJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:09:33 -0400
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47714 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751230Ab3JBBJc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:09:32 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: applesmc oops in 3.10/3.11
From: Chris Murphy <bugzilla@colorremedies.com>
In-Reply-To: <20131001162425.GD14887@roeck-us.net>
Date: Tue, 1 Oct 2013 19:09:26 -0600
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <28FA6820-7FB5-4D33-ABC9-1F2088FA22A6@colorremedies.com>
References: <20130927171256.GA6391@roeck-us.net> <71D92187-2092-4975-A707-17452C48EF5A@colorremedies.com> <20130927175926.GA6267@roeck-us.net> <B6E9FB4C-665C-454E-9DEB-B95B85C1D0E0@colorremedies.com> <524615B1.6000106@roeck-us.net> <4FFB3671-DDB4-40F7-BA5D-C9AA9391BDA9@colorremedies.com> <524A4384.4040403@roeck-us.net> <20131001105526.GA481@polaris.bitmath.org> <20131001151954.GB14887@roeck-us.net> <C10D98EE-28FE-4BFE-BDE5-1EAABF112AC2@colorremedies.com> <20131001162425.GD14887@roeck-us.net>
To: Guenter Roeck <linux@roeck-us.net>
X-Mailer: Apple Mail (2.1510)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - slmp-550-94.slc.westdc.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - colorremedies.com
X-Get-Message-Sender-Via: slmp-550-94.slc.westdc.net: authenticated_id: whatever@colorremedies.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 1, 2013, at 10:24 AM, Guenter Roeck <linux@roeck-us.net> wrote:

> On Tue, Oct 01, 2013 at 09:33:13AM -0600, Chris Murphy wrote:
>> 
>> On Oct 1, 2013, at 9:19 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> 
>>> On Tue, Oct 01, 2013 at 12:55:26PM +0200, Henrik Rydberg wrote:
>>>>>> Warning message triggered with 3.12.0-0.rc3.git0.1.fc21.x86_64.
>>>>>> 
>>>>>> [   10.886016] applesmc: key count changed from 261 to 1174405121
>>>>>> 
>>>>> 
>>>>> Explains the crash, but the new key count is very wrong. 1174405121 = 0x46000001.
>>>>> Which I guess explains the subsequent memory allocation error in the log.
>>>>> 
>>>>> Henrik, any idea what might be going on ? Is it possible that the previous
>>>>> command failure leaves some state machine in a bad state ?
>>>> 
>>>> I seem to recall a report on another similar state problem on newer
>>>> machines, so maybe, yes. Older machines seem fine, I have never
>>>> encountered the problem myself. Here is a patch to test that
>>>> theory. It has been tested to be pretty harmless on two different
>>>> generations.
>>>> 
>>>> I really really do not want to add an 'if (value is insane)' check ;-)
>>>> 
>>> Chris,
>>> 
>>> any chance you can load this patch on an affected machine so we can get
>>> test feedback ? This one is too experimental to submit upstream without
>>> knowing that it really fixes the problem.
>> 
>> Yes. What kernel.org source version should I apply it against? I'd use the non-debug config file from an equivalent version Fedora kernel, unless asked otherwise. And also should I test it on other vintages? I have here MBP4,1(2008); MBP8,2(2011), and MBP10,2(2012).
>> 
> Only requirement is that it also includes the previous patch, so it would be
> optimal if you can apply it on top of the previous image.

Patch added on top of 3.12.0-0.rc3.git0.1.fc20.x86_64 and built. But after ~dozen reboots, I'm not triggering the problem. The only items in dmesg with smc in it:

[   13.799819] applesmc: key=261 fan=2 temp=14 index=14 acc=1 lux=2 kbd=1
[   13.833402] input: applesmc as /devices/platform/applesmc.768/input/input10


Chris