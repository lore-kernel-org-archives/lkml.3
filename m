Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773Ab3D3PJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:09:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759686Ab3D3PJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:09:11 -0400
Message-ID: <517FDE94.7080700@redhat.com>
Date: Tue, 30 Apr 2013 11:09:08 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121116 Thunderbird/10.0.11
MIME-Version: 1.0
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
CC: "Duran, Leo" <leo.duran@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: IOMMU/AMD: Error Handling
References: <517ECDDA.3000606@amd.com> <517ED3A9.2050508@redhat.com> <BA42942F2D0DED45AFB0A6216D1E951D44CBE1F9@sausexdag01.amd.com> <517EE940.8010005@redhat.com> <517FDB96.7060602@amd.com>
In-Reply-To: <517FDB96.7060602@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2013 10:56 AM, Suravee Suthikulanit wrote:
> On 4/29/2013 4:42 PM, Don Dutile wrote:
>> On 04/29/2013 04:34 PM, Duran, Leo wrote:
>>> I'm wondering if resetting the IOMMU at init-time (once) would clear any BIOS induced noise.
>>> Leo
>>>
>> Well, depends what you mean by 'reset'....
>> (a) setting it up for OS use is effectively a reset, but doesn't quiesce a device
>> doing dma reads of a (bios-setup) queue. then the noisy messages begin
>> (b) disable the iommu, and then the dma just occurs... and bad for writes, potentially.
>>
>> Similar issue is being reported & worked for kdump, where device are still
>> doing DMA while the system is trying to 'reset' to the kexec'd kernel, and
>> take a crash dump.
>>
>> Solution: stop devices from doing dma... but some you _want_ enabled throughout...
>> like keyboard & mouse via usb controller, so you get to pick os from
>> grub... not so for kexec...
>>
>> so, again, for isolation faults.... let the hw do its job -- isolate
>> and throttle/silence the fault messages on a per-device, time-duration heuristic
>> so the system can get through boot-up where enough OS is init'd (drivers started)
>> to stop the temporary noise.
> This sounds more like issue with the order of how things are initialized in the system.
> If so, could we separate the code which enabling of IOMMU error logging/handling and
> delay it until we are certain that systems are stable?
>
So, you are proposing we not enable fault events when IOMMU is initially configured;
use the IOMMU through boot/driver-config, hoping all is well, and if not, continue blindly,
and then enable IOMMU faults post/late-init ?

> Suravee
>

