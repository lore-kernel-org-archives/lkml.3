Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaC1SGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:06:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaC1Rag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/22] 3.10.35-stable review
Date: Fri, 28 Mar 2014 10:31:52 -0700
Message-Id: <20140328173109.378288825@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.35 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Mar 30 17:30:55 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.35-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.35-rc1

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    sched/autogroup: Fix race with task_groups list

Michele Baldessari <michele@acksyn.org>
    e100: Fix "disabling already-disabled device" warning

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Fix resume issues on Renesas chips in Samsung laptops

Ping Cheng <pinglinux@gmail.com>
    Input: wacom - make sure touch_max is set for touch devices

Marcelo Tosatti <mtosatti@redhat.com>
    KVM: VMX: fix use after free of vmx->loaded_vmcs

Marcelo Tosatti <mtosatti@redhat.com>
    KVM: x86: handle invalid root_hpa everywhere

Marcelo Tosatti <mtosatti@redhat.com>
    KVM: MMU: handle invalid root_hpa at __direct_map

Hans de Goede <hdegoede@redhat.com>
    Input: elantech - improve clickpad detection

Rob Herring <rob.herring@calxeda.com>
    ARM: highbank: avoid L2 cache smc calls when PL310 is not present

Rob Herring <rob.herring@calxeda.com>
    ARM: move outer_cache declaration out of ifdef

Markus Pargmann <mpa@pengutronix.de>
    regulator: core: Replace direct ops->disable usage

Dan Carpenter <dan.carpenter@oracle.com>
    p54: clamp properly instead of just truncating

Ben Hutchings <ben@decadent.org.uk>
    deb-pkg: Fix cross-building linux-headers package

Alexei Starovoitov <ast@plumgrid.com>
    x86: bpf_jit: support negative offsets

Stephen Warren <swarren@nvidia.com>
    ASoC: max98090: make REVISION_ID readable

Josh Durgin <josh.durgin@inktank.com>
    libceph: resend all writes after the osdmap loses the full flag

Josh Durgin <josh.durgin@inktank.com>
    libceph: block I/O when PAUSE or FULL osd map flags are set

Dan Carpenter <dan.carpenter@oracle.com>
    media: cx18: check for allocation failure in cx18_read_eeprom()

Dan Carpenter <dan.carpenter@oracle.com>
    media: dw2102: some missing unlocks on error

Dan Carpenter <dan.carpenter@oracle.com>
    media: cxusb: unlock on error in cxusb_i2c_xfer()

Vaibhav Nagarnaik <vnagarnaik@google.com>
    tracing: Fix array size mismatch in format string

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ALSA: compress: Pass through return value of open ops callback


-------------

Diffstat:

 Makefile                             |  4 +--
 arch/arm/include/asm/outercache.h    |  4 +--
 arch/arm/mach-highbank/highbank.c    | 13 ++++----
 arch/x86/kvm/mmu.c                   | 12 ++++++++
 arch/x86/kvm/paging_tmpl.h           |  8 +++++
 arch/x86/kvm/vmx.c                   |  2 +-
 arch/x86/net/bpf_jit.S               |  2 +-
 drivers/input/mouse/elantech.c       | 45 ++++++++++++++++++++++++++--
 drivers/input/tablet/wacom_sys.c     |  7 +++--
 drivers/media/pci/cx18/cx18-driver.c |  5 +++-
 drivers/media/usb/dvb-usb/cxusb.c    | 21 +++++++++----
 drivers/media/usb/dvb-usb/dw2102.c   | 52 ++++++++++++++++++++++----------
 drivers/net/ethernet/intel/e100.c    |  2 +-
 drivers/net/wireless/p54/txrx.c      |  2 +-
 drivers/regulator/core.c             | 34 ++++++++-------------
 drivers/usb/host/xhci-pci.c          |  5 ++++
 include/linux/ceph/osd_client.h      |  1 +
 include/linux/ftrace_event.h         |  4 ---
 include/trace/ftrace.h               |  7 ++---
 kernel/sched/auto_group.c            |  3 +-
 kernel/trace/trace_events.c          |  6 ----
 kernel/trace/trace_export.c          |  7 ++---
 net/ceph/osd_client.c                | 57 +++++++++++++++++++++++++++++++-----
 scripts/package/builddeb             |  9 +++---
 sound/core/compress_offload.c        |  2 +-
 sound/soc/codecs/max98090.c          |  1 +
 26 files changed, 216 insertions(+), 99 deletions(-)


