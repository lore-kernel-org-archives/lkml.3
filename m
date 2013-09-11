Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3IKCFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:05:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:49957 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab3IKCFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:05:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,881,1371106800"; 
   d="scan'208";a="376354707"
From: "Shan, Haitao" <haitao.shan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC: "Dong, Eddie" <eddie.dong@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "Li, Susie" <susie.li@intel.com>,
        "Haron, Sandra" <sandra.haron@intel.com>,
        "White, Michael L" <michael.l.white@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>
Subject: FW: [RFC] XenGT - An Mediated Graphics Passthrough Solution from
 Intel
Thread-Topic: [RFC] XenGT - An Mediated Graphics Passthrough Solution from
 Intel
Thread-Index: Ac6ukh9KZut69pWjSm2WTNSjjyetKw==
Date: Wed, 11 Sep 2013 02:05:12 +0000
Message-ID: <6E28F413615167448D5D4146F2D9370B1170BAA8@SHSMSX103.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,  Experts,

This email is aimed at a first time disclosure of project XenGT, which is a Graphics virtualization solution based on Xen.
 

 
As you can see, requirements for GPU to be sharable among virtual machines have been constantly rising. The targeted usage model might be accelerating tasks ranging from gaming, video playback, fancy GUIs, high-performance computing (GPU-based). This trend is observed on both client and cloud. Efficient GPU virtualization is required to address the increasing demands.
 

We have developed XenGT - a prototype based on a mediated passthrough architecture. We support running a native graphics driver in multiple VMs to achieve high performance. A specific mediator owns the scheduling and sharing hardware resources among all the virtual machines. By saying mediated pass-through, we actually divide graphics resource to two
categories: performance critical and others. We partition performance critical resources for VM's direct access like pass-through, while save and restore others.
 

 
XenGT implements the mediator in dom0, called vgt driver. This avoids adding complex device knowledge to Xen, and also permits a more flexible release model. In the meantime, we want to have a unified architecture to mediate all the VMs, including dom0. Thus, We developed a ³deprivileged²
dom0 mode, which essentially trapped Dom0's access to selected resources (graphics resources in XenGT case) and forwarded to vgt driver (which is also in Dom0) for processing.

 
Performance critical resources are:
- Part of the global virtual memory space
- VM¹s own per-process virtual memory spaces
- VM¹s own allocated command buffers (actually in graphics memory)

 
Others are:
- MMIO/PIO
- PCI configuration registers
- GTT tables
- Submission of queued GPU commands

Right now, we support 4 accelerated VMs: Dom0 + 3 HVM DomUs. We've conducted verifications based on Ubuntu 12.04 and 13.04. Tests conducted in VM include but are not limited to 3D gaming, media playbacks, 2D accelerations.

We believe the architecture itself can be general so that different GPUs can all use this mediated passthrough concept. However, we only developed codes based on Intel 4th Core Processor with integrated Graphics. Note that we don't require VT-d to run our solution.

If you have interests in trying, you can refer to the attached setup guide, which provides step-to-step details on building/configuring/running XenGT.

Source code is made available at github:
Xen: https://github.com/01org/XenGT-Preview-xen.git
Linux: https://github.com/01org/XenGT-Preview-kernel.git
Qemu: https://github.com/01org/XenGT-Preview-qemu.git

Any comments are welcome!


Special note: We are making this code available to general public since we take community's involvement and feedbacks seriously. However, while we've tested our solution with various workloads, the code is only at pre-alpha stage. Hangs might happen, so please don't try it on the system that hosting critical data for you.

Shan Haitao

