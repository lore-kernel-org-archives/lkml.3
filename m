Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3KRSma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:42:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3KRSmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:42:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/24] 3.10.20-stable review
Date: Mon, 18 Nov 2013 10:42:10 -0800
Message-Id: <20131118184222.017393843@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.20 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Nov 20 18:42:04 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.20-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.20-rc1

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

Oren Givon <oren.givon@intel.com>
    iwlwifi: add new 7260 and 3160 series device IDs

Peter Zijlstra <peterz@infradead.org>
    perf: Fix perf ring buffer memory ordering

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix potential out-of-bounds in trace_get_user()

Anssi Hannula <anssi.hannula@iki.fi>
    ALSA: hda - hdmi: Fix reported channel map on common default layouts

Rui li <li.rui27@zte.com.cn>
    USB: add new zte 3g-dongle's pid to option.c

Gerd Hoffmann <kraxel@redhat.com>
    hyperv-fb: add pci stub

Matthias Schiffer <mschiffer@universe-factory.net>
    batman-adv: set up network coding packet handlers during module init

David Vrabel <david.vrabel@citrix.com>
    xen-netback: transition to CLOSED when removing a VIF

Paul Durrant <Paul.Durrant@citrix.com>
    xen-netback: Handle backend state transitions in a more robust way

Jack Morgenstein <jackm@dev.mellanox.co.il>
    net/mlx4_core: Fix call to __mlx4_unregister_mac

Jason Wang <jasowang@redhat.com>
    net: flow_dissector: fail on evil iph->ihl

Jason Wang <jasowang@redhat.com>
    virtio-net: correctly handle cpu hotplug notifier during resuming

Wei Liu <wei.liu2@citrix.com>
    xen-netback: use jiffies_64 value to calculate credit timeout

Ben Hutchings <ben@decadent.org.uk>
    cxgb3: Fix length calculation in write_ofld_wr() on 32-bit architectures

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: reset dst.expires value when clearing expire flag

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: ip6_dst_check needs to check for expired dst_entries

Pravin B Shelar <pshelar@nicira.com>
    ip_gre: Fix WCCPv2 header parsing.


-------------

Diffstat:

 Makefile                                  |   4 +-
 drivers/media/platform/sh_vou.c           |   2 +-
 drivers/misc/atmel_pwm.c                  |   6 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c  |   2 +-
 drivers/net/virtio_net.c                  |  13 ++-
 drivers/net/wireless/iwlwifi/iwl-7000.c   |  42 +++++++-
 drivers/net/wireless/iwlwifi/iwl-config.h |   6 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c   |  79 ++++++++++++++-
 drivers/net/xen-netback/common.h          |   1 +
 drivers/net/xen-netback/interface.c       |   3 +-
 drivers/net/xen-netback/netback.c         |  10 +-
 drivers/net/xen-netback/xenbus.c          | 153 ++++++++++++++++++++++++------
 drivers/usb/core/hcd.c                    |   1 +
 drivers/usb/core/hub.c                    |  18 +++-
 drivers/usb/core/usb.h                    |   1 +
 drivers/usb/serial/option.c               |  17 ++++
 drivers/video/backlight/atmel-pwm-bl.c    |   9 +-
 drivers/video/hyperv_fb.c                 |  40 +++++++-
 include/net/ip6_fib.h                     |   1 +
 include/net/ip_tunnels.h                  |   2 +-
 include/uapi/linux/perf_event.h           |  12 ++-
 kernel/events/ring_buffer.c               |  31 +++++-
 kernel/trace/trace.c                      |   5 +-
 net/batman-adv/main.c                     |   5 +-
 net/batman-adv/network-coding.c           |  28 ++++--
 net/batman-adv/network-coding.h           |  14 ++-
 net/core/flow_dissector.c                 |   2 +-
 net/ipv4/ip_gre.c                         |   2 +-
 net/ipv4/ip_tunnel.c                      |   4 +-
 net/ipv4/ipip.c                           |   2 +-
 net/ipv6/route.c                          |   9 +-
 sound/pci/hda/patch_hdmi.c                |   5 +-
 33 files changed, 428 insertions(+), 104 deletions(-)


