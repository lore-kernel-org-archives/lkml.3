Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaHESj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:39:57 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:1783
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755211AbaHESjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:39:54 -0400
X-WSS-ID: 0N9UJUB-08-8CB-02
X-M-MSG: 
From: "Bridgman, John" <John.Bridgman@amd.com>
To: "'j.glisse@gmail.com'" <j.glisse@gmail.com>,
        "Gabbay, Oded" <Oded.Gabbay@amd.com>
CC: "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "Daenzer, Michel" <Michel.Daenzer@amd.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>,
        "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 00/23] AMDKFD Kernel Driver
Thread-Topic: [PATCH v3 00/23] AMDKFD Kernel Driver
Thread-Index: AQHPsMJQ1RNLj+2nEUGAaJ2UmhVrO5vCjVqA///KYzY=
Date: Tue, 5 Aug 2014 18:39:46 +0000
Message-ID: <D89D60253BB73A4E8C62F9FD18A939CA01074299@storexdag02.amd.com>
In-Reply-To: <20140805175138.GB2863@gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.1.13]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(164054003)(199002)(189002)(24454002)(51704005)(377454003)(13464003)(64706001)(97736001)(23756003)(21056001)(47776003)(50466002)(20776003)(77096002)(4396001)(81542001)(95666004)(81342001)(105586002)(85852003)(85306004)(2656002)(87936001)(92566001)(107046002)(92726001)(106466001)(83072002)(15202345003)(55846006)(80022001)(79102001)(84676001)(77982001)(101416001)(86362001)(33656002)(31966008)(83322001)(74502001)(76482001)(19580405001)(46102001)(44976005)(19580395003)(54356999)(50986999)(106116001)(74662001)(68736004)(53416004)(99396002)(15975445006);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB044;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=John.Bridgman@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

))To be clear, when we ask for open source userspace that shows how things are suppose to be use we are thinking something like mesa but in this case most likely something like an open source opencl implementation on top of that kernel api.

Yep, understood. We're working on that too. Next should be the HSA API runtime, which is essentially the user mode driver for HSA that language toolchains run over.

I think Sumatra (Java) will probably be the first open source language runtime rather than OpenCL -- it's working today albeit via an older version of the HSA API.

Thanks,
JB
 


----- Original Message -----
From: Jerome Glisse [mailto:j.glisse@gmail.com]
Sent: Tuesday, August 05, 2014 01:51 PM Eastern Standard Time
To: Gabbay, Oded
Cc: Lewycky, Andrew; Daenzer, Michel; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; dri-devel@lists.freedesktop.org <dri-devel@lists.freedesktop.org>; Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 00/23] AMDKFD Kernel Driver

On Tue, Aug 05, 2014 at 06:30:28PM +0300, Oded Gabbay wrote:
> Hi,
> Here is the v3 patch set of amdkfd.
> 
> This version contains changes and fixes to code, as agreed on during the review
> of the v2 patch set.
> 
> The major changes are:
> 
> - There are two new module parameters: # of processes and # of queues per 
>   process. The defaults, as agreed on in the v2 review, are 32 and 128 
>   respectively. This sets the default amount of GART address space that amdkfd
>   requires to 3.5MB (3MB for userspace queues mqds and 0.5MB for other stuff,
>   such as mqd for kernel queue, hpd for pipelines, etc.)
>   
> - All the GART address space usage of amdkfd is done inside a single contiguous
>   buffer that is allocated from system memory, and pinned to the start of the 
>   GART during the startup of amdkfd (which is just after the startup of 
>   radeon). The management of this buffer is done by the radeon sa manager. 
>   This buffer is not evict-able.
>   
> - Mapping of doorbells is initiated by the userspace lib (by mmap syscall), 
>   instead of initiating it from inside an ioctl (using vm_mmap).
>   
> - Removed ioctls for exclusive access to performance counters
>   
> - Added documentation about the QCM (Queue Control Management), apertures and
>   interfaces between amdkfd and radeon.
> 
> Two important notes:
> 
> - The topology patch has not been changed. Look at 
>   http://lists.freedesktop.org/archives/dri-devel/2014-July/065042.html
>   for my response. I also put my answer as an explanation in the commit msg
>   of the patch.
>   
> - There are still some minor code style issues I need to fix. I didn't want
>   to delay v3 any further but I will publish either v4 with those fixes,
>   or just relevant patches if the whole patch set will be merged.
> 
> For people who like to review using git, the v3 patch set is located at:
> http://cgit.freedesktop.org/~gabbayo/linux/log/?h=kfd-next-3.17-v3
> 
> In addition, I would like to announce that we have uploaded the userspace lib
> that accompanies amdkfd. That lib is called "libhsakmt" and you can view it at:
> http://cgit.freedesktop.org/~gabbayo/libhsakmt

Not commenting on the patchset yet, will try to find sometime in my non work
hour to do that. But the userspace you released are just a libdrm like thing
and this is not what we mean by we need to have userspace that shows how the
kernel api is use.

