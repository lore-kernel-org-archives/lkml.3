Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaDCPHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:07:05 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:41278 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaDCPHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:07:00 -0400
Message-ID: <533D790C.5000104@ahsoftware.de>
Date: Thu, 03 Apr 2014 17:06:52 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH regression] net: phy: fix initialization (config_init)
 for Marvel 88E1116R PHYs
References: <1396396559-6971-1-git-send-email-holler@ahsoftware.de> <CAGVrzcZd9tBtcTY_2PRHVb9kJAjVHqn+EubUy4NGL66M_UuCDg@mail.gmail.com> <533BD3CD.1010905@ahsoftware.de> <CAGVrzcZi5aNq8fR795fKhu2TAc1tQCa2YEorErZRLf2n9DPZuw@mail.gmail.com> <533C721E.1080004@gmail.com> <533C8B49.8080704@ahsoftware.de> <533C8ECB.4090900@gmail.com> <533D0B09.9040602@ahsoftware.de> <533D207E.9020909@gmail.com>
In-Reply-To: <533D207E.9020909@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.04.2014 10:49, schrieb Sebastian Hesselbarth:
> On 04/03/2014 09:17 AM, Alexander Holler wrote:
>> Am 03.04.2014 00:27, schrieb Sebastian Hesselbarth:
>>> On 04/03/2014 12:12 AM, Alexander Holler wrote:
>>>>> I am curious, how you determined above commit to be the cause of the
>>>>> regression you are seeing. Can you bisect, if you didn't already?
>>>>
>>>> There was no bisecting necessary. I've just looked at what changed in
>>>> mv643xx_eth since 3.13 and the first commit I've reverted was already a
>>>> hit. Reading a bit source revealed the differences between the old reset
>>>> and the newly used one and ended up with my patch (first try) and was a
>>>> hit too.
>>>
>>> Honestly, your own fix changes a different driver than mv643xx_eth.
>>
>> It changes stuff which now (through the mentioned commit) gets used
>> through the change in mv643xx_eth.
>
> Sigh. You have proven youself that the commit isn't the root cause
> of the issue you are seeing. Nor is "fixing" 88e1116r init sequence
> a reasonable fix.

Sorry, continuing this discussion doesn't make sense. You have the same 
hw, so just try enabling netconsole with 3.14 and use dhcpcd from 
userland (this does the final reset here which hangs.

But don't suggest me (or insist on) a time consuming and totally useless 
bisect when I already know what makes the problem to appear (100% 
reliable here).

I have better ways to waste my time.

Alexander Holler
