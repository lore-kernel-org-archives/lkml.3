Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964913AbaLMDSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 22:18:35 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:40163 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964843AbaLMDSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 22:18:34 -0500
Message-ID: <548BB000.8020202@lwfinger.net>
Date: Fri, 12 Dec 2014 21:18:24 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Krzysztof Konopko <kris@konagma.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
References: <1418336609-10191-1-git-send-email-kris@konagma.com> <548A2E7A.4010303@lwfinger.net> <548AD2F1.3080200@konagma.com> <548B2752.7030607@lwfinger.net> <548B7120.8010008@konagma.com>
In-Reply-To: <548B7120.8010008@konagma.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 04:50 PM, Krzysztof Konopko wrote:
> On 12/12/14 18:35, Larry Finger wrote:
>> On 12/12/2014 05:35 AM, Krzysztof Konopko wrote:
>>> On 12/12/14 00:53, Larry Finger wrote:
>>>> In particular, did you test on big-endian hardware after you
>>>> made this change?
>>>
>>> Nope.  I don't have any big-endian hardware.  I don't even have the
>>> wireless card TBH.  But I'm happy to try to get one.  Is Rtl8723AE the
>>> right model?
>>
>> No. The device numbers that end in E are PCIe and use a mac80211-based
>> driver. As none of my BE hardware has PCIe, I cannot test those drivers
>> on other than LE hardware. I do not have the hardware either for the
>> RTL8723AU. For that reason, I am careful when modifying the driver - I
>> let Jes do that.
>>
>
> Silly me.  'U' stands for USB here.  But can't find this device on any
> auction.  It's included in some ultrabooks but can't afford that for the
> sake of fixing some sparse warnings :)

There are no stand-alone USB devices that I have found for either RTL8723AU or 
RTL8723BU. The closest are modules CM-8723U and CM-8723BU by CC&C 
(http://www.ccandc.com.tw/) with RTL8723AU and RTL8723BU, respectively. The 
former is obsolete and no longer on the web site. These modules have D+ and D- 
connectors for USB, but they take 3.3 V, not 5. As a result, one would need some 
sort of voltage regulator circuit. That would not be complicated as it would 
consist of a TI LM2937-3.3 and a couple of capacitors. I wrote to them to see if 
I could get samples, but no response yet.

>> To be able to fix the kernel driver for RTL8188EU on PPC, I need to sort
>> out these endian problems. Once I do, I will port them to the other
>> drivers.
>>
>
> Isn't `sparse` useful here? :)

Yes, but the git repo works, and the kernel version does not, even though both 
do not have any Sparse warhings.

Larry


