Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaFXPvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:51:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaFXPvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:51:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/26] 3.4.95-stable review
Date: Tue, 24 Jun 2014 11:50:23 -0400
Message-Id: <20140624154619.499002156@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.95 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jun 26 15:46:05 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.95-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.95-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    lzo: properly check for overruns

Markus F.X.J. Oberhumer <markus@oberhumer.com>
    lib/lzo: Update LZO compression to current upstream version

Markus F.X.J. Oberhumer <markus@oberhumer.com>
    lib/lzo: Rename lzo1x_decompress.c to lzo1x_decompress_safe.c

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Make sure that id->index does not overflow

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Handle numid overflow

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Don't access controls outside of protected regions

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Fix replacing user controls

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: control: Protect user controls against concurrent access

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add support of ALC891 codec

Thomas Gleixner <tglx@linutronix.de>
    nohz: Fix another inconsistency between CONFIG_NO_HZ=n and nohz=off

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix runtime PM imbalance at shutdown

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix I/O after failed open

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix shutdown and suspend race

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix runtime PM for control messages

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix broken runtime suspend

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix write and resume race

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix write and suspend race

Michal Schmidt <mschmidt@redhat.com>
    netlink: rate-limit leftover bytes warning and print process name

Wei Yang <weiyang@linux.vnet.ibm.com>
    net/mlx4_core: Preserve pci_dev_data after __mlx4_remove_one()

Wei Yang <weiyang@linux.vnet.ibm.com>
    mlx4_core: Stash PCI ID driver_data in mlx4_priv structure

Xufeng Zhang <xufeng.zhang@windriver.com>
    sctp: Fix sk_ack_backlog wrap-around problem

Jiri Pirko <jiri@resnulli.us>
    team: fix mtu setting

Eric Dumazet <edumazet@google.com>
    net: fix inet_getid() and ipv6_select_ident() bugs

Tom Gundersen <teg@jklm.no>
    net: tunnels - enable module autoloading

Mimi Zohar <zohar@linux.vnet.ibm.com>
    evm: prohibit userspace writing 'security.evm' HMAC value

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Reject mutual authentication with reflected CHAP_C


-------------

Diffstat:

 Makefile                                  |   4 +-
 drivers/net/ethernet/mellanox/mlx4/main.c | 172 ++++++++-------
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |   7 +
 drivers/net/team/team.c                   |   7 +-
 drivers/target/iscsi/iscsi_target_auth.c  |  10 +
 drivers/usb/class/cdc-acm.c               |  96 +++++----
 drivers/usb/class/cdc-acm.h               |   2 +-
 include/linux/if_team.h                   |   1 +
 include/linux/lzo.h                       |  15 +-
 include/net/inetpeer.h                    |   9 +-
 include/sound/core.h                      |   2 +
 kernel/time/tick-sched.c                  |   4 +-
 lib/decompress_unlzo.c                    |   2 +-
 lib/lzo/Makefile                          |   2 +-
 lib/lzo/lzo1x_compress.c                  | 335 +++++++++++++++++-------------
 lib/lzo/lzo1x_decompress.c                | 255 -----------------------
 lib/lzo/lzo1x_decompress_safe.c           | 257 +++++++++++++++++++++++
 lib/lzo/lzodefs.h                         |  38 +++-
 lib/nlattr.c                              |   5 +-
 net/ipv4/ipip.c                           |   1 +
 net/ipv6/ip6_output.c                     |  11 +-
 net/ipv6/ip6_tunnel.c                     |   1 +
 net/ipv6/sit.c                            |   1 +
 net/sctp/associola.c                      |   2 +-
 security/integrity/evm/evm_main.c         |  12 +-
 sound/core/control.c                      |  78 ++++---
 sound/core/init.c                         |   1 +
 sound/pci/hda/patch_realtek.c             |   1 +
 28 files changed, 748 insertions(+), 583 deletions(-)


