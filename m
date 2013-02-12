Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab3BLUhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:37:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab3BLUhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:37:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/22] 3.0.64-stable review
Date: Tue, 12 Feb 2013 12:36:43 -0800
Message-Id: <20130212203413.459836020@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.64 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Feb 14 20:31:38 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.64-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.64-rc1

Nithin Nayak Sujir <nsujir@broadcom.com>
    tg3: Fix crc errors on jumbo frame receive

Nithin Nayak Sujir <nsujir@broadcom.com>
    tg3: Avoid null pointer dereference in tg3_interrupt in netconsole mode

Sarveshwar Bandi <sarveshwar.bandi@emulex.com>
    bridge: Pull ip header into skb->data before looking into ip header.

Eric Dumazet <edumazet@google.com>
    tcp: fix MSG_SENDPAGE_NOTLAST logic

Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
    tcp: fix for zero packets_in_flight was too broad

Eric Dumazet <edumazet@google.com>
    tcp: frto should not set snd_cwnd to 0

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: sctp_endpoint_free: zero out secret key data

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree

Neil Horman <nhorman@tuxdriver.com>
    sctp: refactor sctp_outq_teardown to insure proper re-initalization

Heiko Carstens <heiko.carstens@de.ibm.com>
    atm/iphase: rename fregt_t -> ffreg_t

Phil Sutter <phil.sutter@viprinet.com>
    packet: fix leakage of tx_ring memory

Marcelo Ricardo Leitner <mleitner@redhat.com>
    ipv6: do not create neighbor entries for local delivery

Cong Wang <amwang@redhat.com>
    pktgen: correctly handle failures when adding a device

Eric Dumazet <edumazet@google.com>
    net: loopback: fix a dst refcounting issue

Timo Teräs <timo.teras@iki.fi>
    r8169: remove the obsolete and incorrect AMD workaround

Tilman Schmidt <tilman@imap.cc>
    isdn/gigaset: fix zero size border case in debug dump

Stephen Hemminger <stephen.hemminger@vyatta.com>
    MAINTAINERS: Stephen Hemminger email change

Cong Wang <xiyou.wangcong@gmail.com>
    net: prevent setting ttl=0 via IP_TTL

Stanislaw Gruszka <sgruszka@redhat.com>
    mac80211: synchronize scan off/on-channel and PS states

T Makphaibulchoke <tmac@hp.com>
    kernel/resource.c: fix stack overflow in __reserve_region_with_split()

Sjur Brændeland <sjur.brandeland@stericsson.com>
    virtio_console: Don't access uninitialized data.

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Fix the usage of the wrong variable in usb.c


-------------

Diffstat:

 MAINTAINERS                        |   6 +-
 Makefile                           |   4 +-
 drivers/atm/iphase.h               | 146 ++++++++++++++++++++--------------------
 drivers/char/virtio_console.c      |   3 +-
 drivers/isdn/gigaset/capi.c        |   2 +
 drivers/net/loopback.c             |   5 ++
 drivers/net/r8169.c                |   7 --
 drivers/net/tg3.c                  |  58 ++++++++++------
 drivers/net/wireless/rtlwifi/usb.c |   4 +-
 fs/splice.c                        |   4 +-
 kernel/resource.c                  |  50 ++++++++++----
 net/bridge/br_netfilter.c          |   3 +
 net/core/pktgen.c                  |   9 ++-
 net/ipv4/ip_sockglue.c             |   2 +-
 net/ipv4/tcp_input.c               |   5 ++
 net/ipv6/route.c                   |   3 +-
 net/mac80211/ieee80211_i.h         |   6 +-
 net/mac80211/offchannel.c          |  17 ++---
 net/mac80211/scan.c                |   6 +-
 net/mac80211/work.c                |   8 +--
 net/packet/af_packet.c             |  10 +--
 net/sctp/endpointola.c             |   5 ++
 net/sctp/outqueue.c                |  12 ++--
 net/sctp/socket.c                  |   2 +-
 24 files changed, 218 insertions(+), 159 deletions(-)


