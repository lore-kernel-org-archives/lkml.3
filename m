Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab3D3O4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:56:30 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:42769
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932195Ab3D3O42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:56:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1155h)
X-WSS-ID: 0MM2PHY-01-4EZ-02
X-M-MSG: 
Message-ID: <517FDB96.7060602@amd.com>
Date: Tue, 30 Apr 2013 09:56:22 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Don Dutile <ddutile@redhat.com>
CC: "Duran, Leo" <leo.duran@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: IOMMU/AMD: Error Handling
References: <517ECDDA.3000606@amd.com> <517ED3A9.2050508@redhat.com> <BA42942F2D0DED45AFB0A6216D1E951D44CBE1F9@sausexdag01.amd.com> <517EE940.8010005@redhat.com>
In-Reply-To: <517EE940.8010005@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/2013 4:42 PM, Don Dutile wrote:
> On 04/29/2013 04:34 PM, Duran, Leo wrote:
>> I'm wondering if resetting the IOMMU at init-time (once) would clear 
>> any BIOS induced noise.
>> Leo
>>
> Well, depends what you mean by 'reset'....
> (a) setting it up for OS use is effectively a reset, but doesn't 
> quiesce a device
>      doing dma reads of a (bios-setup) queue.  then the noisy messages 
> begin
> (b) disable the iommu, and then the dma just occurs... and bad for 
> writes, potentially.
>
> Similar issue is being reported & worked for kdump, where device are 
> still
> doing DMA while the system is trying to 'reset' to the kexec'd kernel, 
> and
> take a crash dump.
>
> Solution: stop devices from doing dma... but some you _want_ enabled 
> throughout...
>           like keyboard & mouse via usb controller, so you get to pick 
> os from
>           grub...  not so for kexec...
>
> so, again, for isolation faults.... let the hw do its job -- isolate
> and throttle/silence the fault messages on a per-device, time-duration 
> heuristic
> so the system can get through boot-up where enough OS is init'd 
> (drivers started)
> to stop the temporary noise.
This sounds more like issue with the order of how things are initialized 
in the system.
If so, could we separate the code which enabling of IOMMU error 
logging/handling and
delay it until we are certain that systems are stable?

Suravee

