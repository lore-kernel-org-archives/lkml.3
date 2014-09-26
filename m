Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbaIZLCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:02:15 -0400
Received: from mail-by2on0125.outbound.protection.outlook.com ([207.46.100.125]:13824
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753890AbaIZLCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:02:13 -0400
X-WSS-ID: 0NCI9BE-08-54S-02
X-M-MSG: 
Message-ID: <542547A9.80000@amd.com>
Date: Fri, 26 Sep 2014 14:02:01 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC: Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>
Subject: Re: [PATCH v3 00/23] AMDKFD Kernel Driver
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
 <CANq1E4RNvJ=BeZSGhfZD1rsj+zY9Gm5-pu_24k+35viNDGEdkQ@mail.gmail.com>
 <53E123FB.7090705@amd.com>
In-Reply-To: <53E123FB.7090705@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.152.86]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(428002)(24454002)(189002)(51704005)(199003)(377454003)(479174003)(65806001)(92566001)(92726001)(65956001)(10300001)(106466001)(65816999)(105586002)(31966008)(102836001)(50986999)(90102001)(97736003)(74502003)(80022003)(95666004)(46102003)(81542003)(79102003)(77982003)(74662003)(107046002)(81342003)(64706001)(47776003)(120916001)(54356999)(36756003)(99396003)(85306004)(20776003)(19580405001)(21056001)(64126003)(76482002)(83322001)(19580395003)(44976005)(15975445006)(68736004)(4396001)(50466002)(23676002)(83506001)(33656002)(87936001)(15202345003)(83072002)(84676001)(101416001)(76176999)(86362001)(85852003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp02.amd.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB127;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/08/14 21:35, Gabbay, Oded wrote:
> 
> 
> On 05/08/14 20:11, David Herrmann wrote:
>> Hi
>>
>> On Tue, Aug 5, 2014 at 5:30 PM, Oded Gabbay <oded.gabbay@amd.com> wrote:
>>> Hi,
>>> Here is the v3 patch set of amdkfd.
>>>
>>> This version contains changes and fixes to code, as agreed on during the review
>>> of the v2 patch set.
>>>
>>> The major changes are:
>>>
>>> - There are two new module parameters: # of processes and # of queues per
>>>   process. The defaults, as agreed on in the v2 review, are 32 and 128
>>>   respectively. This sets the default amount of GART address space that amdkfd
>>>   requires to 3.5MB (3MB for userspace queues mqds and 0.5MB for other stuff,
>>>   such as mqd for kernel queue, hpd for pipelines, etc.)
>>>
>>> - All the GART address space usage of amdkfd is done inside a single contiguous
>>>   buffer that is allocated from system memory, and pinned to the start of the
>>>   GART during the startup of amdkfd (which is just after the startup of
>>>   radeon). The management of this buffer is done by the radeon sa manager.
>>>   This buffer is not evict-able.
>>>
>>> - Mapping of doorbells is initiated by the userspace lib (by mmap syscall),
>>>   instead of initiating it from inside an ioctl (using vm_mmap).
>>>
>>> - Removed ioctls for exclusive access to performance counters
>>>
>>> - Added documentation about the QCM (Queue Control Management), apertures and
>>>   interfaces between amdkfd and radeon.
>>>
>>> Two important notes:
>>>
>>> - The topology patch has not been changed. Look at
>>>   http://lists.freedesktop.org/archives/dri-devel/2014-July/065042.html
>>>   for my response. I also put my answer as an explanation in the commit msg
>>>   of the patch.
>>
>> This patchset adds 10.000 lines and contains nearly 0 comments *why*
>> stuff is added. Seriously, it is almost impossible to understand what
>> you're doing. Can you please include a high-level introduction in the
>> [0/X] cover-letter and include it in every series you send? A
>> blog-post or something would also be fine. And yes, it's totally ok if
>> this is 10k lines of plain-text.
> 
> My bad. I forgot to attach the cover letter of v2 and especially v1,
> which includes a lengthy explanation of the driver.
> 
> So here it is and I will respond to your other comments later.
> 
>         Oded
> 
> v2 cover letter:
> -------------------
> 
> As a continuation to the existing discussion, here is a v2 patch series
> restructured with a cleaner history and no totally-different-early-versions
> of the code.
> 
> Instead of 83 patches, there are now a total of 25 patches, where 5 of them
> are modifications to radeon driver and 18 of them include only amdkfd code.
> There is no code going away or even modified between patches, only added.
> 
> The driver was renamed from radeon_kfd to amdkfd and moved to reside under
> drm/radeon/amdkfd. This move was done to emphasize the fact that this
> driver
> is an AMD-only driver at this point. Having said that, we do foresee
> a generic hsa framework being implemented in the future and in that case,
> we will adjust amdkfd to work within that framework.
> 
> As the amdkfd driver should support multiple AMD gfx drivers, we want to
> keep it as a seperate driver from radeon. Therefore, the amdkfd code is
> contained in its own folder. The amdkfd folder was put under the radeon
> folder because the only AMD gfx driver in the Linux kernel at this point
> is the radeon driver. Having said that, we will probably need to move
> it (maybe to be directly under drm) after we integrate with additional AMD
> gfx drivers.
> 
> For people who like to review using git, the v2 patch set is located at:
> http://cgit.freedesktop.org/~gabbayo/linux/log/?h=kfd-next-3.17-v2
> 
> Written by Oded Gabbayh <oded.gabbay@amd.com>
> 
> -------------------------
> Original Cover Letter:
> -------------------------
> 
> This patch set implements a Heterogeneous System Architecture (HSA) driver
> for radeon-family GPUs.
> 
> HSA allows different processor types (CPUs, DSPs, GPUs, etc..) to share
> system resources more effectively via HW features including shared pageable
> memory, userspace-accessible work queues, and platform-level atomics. In
> addition to the memory protection mechanisms in GPUVM and IOMMUv2, the Sea
> Islands family of GPUs also performs HW-level validation of commands passed
> in through the queues (aka rings).
> 
> The code in this patch set is intended to serve both as a sample driver for
> other HSA-compatible hardware devices and as a production driver for
> radeon-family processors. The code is architected to support multiple CPUs
> each with connected GPUs, although the current implementation focuses on a
> single Kaveri/Berlin APU, and works alongside the existing radeon kernel
> graphics driver (kgd).
> 
> AMD GPUs designed for use with HSA (Sea Islands and up) share some hardware
> functionality between HSA compute and regular gfx/compute (memory,
> interrupts, registers), while other functionality has been added
> specifically for HSA compute  (hw scheduler for virtualized compute rings).
> All shared hardware is owned by the radeon graphics driver, and an
> interface
> between kfd and kgd allows the kfd to make use of those shared resources,
> while HSA-specific functionality is managed directly by kfd by submitting
> packets into an HSA-specific command queue (the "HIQ").
> 
> During kfd module initialization a char device node (/dev/kfd) is created
> (surviving until module exit), with ioctls for queue creation & management,
> and data structures are initialized for managing HSA device topology.
> 
> The rest of the initialization is driven by calls from the radeon kgd at
> the following points :
> 
> - radeon_init (kfd_init)
> - radeon_exit (kfd_fini)
> - radeon_driver_load_kms (kfd_device_probe, kfd_device_init)
> - radeon_driver_unload_kms (kfd_device_fini)
> 
> During the probe and init processing per-device data structures are
> established which connect to the associated graphics kernel driver. This
> information is exposed to userspace via sysfs, along with a version number
> allowing userspace to determine if a topology change has occurred while it
> was reading from sysfs.
> 
> The interface between kfd and kgd also allows the kfd to request buffer
> management services from kgd, and allows kgd to route interrupt requests to
> kfd code since the interrupt block is shared between regular
> graphics/compute and HSA compute subsystems in the GPU.
> 
> The kfd code works with an open source usermode library ("libhsakmt") which
> is in the final stages of IP review and should be published in a separate
> repo over the next few days.
> 
> The code operates in one of three modes, selectable via the sched_policy
> module parameter :
> 
> - sched_policy=0 uses a hardware scheduler running in the MEC block within
> CP, and allows oversubscription (more queues than HW slots)
> 
> - sched_policy=1 also uses HW scheduling but does not allow
> oversubscription, so create_queue requests fail when we run out of HW slots
> 
> - sched_policy=2 does not use HW scheduling, so the driver manually assigns
> queues to HW slots by programming registers
> 
> The "no HW scheduling" option is for debug & new hardware bringup only, so
> has less test coverage than the other options. Default in the current code
> is "HW scheduling without oversubscription" since that is where we have the
> most test coverage but we expect to change the default to "HW scheduling
> with oversubscription" after further testing. This effectively removes the
> HW limit on the number of work queues available to applications.
> 
> Programs running on the GPU are associated with an address space through
> the
> VMID field, which is translated to a unique PASID at access time via a set
> of 16 VMID-to-PASID mapping registers. The available VMIDs (currently 16)
> are partitioned (under control of the radeon kgd) between current
> gfx/compute and HSA compute, with each getting 8 in the current code. The
> VMID-to-PASID mapping registers are updated by the HW scheduler when used,
> and by driver code if HW scheduling is not being used.
> 
> The Sea Islands compute queues use a new "doorbell" mechanism instead of
> the
> earlier kernel-managed write pointer registers. Doorbells use a separate
> BAR
> dedicated for this purpose, and pages within the doorbell aperture are
> mapped to userspace (each page mapped to only one user address space).
> Writes to the doorbell aperture are intercepted by GPU hardware, allowing
> userspace code to safely manage work queues (rings) without requiring a
> kernel call for every ring update.
> 
> First step for an application process is to open the kfd device. Calls to
> open create a kfd "process" structure only for the first thread of the
> process. Subsequent open calls are checked to see if they are from
> processes
> using the same mm_struct and, if so, don't do anything. The kfd per-process
> data lives as long as the mm_struct exists. Each mm_struct is associated
> with a unique PASID, allowing the IOMMUv2 to make userspace process memory
> accessible to the GPU.
> 
> Next step is for the application to collect topology information via sysfs.
> This gives userspace enough information to be able to identify specific
> nodes (processors) in subsequent queue management calls. Application
> processes can create queues on multiple processors, and processors support
> queues from multiple processes.
> 
> At this point the application can create work queues in userspace memory
> and
> pass them through the usermode library to kfd to have them mapped onto HW
> queue slots so that commands written to the queues can be executed by the
> GPU. Queue operations specify a processor node, and so the bulk of this
> code
> is device-specific.
> 
> Written by John Bridgman <John.Bridgman@amd.com>
> 
> 
> 
>>
>> Lets start with the basics:
>>
>> 1) Why do you use kobject directly to expose the topology? Almost no
>> other driver does that, why do you use it in amdkfd instead of "struct
>> bus" and "struct device"? You totally lack uevent handling, sysfs
>> hierarchy integration and more. If you'd use existing infrastructue
>> instead of kobject directly, everything would work just fine.
>>
The development of the module was done according to this document:
https://www.kernel.org/doc/Documentation/filesystems/sysfs.txt

