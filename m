Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab3A3FBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 00:01:54 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53253 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3A3FBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 00:01:52 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5108A911.4070902@jp.fujitsu.com>
Date: Wed, 30 Jan 2013 14:01:05 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: trenn@suse.de
CC: yinghai@kernel.org, muneda.takahiro@jp.fujitsu.com,
        linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, hpa@zytor.com,
        bhelgaas@google.com, tglx@linutronix.de, khalid@gonehiking.org
Subject: Re: [PATCH v7 0/5] Reset PCIe devices to address DMA problem on kdump
 with iommu
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <1508535.gXZDAVy6sT@hammer82.arch.suse.de> <51007EF2.3090208@jp.fujitsu.com> <3404772.bJenOLl2bH@hammer82.arch.suse.de>
In-Reply-To: <3404772.bJenOLl2bH@hammer82.arch.suse.de>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/01/29 10:14), Thomas Renninger wrote:
> On Thursday, January 24, 2013 09:23:14 AM Takao Indoh wrote:
>> (2013/01/23 9:47), Thomas Renninger wrote:
>>> On Monday, January 21, 2013 10:11:04 AM Takao Indoh wrote:
>>>> (2013/01/08 4:09), Thomas Renninger wrote:
>>> ...
>>>
>>>>> I tried the provided patches first on 2.6.32, then I verfied with
>>>>> 3.8-rc2
>>>>> and in both cases the disk is not detected anymore in
>>>>> reset_devices (kexec'ed/kdump) case (but things work fine without these
>>>>> patches).
>>>>
>>>> So the problem that the disk is not detected was caused by exactmap
>>>> problem you guys are discussing? Or still not detected even if exactmap
>>>> problem is fixed?
>>>
>>> This problem is related to the 5 PCI resetting patches.
>>> Dumping worked with a 2.6.32 and a 3.8-rc2 kernel, adding the PCI
>>> resetting
>>> patches broke both. I first tried 2.6.32 and verified with 3.8-rc2 to make
>>> sure I didn't mess up the backport adjustings of the patches to 2.6.32.
>> If you have a chance please try again the patches with the latest
>> firmware.
> Not sure I can update the firmware as this is a reference platform used exactly
> like this in production.

Anyway it seems that resetting device makes the disks disappear from
your system. I'm wondering if this reset mechanism should be disabled by
default and be enabled by boot parameter like
reset_devices_on_dmar_fault to prevent a regression like your case.

Thanks,
Takao Indoh

>
> I also cannot see how this could help.
>
>     Thomas
>
>


