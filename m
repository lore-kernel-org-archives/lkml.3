Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340Ab3CZJbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:31:14 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2890 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538Ab3CZJbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:31:12 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <51516AD4.8080306@broadcom.com>
Date: Tue, 26 Mar 2013 10:31:00 +0100
From: "Piotr Haber" <phaber@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "David Herrmann" <dh.herrmann@gmail.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Arend van Spriel" <arend@broadcom.com>,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
        "Pieter-Paul Giesberts" <pieterpg@broadcom.com>
Subject: Re: [PATCH regression/bisected] Revert
 "brcmsmac: support 4313iPA"
References: <1363603503-2378-1-git-send-email-dh.herrmann@gmail.com>
 <51471B85.5060404@broadcom.com>
 <CANq1E4TsM6yoSt9aELFan0ayEw3PSfYCe+PEe35YFHzZ-9rTuA@mail.gmail.com>
 <20130325185821.GB17454@tuxdriver.com>
In-Reply-To: <20130325185821.GB17454@tuxdriver.com>
X-Enigmail-Version: 1.1.1
X-WSS-ID: 7D4FB5BA2U84197884-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/13 19:58, John W. Linville wrote:
> On Mon, Mar 18, 2013 at 02:58:08PM +0100, David Herrmann wrote:
>> Hi Piotr
>>
>> On Mon, Mar 18, 2013 at 2:49 PM, Piotr Haber <phaber@broadcom.com> wrote:
>>> On 03/18/13 11:45, David Herrmann wrote:
>>>> This reverts commit b6fc28a158076ca2764edc9a6d1e1402f56e1c0c. It breaks
>>>> wireless AP reconnection on: (14e4:4727)
>>>>   Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller
>>>>
>>>> Any attempt to reconnect to an AP results in timeouts no matter how near to the
>>>> AP I am:
>>>>  00:10:40 $nb kernel: wlan0: authenticate with 00:18:39:0a:8e:23
>>>>  00:10:40 $nb kernel: wlan0: direct probe to 00:18:39:0a:8e:23 (try 1/3)
>>>>  00:10:40 $nb kernel: wlan0: direct probe to 00:18:39:0a:8e:23 (try 2/3)
>>>>  00:10:41 $nb kernel: wlan0: direct probe to 00:18:39:0a:8e:23 (try 3/3)
>>>>  00:10:41 $nb kernel: wlan0: authentication with 00:18:39:0a:8e:23 timed out
>>>> ---
>>>> Hi
>>>>
>>>> I tried coming up with a fix instead of reverting this commit, but the commit is
>>>> way to big for me to understand what's going on. Sorry.
>>>>
>>>> With linux-3.8 connecting to an AP broke on my machine. I could connect to an AP
>>>> one time, but any further attempt resulted in:
>>>>  00:10:40 $nb kernel: wlan0: authenticate with 00:18:39:0a:8e:23
>>>>  00:10:40 $nb kernel: wlan0: direct probe to 00:18:39:0a:8e:23 (try 1/3)
>>>>  00:10:40 $nb kernel: wlan0: direct probe to 00:18:39:0a:8e:23 (try 2/3)
>>>>  00:10:41 $nb kernel: wlan0: direct probe to 00:18:39:0a:8e:23 (try 3/3)
>>>>  00:10:41 $nb kernel: wlan0: authentication with 00:18:39:0a:8e:23 timed out
>>>>
>>>> Even sitting right next to the AP didn't help so I started bisecting and it
>>>> turned out to be:
>>>>   "brcmsmac: support 4313iPA" b6fc28a158076ca2764edc9a6d1e1402f56e1c0c
>>>> Please revert it.
>>>>
>>>> Thanks
>>>> David
>>>>
>>> Hi,
>>> unfortunately this is not a first report of this patch breaking 4313 for some users.
>>> I'm pretty confident that it is hardware revision related as we have 4313ePA and iPA boards running
>>> successfully in our test setup.
>>> Could you aid us in effort of finding the problem by supplying the contents of this debugfs file:
>>> <debugfs_mount>/brcmsmac/bcma0:0/hardware
>>
>> Hi
>>
>> $ cat /sys/kernel/debug/brcmsmac/bcma0\:0/hardware
>> board vendor: 185f
>> board type: 51a
>> board revision: 1408
>> board flags: 8402a01
>> board flags2: 880
>> firmware revision: 262032b
>>
>> I can also try partial reverts of that commit, but I really don't know
>> which parts might be important.
> 
> Are we going to see a fix for this (very) soon?  Or should I just go
> ahead and revert this patch?
> 
I cannot reproduce the issue on a set of devices we have here (3 different 4313 ePA models).
Some of the devices that are reported to be broken are being shipped to us.
So I would say we need around 2 weeks at least to resolve this (if we reproduce the problem and find
a fix).
Not sure this is soon enough.
If not please go ahead an revert the patch.





