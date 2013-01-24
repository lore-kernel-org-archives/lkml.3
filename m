Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab3AXAXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 19:23:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48487 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab3AXAXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:23:46 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51007EF2.3090208@jp.fujitsu.com>
Date: Thu, 24 Jan 2013 09:23:14 +0900
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
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <1593084.QhbTkmoq3N@hammer82.arch.suse.de> <50FC95A8.6060402@jp.fujitsu.com> <1508535.gXZDAVy6sT@hammer82.arch.suse.de>
In-Reply-To: <1508535.gXZDAVy6sT@hammer82.arch.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/01/23 9:47), Thomas Renninger wrote:
> On Monday, January 21, 2013 10:11:04 AM Takao Indoh wrote:
>> (2013/01/08 4:09), Thomas Renninger wrote:
> ...
>>> I tried the provided patches first on 2.6.32, then I verfied with 3.8-rc2
>>> and in both cases the disk is not detected anymore in
>>> reset_devices (kexec'ed/kdump) case (but things work fine without these
>>> patches).
>>
>> So the problem that the disk is not detected was caused by exactmap
>> problem you guys are discussing? Or still not detected even if exactmap
>> problem is fixed?
> This problem is related to the 5 PCI resetting patches.
> Dumping worked with a 2.6.32 and a 3.8-rc2 kernel, adding the PCI resetting
> patches broke both. I first tried 2.6.32 and verified with 3.8-rc2 to make sure
> I didn't mess up the backport adjustings of the patches to 2.6.32.

If you have a chance please try again the patches with the latest
firmware. I met another problem on megaraid_sas disk when I tested the
patches and it did not occur after updated its firmware to the latest
one.
  
> Unfortunately this Dell platform takes really long to boot.
> I can give it the one or other test, but please do not bomb me with patches.
>
> For info:
> About the interrupt remapping error interrupt storm in kdump case I tried to
> reproduce on this machine, but never could: The guys who saw that also cannot
> reproduce this anymore.
>
> Two ideas I had about this:
>    - As said already, (also) try to catch the error case and try to reset the
>      the device in AER/Specific iterrupt remapping error interrupt caught.
>    - Have a look at coreboot, these guys should know how to initialize the PCI
>      subsystem from scratch and might have some well tested PCI resetting
>      code in place already (no idea, just a thought).

Ok, at first I'll take a look at AER code to check how it resets devices
on PCIe error.

Thanks,
Takao Indoh

>
>      Thomas
>
>

