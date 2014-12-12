Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaLLWuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 17:50:14 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61422 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaLLWuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 17:50:12 -0500
Message-ID: <548B7120.8010008@konagma.com>
Date: Fri, 12 Dec 2014 23:50:08 +0100
From: Krzysztof Konopko <kris@konagma.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
References: <1418336609-10191-1-git-send-email-kris@konagma.com> <548A2E7A.4010303@lwfinger.net> <548AD2F1.3080200@konagma.com> <548B2752.7030607@lwfinger.net>
In-Reply-To: <548B2752.7030607@lwfinger.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/14 18:35, Larry Finger wrote:
> On 12/12/2014 05:35 AM, Krzysztof Konopko wrote:
>> On 12/12/14 00:53, Larry Finger wrote:
>>> In particular, did you test on big-endian hardware after you
>>> made this change?
>>
>> Nope.  I don't have any big-endian hardware.  I don't even have the
>> wireless card TBH.  But I'm happy to try to get one.  Is Rtl8723AE the
>> right model?
> 
> No. The device numbers that end in E are PCIe and use a mac80211-based
> driver. As none of my BE hardware has PCIe, I cannot test those drivers
> on other than LE hardware. I do not have the hardware either for the
> RTL8723AU. For that reason, I am careful when modifying the driver - I
> let Jes do that.
> 

Silly me.  'U' stands for USB here.  But can't find this device on any
auction.  It's included in some ultrabooks but can't afford that for the
sake of fixing some sparse warnings :)

>>> In RTL8188EU, both BA_starting_seqctrl and TXOP_limit are unsigned
>>> short.
>>>
>>
>> That's not quite the case.  `TXOP_limit` is __le16 in RTL8188EU [1].
>> It's __le16 even in your GitHub repo [2].  And that made me thinking
>> that there's probably some inconsistency in the header.
> 
> All the USB drivers are a mess. The kernel version of rtl8188eu does not
> work on PPC; however, the git repo now does. I'm working on finding the
> differences and fixing the kernel version.
> 

Right.  I found your introductory message:
https://lkml.org/lkml/2013/4/1/280

>> I was hunting particularly for inconsistencies with `sparse` and came
>> across this one.  But I dug a bit further and I wonder why the driver is
>> not using standard stuff like the one in `include/linux/ieee80211.h`
>> where any data wider than one byte is clearly declared as __le<nn>?
> 
> That is a good question. One possibility is that those definitions do
> not exist on some of the older kernels that Realtek supports. They
> generally work with 2.6.18 and newer.
>

That would be important if the driver was kept out of the tree.  Isn't
it the point of having the driver in the mainline to keep up with the
kernel and don't bother with older versions?

> To be able to fix the kernel driver for RTL8188EU on PPC, I need to sort
> out these endian problems. Once I do, I will port them to the other
> drivers.
> 

Isn't `sparse` useful here? :)

Kris

