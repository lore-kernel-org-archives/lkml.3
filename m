Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbbALDH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 22:07:58 -0500
Received: from mga03.intel.com ([134.134.136.65]:61180 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbbALDH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 22:07:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,741,1413270000"; 
   d="scan'208";a="649633288"
Message-ID: <54B339A6.5010904@intel.com>
Date: Mon, 12 Jan 2015 11:04:06 +0800
From: Jike Song <jike.song@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: xen-devel@lists.xen.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
CC: "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>, "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "Haron, Sandra" <sandra.haron@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, "Zhu, Libo" <libo.zhu@intel.com>,
        "Zhou, Chao" <chao.zhou@intel.com>,
        "Wang, Hongbo" <hongbo.wang@intel.com>
Subject: Re: [Intel-gfx] [Announcement] 2014-Q4 release of XenGT - a Mediated
 Graphics Passthrough Solution from Intel
References: <53D215D3.50608@intel.com> <547FCAAD.2060406@intel.com> <54AF967B.3060503@intel.com>
In-Reply-To: <54AF967B.3060503@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops. Changed the title from "2015-Q1" to be "2014-Q4" :)

--
Thanks,
Jike


On 01/09/2015 04:51 PM, Jike Song wrote:
> Hi all,
>
>     We're pleased to announce a public update to Intel Graphics Virtualization Technology (Intel GVT-g, formerly known as XenGT). Intel GVT-g is a complete vGPU solution with mediated pass-through, supported today on 4th generation Intel Core(TM) processors with Intel Graphics processors. A virtual GPU instance is maintained for each VM, with part of performance critical resources directly assigned. The capability of running native graphics driver inside a VM, without hypervisor intervention in performance critical paths, achieves a good balance among performance, feature, and sharing capability. Though we only support Xen on Intel Processor Graphics so far, the core logic can be easily ported to other hypervisors.   The XenGT project should be considered a work in progress, As such it is not a complete product nor should it be considered one., Extra care should be taken when testing and configuring a system to use the XenGT project.
>
> The news of this update:
>
> 	- kernel update from 3.14.1 to drm-intel 3.17.0.
> 	- We plan to integrate Intel GVT-g as a feature in i915 driver. That effort is still under review, not included in this update yet.
> 	- Next update will be around early Apr, 2015.
>
> This update consists of:
>
> 	- Including some bug fixes and stability enhancement.
> 	- Making XenGT device model to be aware of Broadwell. In this version BDW is not yet functioning.
> 	- Available Fence registers number is changed to 32 from 16 to align with HSW hardware.
> 	- New cascade interrupt framework for supporting interrupt virtualization on both Haswell and Broadwell.
> 	- Add back the gem_vgtbuffer. The previous release did not build that module for 3.14 kernel. In this release, the module is back and rebased to 3.17.
> 	- Enable the irq based context switch in vgt driver, which will help reduce the cpu utilization while doing context switch, it is enabled by default, and can be turn off by kernel flag irq_based_ctx_switch.
>
>
> Please refer to the new setup guide, which provides step-to-step details about building/configuring/running Intel GVT-g:
>
> 	https://github.com/01org/XenGT-Preview-kernel/blob/master/XenGT_Setup_Guide.pdf
>
> The new source codes are available at the updated github repos:
>
> 	Linux: https://github.com/01org/XenGT-Preview-kernel.git
> 	Xen: https://github.com/01org/XenGT-Preview-xen.git
> 	Qemu: https://github.com/01org/XenGT-Preview-qemu.git
>
>
> More information about Intel GVT-g background, architecture, etc can be found at:
>
>
> 	https://www.usenix.org/conference/atc14/technical-sessions/presentation/tian
> 	http://events.linuxfoundation.org/sites/events/files/slides/XenGT-Xen%20Summit-v7_0.pdf
> 	https://01.org/xen/blogs/srclarkx/2013/graphics-virtualization-xengt
>
>
>
> The previous update can be found here:
>
>
> 	http://lists.xen.org/archives/html/xen-devel/2014-12/msg00474.html
>
>
>
> Appreciate your comments!
>
>
>
> --
> Thanks,
> Jike
>
>
> On 12/04/2014 10:45 AM, Jike Song wrote:
>> Hi all,
>>
>> We're pleased to announce a public release to Intel Graphics Virtualization Technology (Intel GVT-g, formerly known as XenGT). Intel GVT-g is a complete vGPU solution with mediated pass-through, supported today on 4th generation Intel Core(TM) processors with Intel Graphics processors. A virtual GPU instance is maintained for each VM, with part of performance critical resources directly assigned. The capability of running native graphics driver inside a VM, without hypervisor intervention in performance critical paths, achieves a good balance among performance, feature, and sharing capability. Though we only support Xen on Intel Processor Graphics so far, the core logic can be easily ported to other hypervisors.
>>
>>
>> The news of this update:
>>
>>
>> 	- kernel update from 3.11.6 to 3.14.1
>>
>> 	- We plan to integrate Intel GVT-g as a feature in i915 driver. That effort is still under review, not included in this update yet
>>
>> 	- Next update will be around early Jan, 2015
>>
>>
>> This update consists of:
>>
>> 	- Windows HVM support with driver version 15.33.3910
>>
>> 	- Stability fixes, e.g. stabilize GPU, the GPU hang occurrence rate becomes rare now
>>
>> 	- Hardware Media Acceleration for Decoding/Encoding/Transcoding, VC1, H264 etc. format supporting
>>
>> 	- Display enhancements, e.g. DP type is supported for virtual PORT
>>
>> 	- Display port capability virtualization: with this feature, dom0 manager could freely assign virtual DDI ports to VM, not necessary to check whether the corresponding physical DDI ports are available
>>
>>
>>
>> Please refer to the new setup guide, which provides step-to-step details about building/configuring/running Intel GVT-g:
>>
>>
>> 	https://github.com/01org/XenGT-Preview-kernel/blob/master/XenGT_Setup_Guide.pdf
>>
>>
>>
>> The new source codes are available at the updated github repos:
>>
>>
>> 	Linux: https://github.com/01org/XenGT-Preview-kernel.git
>>
>> 	Xen: https://github.com/01org/XenGT-Preview-xen.git
>>
>> 	Qemu: https://github.com/01org/XenGT-Preview-qemu.git
>>
>>
>> More information about Intel GVT-g background, architecture, etc can be found at:
>>
>>
>> 	https://www.usenix.org/conference/atc14/technical-sessions/presentation/tian
>>
>> 	http://events.linuxfoundation.org/sites/events/files/slides/XenGT-Xen%20Summit-v7_0.pdf
>>
>> 	https://01.org/xen/blogs/srclarkx/2013/graphics-virtualization-xengt
>>
>>
>> The previous update can be found here:
>>
>>
>> 	http://lists.xen.org/archives/html/xen-devel/2014-07/msg03248.html
>>
>>
>> Appreciate your comments!
>>
>>
>> --
>> Thanks,
>> Jike
>>
>> On 07/25/2014 04:31 PM, Jike Song wrote:
>>> Hi all,
>>>
>>> We're pleased to announce an update to Intel Graphics Virtualization Technology (Intel GVT-g, formerly known as XenGT). Intel GVT-g is a complete vGPU solution with mediated pass-through, supported today on 4th generation Intel Core(TM) processors with Intel Graphics processors. A virtual GPU instance is maintained for each VM, with part of performance critical resources directly assigned. The capability of running native graphics driver inside a VM, without hypervisor intervention in performance critical paths, achieves a good balance among performance, feature, and sharing capability. Though we only support Xen on Intel Processor Graphics so far, the core logic can be easily ported to other hypervisors.
>>>
>>> The news of this update:
>>>
>>> 	- Project code name is "XenGT", now official name is Intel Graphics Virtualization Technology (Intel GVT-g)
>>> 	- Currently Intel GVT-g supports Intel Processor Graphics built into 4th generation Intel Core processors - Haswell platform
>>> 	- Moving forward, XenGT will change to quarterly release cadence. Next update will be around early October, 2014.
>>>
>>> This update consists of:
>>>
>>> 	- Stability fixes, e.g. stable DP support
>>> 	- Display enhancements, e.g. virtual monitor support. Users can define a virtual monitor type with customized EDID for virtual machines, not necessarily the same as physical monitors.
>>> 	- Improved support for GPU recovery
>>> 	- Experimental Windows HVM support. To download the experimental version, see setup guide for details
>>> 	- Experimental Hardware Media Acceleration for decoding.
>>>
>>>
>>> Please refer to the new setup guide, which provides step-to-step details about building/configuring/running Intel GVT-g:
>>>
>>> 	https://github.com/01org/XenGT-Preview-kernel/blob/master/XenGT_Setup_Guide.pdf
>>>
>>>
>>> The new source codes are available at the updated github repos:
>>>
>>> 	Linux: https://github.com/01org/XenGT-Preview-kernel.git
>>> 	Xen: https://github.com/01org/XenGT-Preview-xen.git
>>> 	Qemu: https://github.com/01org/XenGT-Preview-qemu.git
>>>
>>>
>>> More information about Intel GVT-g background, architecture, etc can be found at:
>>>
>>> 	https://www.usenix.org/conference/atc14/technical-sessions/presentation/tian
>>> 	http://events.linuxfoundation.org/sites/events/files/slides/XenGT-Xen%20Summit-v7_0.pdf
>>> 	https://01.org/xen/blogs/srclarkx/2013/graphics-virtualization-xengt
>>>
>>> The previous update can be found here:
>>>
>>> 	http://lists.xen.org/archives/html/xen-devel/2014-02/msg01848.html
>>>
>>> Appreciate your comments!
>>>
>>>
>>>
>>>
>>> --
>>> Thanks,
>>> Jike
>>>
