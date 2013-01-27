Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3A0Cpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 21:45:53 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42227 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab3A0Cpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 21:45:51 -0500
Message-ID: <510494D6.1010000@gmail.com>
Date: Sun, 27 Jan 2013 10:45:42 +0800
From: Yijing Wang <wangyijing0307@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com>
In-Reply-To: <5104427D.2050002@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013-01-27 4:54, Chris Clayton 写道:
> Hi Martin,
> 
> On 01/24/13 19:21, Martin Mokrejs wrote:
>> Hi Chris,
>>    try to include in kernel only acpiphp and omit pciehp. Don't use modules but include
>> them statically. And try, in addition, check whether "pcie_aspm=off" in grub.conf helped.
>>
> 
> Thanks for the tip. I had the pciehp driver installed, but it was a module and not loaded. I didn't have acpiphp enabled at all. Building them both in statically, appears to have papered over the cracks of the oops :-)

Not loaded pciehp driver? Remove the device from this slot without poweroff ?

> 
>>    The best would if you subscribe to linux-pci, and read my recent threads
>> about similar issues I had with express cards with Dell Vostro 3550. Further, there is
>> a lot of changes to PCI hotplug done by Yingahi Liu and Rafael Wysockij, just browse the
>> archives of linux-pci and see the pacthes and the discussion.
> 
> Those discussions are way above my level of knowledge. I guess all this work will be merged into mainline in due course, so I'll watch for them in 3.9 or later. Unless, of course, there is a tree I could clone and help test the changes with my laptop and expresscard.
> 
> Hotplug isn't working at all on my Fujitsu laptop, so I can only get the card recognised by rebooting with the card inserted (or by writing 1 to/sys/bus/pci/rescan). There seem to be a few reports on this in the kernel bugzilla, so I'll look through them and see what's being done.

Hi Chris,
   What about use #modprobe pciehp pciehp_debug=1 pciehp_poll_mode=1 pciehp_poll_time=1 ?

Can you resend the dmesg log and "lspci -vvv" info after hotplug device from your Fujitsu laptop with above module parameters?

Thanks!
Yijing.

> Thanks again.
> 
> Chris
> 
>> Martin
>>
>> Chris Clayton wrote:
>>> Hi,
>>>
>>> I've today taken delivery of a WinTV-HVR-1400 expresscard TV Tuner and got an Oops when I removed from the expresscard slot in my laptop. I will quite understand if the response to this report is "don't do that!", but in that case, how should one remove one of these cards?
>>>
>>> I have attached three files:
>>>
>>> 1. the dmesg output from when I rebooted the machine after the oops. I have turned debugging on in the dib700p and cx23885 modules via modules options in /etc/modprobe.d/hvr1400.conf;
>>>
>>> 2. the .config file for the kernel that oopsed.
>>>
>>> 3. the text of the oops message. I've typed this up from a photograph of the screen because the laptop was locked up and there was nothing in the log files. Apologies for any typos, but I have tried to be careful.
>>>
>>> Assuming the answer isn't don't do that, let me know if I can provide any additional diagnostics, test any patches, etc. Please, however, cc me as I'm not subscribed.
>>>
>>> Chris
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

