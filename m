Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3AZVOx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 16:14:53 -0500
Received: from fold.natur.cuni.cz ([195.113.57.32]:53273 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754291Ab3AZVOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 16:14:50 -0500
Message-ID: <51044746.6030503@fold.natur.cuni.cz>
Date: Sat, 26 Jan 2013 22:14:46 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0 SeaMonkey/2.14.1
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com>
In-Reply-To: <5104427D.2050002@googlemail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Chris Clayton wrote:
> Hi Martin,
> 
> On 01/24/13 19:21, Martin Mokrejs wrote:
>> Hi Chris,
>>    try to include in kernel only acpiphp and omit pciehp. Don't use modules but include
>> them statically. And try, in addition, check whether "pcie_aspm=off" in grub.conf helped.
>>
> 
> Thanks for the tip. I had the pciehp driver installed, but it was a module and not loaded. I didn't have acpiphp enabled at all. Building them both in statically, appears to have papered over the cracks of the oops :-)
> 
>>    The best would if you subscribe to linux-pci, and read my recent threads
>> about similar issues I had with express cards with Dell Vostro 3550. Further, there is
>> a lot of changes to PCI hotplug done by Yingahi Liu and Rafael Wysockij, just browse the
>> archives of linux-pci and see the pacthes and the discussion.
> 
> Those discussions are way above my level of knowledge. I guess all this work will be merged into mainline in due course, so I'll watch for them in 3.9 or later. Unless, of course, there is a tree I could clone and help test the changes with my laptop and expresscard.
> 
> Hotplug isn't working at all on my Fujitsu laptop, so I can only get the card recognised by rebooting with the card inserted (or by writing 1 to/sys/bus/pci/rescan). There seem to be a few reports on this in the kernel bugzilla, so I'll look through them and see what's being done.

That's what I suspected. Compile in statically acpiphp, no pciehp at all (not even as a module).
Then it might work for you -- at least it does for me, provided I use "pcie_aspm=off".

Martin

> 
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
> 
> 