So this library is nothing but a wrapper and have allmost no value for any
serious review of the kernel api.

To be clear, when we ask for open source userspace that shows how things are
suppose to be use we are thinking something like mesa but in this case most
likely something like an open source opencl implementation on top of that
kernel api.


Btw this library code remind me of VHDL ... thought code style for userspace
library is anybody choice.

Cheers,
Jérôme

> 
> Alexey Skidanov (1):
>   amdkfd: Implement the Get Process Aperture IOCTL
> 
> Andrew Lewycky (3):
>   amdkfd: Add basic modules to amdkfd
>   amdkfd: Add interrupt handling module
>   amdkfd: Implement the Set Memory Policy IOCTL
> 
> Ben Goz (8):
>   amdkfd: Add queue module
>   amdkfd: Add mqd_manager module
>   amdkfd: Add kernel queue module
>   amdkfd: Add module parameter of scheduling policy
>   amdkfd: Add packet manager module
>   amdkfd: Add process queue manager module
>   amdkfd: Add device queue manager module
>   amdkfd: Implement the create/destroy/update queue IOCTLs
> 
> Evgeny Pinchuk (2):
>   amdkfd: Add topology module to amdkfd
>   amdkfd: Implement the Get Clock Counters IOCTL
> 
> Oded Gabbay (9):
>   drm/radeon: reduce number of free VMIDs and pipes in KV
>   drm/radeon/cik: Don't touch int of pipes 1-7
>   drm/radeon: Report doorbell configuration to amdkfd
>   drm/radeon: adding synchronization for GRBM GFX
>   drm/radeon: Add radeon <--> amdkfd interface
>   Update MAINTAINERS and CREDITS files with amdkfd info
>   amdkfd: Add IOCTL set definitions of amdkfd
>   amdkfd: Add amdkfd skeleton driver
>   amdkfd: Add binding/unbinding calls to amd_iommu driver
> 
>  CREDITS                                            |    7 +
>  MAINTAINERS                                        |   10 +
>  drivers/gpu/drm/radeon/Kconfig                     |    2 +
>  drivers/gpu/drm/radeon/Makefile                    |    3 +
>  drivers/gpu/drm/radeon/amdkfd/Kconfig              |   10 +
>  drivers/gpu/drm/radeon/amdkfd/Makefile             |   14 +
>  drivers/gpu/drm/radeon/amdkfd/cik_regs.h           |  220 ++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c       |  350 ++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c        |  511 +++++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_crat.h           |  294 +++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_device.c         |  300 +++++
>  .../drm/radeon/amdkfd/kfd_device_queue_manager.c   |  989 ++++++++++++++++
>  .../drm/radeon/amdkfd/kfd_device_queue_manager.h   |  144 +++
>  drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c       |  236 ++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c      |  161 +++
>  drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c   |  330 ++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h   |   66 ++
>  drivers/gpu/drm/radeon/amdkfd/kfd_module.c         |  147 +++
>  drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c    |  305 +++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h    |   88 ++
>  drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c |  495 ++++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c          |   95 ++
>  drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h    |  682 +++++++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h    |  107 ++
>  drivers/gpu/drm/radeon/amdkfd/kfd_priv.h           |  560 +++++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_process.c        |  347 ++++++
>  .../drm/radeon/amdkfd/kfd_process_queue_manager.c  |  346 ++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_queue.c          |   85 ++
>  drivers/gpu/drm/radeon/amdkfd/kfd_topology.c       | 1207 ++++++++++++++++++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_topology.h       |  168 +++
>  drivers/gpu/drm/radeon/cik.c                       |  154 +--
>  drivers/gpu/drm/radeon/cik_reg.h                   |   65 ++
>  drivers/gpu/drm/radeon/cikd.h                      |   53 +-
>  drivers/gpu/drm/radeon/radeon.h                    |   10 +
>  drivers/gpu/drm/radeon/radeon_device.c             |   32 +
>  drivers/gpu/drm/radeon/radeon_drv.c                |    5 +
>  drivers/gpu/drm/radeon/radeon_kfd.c                |  525 +++++++++
>  drivers/gpu/drm/radeon/radeon_kfd.h                |  177 +++
>  drivers/gpu/drm/radeon/radeon_kms.c                |    7 +
>  include/uapi/linux/kfd_ioctl.h                     |  126 ++
>  40 files changed, 9338 insertions(+), 95 deletions(-)
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/Kconfig
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/Makefile
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/cik_regs.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_crat.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_module.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_process.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_queue.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_topology.c
>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_topology.h
>  create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.c
>  create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.h
>  create mode 100644 include/uapi/linux/kfd_ioctl.h
> 
> -- 
> 1.9.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
_______________________________________________
dri-devel mailing list
dri-devel@lists.freedesktop.org
http://lists.freedesktop.org/mailman/listinfo/dri-devel
