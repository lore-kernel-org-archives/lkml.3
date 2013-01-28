Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab3A1M0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:26:47 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:31270 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3A1M0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:26:41 -0500
Message-ID: <51066E73.60704@huawei.com>
Date: Mon, 28 Jan 2013 20:26:27 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
CC: Chris Clayton <chris2553@googlemail.com>,
        Yijing Wang <wangyijing0307@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz> <5105AFDB.9000200@googlemail.com> <5105E51D.2020606@huawei.com> <51064F1A.1020909@googlemail.com> <51065FA6.4070208@googlemail.com> <51066B46.10409@fold.natur.cuni.cz>
In-Reply-To: <51066B46.10409@fold.natur.cuni.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/28 20:12, Martin Mokrejs wrote:
> Chris Clayton wrote:
>>
>> [snip]
>>
>>> [chris:~]$ cat /proc/cmdline
>>> root=/dev/sda5 pciehp_ports=native ro resume=/dev/sda6
>>                      ^^
>>                   **typo**
>> I've run the test again with pcie_ports=native and the directories now get populated. Even better though, is that when I plug in the card, hotplug **works** and the card's drivers are loaded.
> 
> BTW, I have with acpiphp on 3.7.4:
> 
> ls -la /sys/bus/pci_express/devices
> total 0
> drwxr-xr-x 2 root root 0 Jan 28 13:07 .
> drwxr-xr-x 4 root root 0 Jan 28 13:07 ..
> $ ls -la /sys/bus/pci/devices/slots
> ls: cannot access /sys/bus/pci/devices/slots: No such file or directory
> $
> 
> And for me hotplug also works (as far as I can tell). ;-)

Right, only pciehp (pcie nativa hotplug) need to bind pcie port devices.

Acpiphp (acpi pci hotplug) don't need pcie port devices, it just depend the firmware
in your machine, also acpiphp can support both pci hotplug and pcie hotplug. pciehp only
support pcie device hotplug.

> 
>>
>> Excellent! Thank you so much for your help (and patience) Martin and Yijing.
>>
>> Now to solving why running scandvb doesn't find any TV channels.
> 
> Would be fine if you could re-do the PresDet checks and confirm whether it is also broken
> for you under pciehp.
> 
> Martin
> 
> 


-- 
Thanks!
Yijing

