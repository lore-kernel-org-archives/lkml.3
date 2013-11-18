Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3KRTDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:03:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab3KRSkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:40:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.11 00/25] 3.11.9-stable review
Date: Mon, 18 Nov 2013 10:40:29 -0800
Message-Id: <20131118184032.248465920@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.11.9 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Nov 20 18:40:06 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.9-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.11.9-rc1

Dan Carpenter <dan.carpenter@oracle.com>
    media: sh_vou: almost forever loop in sh_vou_try_fmt_vid_out()

Xenia Ragiadakou <burzalodowa@gmail.com>
    usbcore: set lpm_capable field for LPM capable root hubs

Krzysztof Mazur <krzysiek@podlesie.net>
    usb: fail on usb_hub_create_port_device() errors

Krzysztof Mazur <krzysiek@podlesie.net>
    usb: fix cleanup after failure in hub_configure()

Johan Hovold <jhovold@gmail.com>
    backlight: atmel-pwm-bl: fix deferred probe from __init

Johan Hovold <jhovold@gmail.com>
    misc: atmel_pwm: add deferred-probing support

Matti Gottlieb <matti.gottlieb@intel.com>
    iwlwifi: pcie: add new SKUs for 7000 & 3160 NIC series

Peter Zijlstra <peterz@infradead.org>
    perf: Fix perf ring buffer memory ordering

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dp: workaround BIOS eDP bpp clamping issue

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix potential out-of-bounds in trace_get_user()

Anssi Hannula <anssi.hannula@iki.fi>
    ALSA: hda - hdmi: Fix reported channel map on common default layouts

Rui li <li.rui27@zte.com.cn>
    USB: add new zte 3g-dongle's pid to option.c

Gerd Hoffmann <kraxel@redhat.com>
    hyperv-fb: add pci stub

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    Thermal: x86_pkg_temp: change spin lock

David Vrabel <david.vrabel@citrix.com>
    xen-netback: transition to CLOSED when removing a VIF

Paul Durrant <Paul.Durrant@citrix.com>
    xen-netback: Handle backend state transitions in a more robust way

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: reset dst.expires value when clearing expire flag

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: ip6_dst_check needs to check for expired dst_entries

Eric Dumazet <edumazet@google.com>
    tcp: gso: fix truesize tracking

Ben Hutchings <ben@decadent.org.uk>
    cxgb3: Fix length calculation in write_ofld_wr() on 32-bit architectures

Wei Liu <wei.liu2@citrix.com>
    xen-netback: use jiffies_64 value to calculate credit timeout

Jason Wang <jasowang@redhat.com>
    virtio-net: correctly handle cpu hotplug notifier during resuming

Jason Wang <jasowang@redhat.com>
    net: flow_dissector: fail on evil iph->ihl

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: do not trigger BUG_ON in sctp_cmd_delete_tcb

Jack Morgenstein <jackm@dev.mellanox.co.il>
    net/mlx4_core: Fix call to __mlx4_unregister_mac


-------------

Diffstat:

 Makefile                                 |   4 +-
 drivers/gpu/drm/i915/intel_dp.c          |  20 ++++
 drivers/media/platform/sh_vou.c          |   2 +-
 drivers/misc/atmel_pwm.c                 |   6 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c |   3 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c |   2 +-
 drivers/net/virtio_net.c                 |  13 ++-
 drivers/net/wireless/iwlwifi/pcie/drv.c  |  35 ++++++-
 drivers/net/xen-netback/common.h         |   1 +
 drivers/net/xen-netback/interface.c      |   3 +-
 drivers/net/xen-netback/netback.c        |  10 +-
 drivers/net/xen-netback/xenbus.c         | 152 +++++++++++++++++++++++++------
 drivers/thermal/x86_pkg_temp_thermal.c   |  14 +--
 drivers/usb/core/hcd.c                   |   1 +
 drivers/usb/core/hub.c                   |  18 +++-
 drivers/usb/core/usb.h                   |   1 +
 drivers/usb/serial/option.c              |  17 ++++
 drivers/video/backlight/atmel-pwm-bl.c   |   9 +-
 drivers/video/hyperv_fb.c                |  40 +++++++-
 include/net/ip6_fib.h                    |   1 +
 include/uapi/linux/perf_event.h          |  12 ++-
 kernel/events/ring_buffer.c              |  31 ++++++-
 kernel/trace/trace.c                     |   5 +-
 net/core/flow_dissector.c                |   2 +-
 net/ipv4/tcp_offload.c                   |  13 +--
 net/ipv6/route.c                         |   9 +-
 net/sctp/sm_sideeffect.c                 |   1 -
 sound/pci/hda/patch_hdmi.c               |   5 +-
 28 files changed, 337 insertions(+), 93 deletions(-)


