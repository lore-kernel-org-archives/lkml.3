Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab3GPS36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:29:58 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:36613 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958Ab3GPS34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:29:56 -0400
Message-ID: <51E5913D.3080205@gmail.com>
Date: Tue, 16 Jul 2013 20:30:21 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: v3.11-rc1 USB regressions
References: <20130715225647.GE3296@blackmetal.musicnaut.iki.fi> <51E4E922.2040707@gmail.com> <51E4EF70.3040502@ti.com> <20130716080836.GC8880@arwen.pp.htv.fi> <20130716082247.GD8880@arwen.pp.htv.fi> <20130716182601.GB14385@blackmetal.musicnaut.iki.fi>
In-Reply-To: <20130716182601.GB14385@blackmetal.musicnaut.iki.fi>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.07.2013 20:26, Aaro Koskinen wrote:
> Hi,
> 
> On Tue, Jul 16, 2013 at 11:22:47AM +0300, Felipe Balbi wrote:
>>> On Tue, Jul 16, 2013 at 12:30:00PM +0530, Kishon Vijay Abraham I wrote:
>>>> On Tuesday 16 July 2013 12:03 PM, Daniel Mack wrote:
>>>>> Hi Aaro,
>>>>>
>>>>> On 16.07.2013 00:56, Aaro Koskinen wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I think USB tree introduced regressions in v3.11-rc1, at least for some
>>>>>> OMAP devices using legacy boot.
>>>>>
>>>>> Thanks for checking the tree so early.
>>>>>
>>>>>> I have only bisected these; I have no
>>>>>> idea what the real fixes are but the following reverts make Nokia OMAP2+
>>>>>> boards again usable for kernel development work (they need working USB
>>>>>> connection for interacting with the device):
>>>>>>
>>>>>> 1) USB peripheral mode (g_ether) is broken on Nokia N900, N950 and N9
>>>>>>    (USB_MUSB_OMAP2PLUS). To make it it work, I need to revert three
>>>>>>    commits:
>>>>>>
>>>>>> 	09fc7d22b024692b2fe8a943b246de1af307132b
>>>>>> 	usb: musb: fix incorrect usage of resource pointer
>>>>>> 	(Reverting this fixes the g_ether probe failure "couldn't find
>>>>>> 	 an available UDC")
>>>>
>>>> I've posted a patch fixing the issue
>>>> http://comments.gmane.org/gmane.linux.usb.general/89541
>>>> There were some comments on it. I'll be posting a new version for it.
>>>
>>> hmm, n8x0 used tusb6010, so perhaps a similar patch needs to be cooked
>>> for that too. Right now, let's to the minimum fix, which is just to
>>> increment the array size to 3 and for v3.12 we do the changes that I
>>> suggested.
>>
>> this should solve the problem on n900 and n8x0, it's pretty much
>> kishon's original patch, so I guess it deserves his authorship:
> 
> Thanks, and yes it fixes this issue. I tested both N900 and N800, so
> feel free to add my Tested-by.

Together with my patch I take it? Does your Tested-by apply to this one
as well?


Thanks,
Daniel

