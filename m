Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaLDKTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:19:35 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:56615 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaLDKT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:19:28 -0500
Message-ID: <5480355E.4050502@m2r.biz>
Date: Thu, 04 Dec 2014 11:20:14 +0100
From: Fabio Fantoni <fabio.fantoni@m2r.biz>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jike Song <jike.song@intel.com>, xen-devel@lists.xen.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
CC: "Tian, Kevin" <kevin.tian@intel.com>,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>, "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "Zhou, Chao" <chao.zhou@intel.com>,
        "Haron, Sandra" <sandra.haron@intel.com>,
        "Zhu, Libo" <libo.zhu@intel.com>
Subject: Re: [Xen-devel] [Intel-gfx] [Announcement] 2014-Q3 release of XenGT
 - a Mediated Graphics Passthrough Solution from Intel
References: <53D215D3.50608@intel.com> <547FCAAD.2060406@intel.com>
In-Reply-To: <547FCAAD.2060406@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/12/2014 03:45, Jike Song ha scritto:
> Hi all,
>
> We're pleased to announce a public release to Intel Graphics 
> Virtualization Technology (Intel GVT-g, formerly known as XenGT). 
> Intel GVT-g is a complete vGPU solution with mediated pass-through, 
> supported today on 4th generation Intel Core(TM) processors with Intel 
> Graphics processors. A virtual GPU instance is maintained for each VM, 
> with part of performance critical resources directly assigned. The 
> capability of running native graphics driver inside a VM, without 
> hypervisor intervention in performance critical paths, achieves a good 
> balance among performance, feature, and sharing capability. Though we 
> only support Xen on Intel Processor Graphics so far, the core logic 
> can be easily ported to other hypervisors.
>
>
> The news of this update:
>
>
>     - kernel update from 3.11.6 to 3.14.1
>
>     - We plan to integrate Intel GVT-g as a feature in i915 driver. 
> That effort is still under review, not included in this update yet
>
>     - Next update will be around early Jan, 2015
>
>
> This update consists of:
>
>     - Windows HVM support with driver version 15.33.3910
>
>     - Stability fixes, e.g. stabilize GPU, the GPU hang occurrence 
> rate becomes rare now
>
>     - Hardware Media Acceleration for Decoding/Encoding/Transcoding, 
> VC1, H264 etc. format supporting
>
>     - Display enhancements, e.g. DP type is supported for virtual PORT
>
>     - Display port capability virtualization: with this feature, dom0 
> manager could freely assign virtual DDI ports to VM, not necessary to 
> check whether the corresponding physical DDI ports are available
>
>
>
> Please refer to the new setup guide, which provides step-to-step 
> details about building/configuring/running Intel GVT-g:
>
>
>     https://github.com/01org/XenGT-Preview-kernel/blob/master/XenGT_Setup_Guide.pdf 
>
>
>
>
> The new source codes are available at the updated github repos:
>
>
>     Linux: https://github.com/01org/XenGT-Preview-kernel.git
>
>     Xen: https://github.com/01org/XenGT-Preview-xen.git
>
>     Qemu: https://github.com/01org/XenGT-Preview-qemu.git
>
>
> More information about Intel GVT-g background, architecture, etc can 
> be found at:
>
>
>     https://www.usenix.org/conference/atc14/technical-sessions/presentation/tian 
>
>
>     http://events.linuxfoundation.org/sites/events/files/slides/XenGT-Xen%20Summit-v7_0.pdf 
>
>
>     https://01.org/xen/blogs/srclarkx/2013/graphics-virtualization-xengt
>
>
> The previous update can be found here:
>
>
>     http://lists.xen.org/archives/html/xen-devel/2014-07/msg03248.html
>
>
> Appreciate your comments!

Thanks for this very good project.
I did a fast look to xen patch about it, I have some small advices:
change to tools/examples/xmexample.hvm should be to 
tools/examples/xlexample.hvm instead since is implemented in xl and not xm.
I think is good rebase the patch to latest xen-unstable git that have 
many changes, for better reviews and for propose it upstream for xen 4.6 
if will be good.

Thanks for any reply and sorry for my bad english.

>
>
> -- 
> Thanks,
> Jike
>
> On 07/25/2014 04:31 PM, Jike Song wrote:
>> Hi all,
>>
>> We're pleased to announce an update to Intel Graphics Virtualization 
>> Technology (Intel GVT-g, formerly known as XenGT). Intel GVT-g is a 
>> complete vGPU solution with mediated pass-through, supported today on 
>> 4th generation Intel Core(TM) processors with Intel Graphics 
>> processors. A virtual GPU instance is maintained for each VM, with 
>> part of performance critical resources directly assigned. The 
>> capability of running native graphics driver inside a VM, without 
>> hypervisor intervention in performance critical paths, achieves a 
>> good balance among performance, feature, and sharing capability. 
>> Though we only support Xen on Intel Processor Graphics so far, the 
>> core logic can be easily ported to other hypervisors.
>>
>> The news of this update:
>>
>>     - Project code name is "XenGT", now official name is Intel 
>> Graphics Virtualization Technology (Intel GVT-g)
>>     - Currently Intel GVT-g supports Intel Processor Graphics built 
>> into 4th generation Intel Core processors - Haswell platform
>>     - Moving forward, XenGT will change to quarterly release cadence. 
>> Next update will be around early October, 2014.
>>
>> This update consists of:
>>
>>     - Stability fixes, e.g. stable DP support
>>     - Display enhancements, e.g. virtual monitor support. Users can 
>> define a virtual monitor type with customized EDID for virtual 
>> machines, not necessarily the same as physical monitors.
>>     - Improved support for GPU recovery
>>     - Experimental Windows HVM support. To download the experimental 
>> version, see setup guide for details
>>     - Experimental Hardware Media Acceleration for decoding.
>>
>>
>> Please refer to the new setup guide, which provides step-to-step 
>> details about building/configuring/running Intel GVT-g:
>>
>>     https://github.com/01org/XenGT-Preview-kernel/blob/master/XenGT_Setup_Guide.pdf 
>>
>>
>>
>> The new source codes are available at the updated github repos:
>>
>>     Linux: https://github.com/01org/XenGT-Preview-kernel.git
>>     Xen: https://github.com/01org/XenGT-Preview-xen.git
>>     Qemu: https://github.com/01org/XenGT-Preview-qemu.git
>>
>>
>> More information about Intel GVT-g background, architecture, etc can 
>> be found at:
>>
>>     https://www.usenix.org/conference/atc14/technical-sessions/presentation/tian 
>>
>>     http://events.linuxfoundation.org/sites/events/files/slides/XenGT-Xen%20Summit-v7_0.pdf 
>>
>>     https://01.org/xen/blogs/srclarkx/2013/graphics-virtualization-xengt
>>
>> The previous update can be found here:
>>
>>     http://lists.xen.org/archives/html/xen-devel/2014-02/msg01848.html
>>
>> Appreciate your comments!
>>
>>
>>
>>
>> -- 
>> Thanks,
>> Jike
>>
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

