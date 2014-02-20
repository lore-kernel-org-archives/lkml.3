Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaBTH7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:59:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:55147 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbaBTH7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:59:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,511,1389772800"; 
   d="scan'208";a="484657916"
From: "Cui, Dexuan" <dexuan.cui@intel.com>
To: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Tian, Kevin" <kevin.tian@intel.com>,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>, "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "Haron, Sandra" <sandra.haron@intel.com>
Subject: [Announcement] Updates to XenGT - a Mediated Graphics Passthrough
 Solution from Intel
Thread-Topic: [Announcement] Updates to XenGT - a Mediated Graphics
 Passthrough Solution from Intel
Thread-Index: Ac8uCM+UTJUf7TAWTkKmKWKJu37vjg==
Date: Thu, 20 Feb 2014 07:59:04 +0000
Message-ID: <A25F549E4D43CD42B4C02DF47A19132311058FC7@SHSMSX103.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
We're pleased to announce an update to XenGT since its first disclosure in last Sep. XenGT is a full GPU virtualization solution with mediated pass-through, on Intel Processor Graphics. A virtual GPU instance is maintained for each VM, with part of performance critical resources directly assigned. The capability of running native graphics driver inside a VM, without hypervisor intervention in performance critical paths, achieves a good balance among performance, feature, and sharing capability. Though we only support Xen on Intel Processor Graphics so far, the core logic can be easily ported to other hypervisors.

The update consists of:

Linux-vgt:
    Rebased to kernel 3.11.6 
    Lots of stability fixes
    Improved sharing quality of render engine and display engine
    Multi-monitors (clone/extended) support for VGA, HDMI, DP and eDP types
    Support VMs with different resolutions
    Improved monitor hotplug handling
    Preliminary support for GPU recovery

Xen-vgt:
    Rebased to Xen 4.3.1
    >8 bytes MMIO emulation

Qemu-vgt:
    Included VT-d GPU pass-through logic for comparison
    Grub2 graphics mode works now

Please refer to the attached new setup guide:
https://github.com/01org/XenGT-Preview-kernel/blob/master/XenGT_Setup_Guide.pdf
It provides step-to-step details about building/configuring/running XenGT.

The new source codes are available at the updated github repos:
Linux: https://github.com/01org/XenGT-Preview-kernel.git
Xen: https://github.com/01org/XenGT-Preview-xen.git
Qemu: https://github.com/01org/XenGT-Preview-qemu.git

More information about XenGT's background, architecture, etc can be found at:
http://events.linuxfoundation.org/sites/events/files/slides/XenGT-Xen%20Summit-v7.pdf
https://01.org/xen/blogs/srclarkx/2013/graphics-virtualization-xengt

Appreciating your comments!

Thanks,
-- Dexuan

> -----Original Message-----
> From: xen-devel-bounces@lists.xen.org
> [mailto:xen-devel-bounces@lists.xen.org] On Behalf Of Shan, Haitao
> Sent: Monday, September 09, 2013 8:46 PM
> To: xen-devel@lists.xen.org
> Cc: Tian, Kevin; White, Michael L; Dong, Eddie; Li, Susie; Cowperthwaite,
> David J; Haron, Sandra
> Subject: [Xen-devel] [RFC] XenGT - An Mediated Graphics Passthrough
> Solution from Intel
> 
> Hi, Xen Experts,
> 
> This email is aimed at a first time disclosure of project XenGT, which is
> a Graphics virtualization solution based on Xen.
> 
> 
> 
> As you can see, requirements for GPU to be sharable among virtual machines
> have been constantly rising. The targeted usage model might be
> accelerating tasks ranging from gaming, video playback, fancy GUIs,
> high-performance computing (GPU-based). This trend is observed on both
> client and cloud. Efficient GPU virtualization is required to address the
> increasing demands.
> 
> 
> We have developed XenGT - a prototype based on a mediated passthrough
> architecture. We support running a native graphics driver in multiple VMs
> to achieve high performance. A specific mediator owns the scheduling and
> sharing hardware resources among all the virtual machines. By saying
> mediated pass-through, we actually divide graphics resource to two
> categories: performance critical and others. We partition performance
> critical resources for VM's direct access like pass-through, while save
> and restore others.
> 
> 
> 
> XenGT implements the mediator in dom0, called vgt driver. This avoids
> adding complex device knowledge to Xen, and also permits a more flexible
> release model. In the meantime, we want to have a unified architecture to
> mediate all the VMs, including dom0. Thus, We developed a deprivileged
> dom0 mode, which essentially trapped Dom0's access to selected resources
> (graphics resources in XenGT case) and forwarded to vgt driver (which is
> also in Dom0) for processing.
> 
> 
> Right now, we support 4 accelerated VMs: Dom0 + 3 HVM DomUs. We've
> conducted verifications based on Ubuntu 12.04 and 13.04. Tests conducted
> in VM include but are not limited to 3D gaming, media playbacks, 2D
> accelerations.
> 
> We believe the architecture itself can be general so that different GPUs
> can all use this mediated passthrough concept. However, we only developed
> codes based on Intel 4th Core Processor with integrated Graphics.
> 
> If you have interests in trying, you can refer to the attached setup
> guide, which provides step-to-step details on building/configuring/running
> XenGT.
> 
> Source code is made available at github:
> Xen: https://github.com/01org/XenGT-Preview-xen.git
> Linux: https://github.com/01org/XenGT-Preview-kernel.git
> Qemu: https://github.com/01org/XenGT-Preview-qemu.git
> 
> Any comments are welcome!
> 
> 
> Special note: We are making this code available to general public since we
> take community's involvement and feedbacks seriously. However, while
> we've
> tested our solution with various workloads, the code is only at pre-alpha
> stage. Hangs might happen, so please don't try it on the system that
> hosting critical data for you.
> 
> Shan Haitao

