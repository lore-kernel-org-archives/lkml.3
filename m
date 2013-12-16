Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab3LPSYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:24:14 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:39058 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab3LPSYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:24:12 -0500
Message-ID: <52AF4549.1010102@linux.com>
Date: Mon, 16 Dec 2013 19:24:09 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] treewide: add missing put_device calls
References: <1386962557-8899-1-git-send-email-levex@linux.com> <CAErSpo4dJFsK+Wcfz8PrH=Ras343nLS=XgQFbEr_KCgFVED52Q@mail.gmail.com> <20131214172419.GC22520@kroah.com> <52AD606F.50408@linux.com> <20131215170325.GA28799@kroah.com> <52AF35FD.8000904@linux.com> <20131216175848.GB2007@kroah.com> <52AF4249.8030000@linux.com> <20131216181822.GA2522@kroah.com>
In-Reply-To: <20131216181822.GA2522@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2013 07:18 PM, Greg Kroah-Hartman wrote:
> On Mon, Dec 16, 2013 at 07:11:21PM +0100, Levente Kurusa wrote:
>> On 12/16/2013 06:58 PM, Greg Kroah-Hartman wrote:
>>> On Mon, Dec 16, 2013 at 06:18:53PM +0100, Levente Kurusa wrote:
>>>>>> IIRC, there are also a few where the device is also unregistered from
>>>>>> the specific subsystem's core.
>>>>>
>>>>> Do you have a specific example of this?  This should happen in the
>>>>> release function of the device already, not in some other code.
>>>>>
>>>> Character drivers who register with device_register() call cdev_del()
>>>> when device_register() fails.
>>>
>>> A cdev shouldn't be created until _after_ the device is successfully
>>> registered, as it could be opened and accessed before the device is
>>> registered.  That sounds like the drivers that do that should be fixed
>>> (have an example of this somewhere?)
>>
>> I did some research and it seems it has mostly been my false memory that made
>> me think that. The only example I could find that did something like this
>> was: drivers/scsi/osd/osd_uld.c at line 403.
>>
>> When the device_register() fails it immediately jumps to a cdev_del();
> 
> That should be easy to reorginize to not do this (i.e. do the cdev_add()
> call after the device_register() call, if needed.
> 

So it seems that this should be fixed if I understand you correctly.
If you want I can add this to my TODO list, so I will make a patch in a few
days?

-- 
Regards,
Levente Kurusa