Could you please elaborate some more why we must use "struct bus" and
struct "device" ?

>> 2) What kind of topology is exposed? Is it nested? How deep? How many
>> items are usually expected? How does the sysfs tree (`tree
>> /sys/..../topology`) look like on your machine? For people without the
>> hardware it's nearly impossible to understand how this will look like.
I published v4 patch-set of amdkfd, and I put a snapshot of the topology
as it exists on a KV machine (only processor which is currently supported).
>>
>> 3) How is the interface supposed to be used? I can see one global
>> char-dev where you can queue jobs by providing a GPU-ID. Why don't you
>> create one char-dev *per* available GPU just like all other interfaces
>> do? Why is this a separate thing instead of a drm_minor object that
>> can be added per device as a separate interface to KMS and
>> render-nodes? Where is the underlying "struct device" for those GPUs?
>>
There were 2 major arguments for using a single fd :
1. Our ioctls are actually system calls in disguise. They operate on the
process, not on a device.

2. An HSA device won't always be a GPU. Therefore, we don't want to be
tied to drm framework too much.

You may call these arguments "philosophical" but nevertheless, I think
they are valid.

>> 4) Why is the topology static? FWIW, you allow runtime modifications,
>> but I cannot see any notification mechanism for user-space? Again,
>> using existing driver-core would provide all that for free.
Currently, we don't support any other processor than KV, and KV is an
integrated processor which can't be hot-plugged. Therefore, the topology
is static.
Our design states that the userspace is responsible for snapshotting the
topology before it opens our fd. Therefore, we don't use uevent to
notify the userspace about changes (currently theoretical) in the
topology. For example you can look at the libhsakmt code I published to
see how the userspace behaves with the topology.
>>
>> I really appreciate that you provided code instead of just ideas, but
>> please describe why you do things the way they are. And please provide
>> examples for people who do not have the hardware.
>>
>> Thanks
>> David
>>
>>> - There are still some minor code style issues I need to fix. I didn't want
>>>   to delay v3 any further but I will publish either v4 with those fixes,
>>>   or just relevant patches if the whole patch set will be merged.
>>>
>>> For people who like to review using git, the v3 patch set is located at:
>>> http://cgit.freedesktop.org/~gabbayo/linux/log/?h=kfd-next-3.17-v3
>>>
>>> In addition, I would like to announce that we have uploaded the userspace lib
>>> that accompanies amdkfd. That lib is called "libhsakmt" and you can view it at:
>>> http://cgit.freedesktop.org/~gabbayo/libhsakmt
>>>
>>> Alexey Skidanov (1):
>>>   amdkfd: Implement the Get Process Aperture IOCTL
>>>
>>> Andrew Lewycky (3):
>>>   amdkfd: Add basic modules to amdkfd
>>>   amdkfd: Add interrupt handling module
>>>   amdkfd: Implement the Set Memory Policy IOCTL
>>>
>>> Ben Goz (8):
>>>   amdkfd: Add queue module
>>>   amdkfd: Add mqd_manager module
>>>   amdkfd: Add kernel queue module
>>>   amdkfd: Add module parameter of scheduling policy
>>>   amdkfd: Add packet manager module
>>>   amdkfd: Add process queue manager module
>>>   amdkfd: Add device queue manager module
>>>   amdkfd: Implement the create/destroy/update queue IOCTLs
>>>
>>> Evgeny Pinchuk (2):
>>>   amdkfd: Add topology module to amdkfd
>>>   amdkfd: Implement the Get Clock Counters IOCTL
>>>
>>> Oded Gabbay (9):
>>>   drm/radeon: reduce number of free VMIDs and pipes in KV
>>>   drm/radeon/cik: Don't touch int of pipes 1-7
>>>   drm/radeon: Report doorbell configuration to amdkfd
>>>   drm/radeon: adding synchronization for GRBM GFX
>>>   drm/radeon: Add radeon <--> amdkfd interface
>>>   Update MAINTAINERS and CREDITS files with amdkfd info
>>>   amdkfd: Add IOCTL set definitions of amdkfd
>>>   amdkfd: Add amdkfd skeleton driver
>>>   amdkfd: Add binding/unbinding calls to amd_iommu driver
>>>
>>>  CREDITS                                            |    7 +
>>>  MAINTAINERS                                        |   10 +
>>>  drivers/gpu/drm/radeon/Kconfig                     |    2 +
>>>  drivers/gpu/drm/radeon/Makefile                    |    3 +
>>>  drivers/gpu/drm/radeon/amdkfd/Kconfig              |   10 +
>>>  drivers/gpu/drm/radeon/amdkfd/Makefile             |   14 +
>>>  drivers/gpu/drm/radeon/amdkfd/cik_regs.h           |  220 ++++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c       |  350 ++++++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c        |  511 +++++++++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_crat.h           |  294 +++++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_device.c         |  300 +++++
>>>  .../drm/radeon/amdkfd/kfd_device_queue_manager.c   |  989 ++++++++++++++++
>>>  .../drm/radeon/amdkfd/kfd_device_queue_manager.h   |  144 +++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c       |  236 ++++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c      |  161 +++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c   |  330 ++++++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h   |   66 ++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_module.c         |  147 +++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c    |  305 +++++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h    |   88 ++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c |  495 ++++++++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c          |   95 ++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h    |  682 +++++++++++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h    |  107 ++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_priv.h           |  560 +++++++++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_process.c        |  347 ++++++
>>>  .../drm/radeon/amdkfd/kfd_process_queue_manager.c  |  346 ++++++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_queue.c          |   85 ++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_topology.c       | 1207 ++++++++++++++++++++
>>>  drivers/gpu/drm/radeon/amdkfd/kfd_topology.h       |  168 +++
>>>  drivers/gpu/drm/radeon/cik.c                       |  154 +--
>>>  drivers/gpu/drm/radeon/cik_reg.h                   |   65 ++
>>>  drivers/gpu/drm/radeon/cikd.h                      |   53 +-
>>>  drivers/gpu/drm/radeon/radeon.h                    |   10 +
>>>  drivers/gpu/drm/radeon/radeon_device.c             |   32 +
>>>  drivers/gpu/drm/radeon/radeon_drv.c                |    5 +
>>>  drivers/gpu/drm/radeon/radeon_kfd.c                |  525 +++++++++
>>>  drivers/gpu/drm/radeon/radeon_kfd.h                |  177 +++
>>>  drivers/gpu/drm/radeon/radeon_kms.c                |    7 +
>>>  include/uapi/linux/kfd_ioctl.h                     |  126 ++
>>>  40 files changed, 9338 insertions(+), 95 deletions(-)
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/Kconfig
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/Makefile
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/cik_regs.h
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_crat.h
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.h
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_module.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_packet_manager.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_process.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_process_queue_manager.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_queue.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_topology.c
>>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_topology.h
>>>  create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.c
>>>  create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.h
>>>  create mode 100644 include/uapi/linux/kfd_ioctl.h
>>>
>>> --
>>> 1.9.1
>>>
>>> _______________________________________________
>>> dri-devel mailing list
>>> dri-devel@lists.freedesktop.org
>>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 
