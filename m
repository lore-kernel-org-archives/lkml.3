Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967299Ab3HIBmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:42:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966952Ab3HIBll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:41:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/22] 3.0.90-stable review
Date: Thu,  8 Aug 2013 18:41:16 -0700
Message-Id: <20130809013949.226228694@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.90 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Aug 11 01:37:07 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.90-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.90-rc1

Dan Carpenter <dan.carpenter@oracle.com>
    net_sched: info leak in atm_tc_dump_class()

Dan Carpenter <dan.carpenter@oracle.com>
    af_key: more info leaks in pfkey messages

David S. Miller <davem@davemloft.net>
    net_sched: Fix stack info leak in cbq_dump_wrr().

Eric Dumazet <edumazet@google.com>
    usbnet: do not pretend to support SG/TSO

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: take rtnl_lock and mark mrt6 table as freed on namespace cleanup

Neil Horman <nhorman@tuxdriver.com>
    sctp: fully initialize sctp_outq in sctp_outq_init

Michal Tesar <mtesar@redhat.com>
    sysctl net: Keep tcp_syn_retries inside the boundary

Dan Carpenter <dan.carpenter@oracle.com>
    arcnet: cleanup sizeof parameter

Salman Qazi <sqazi@google.com>
    perf: Use css_tryget() to avoid propping up css refcount

H.J. Lu <hjl.tools@gmail.com>
    x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz

Jiri Olsa <jolsa@redhat.com>
    perf: Fix event group context move

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    MAINTAINERS: fix up stable_kernel_rules.txt location

Dan Carpenter <dan.carpenter@oracle.com>
    fanotify: info leak in copy_event_to_user()

Zhu Yanhai <gaoyang.zyh@taobao.com>
    sched: Fix the broken sched_rr_get_interval()

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / battery: Fix parsing _BIX return value

Tomasz Moń <desowin@gmail.com>
    mwifiex: Add missing endian conversion.

Stanislaw Gruszka <stf_xl@wp.pl>
    rt2x00: fix stop queue

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix duplicate retransmission detection

Michal Kazior <michal.kazior@tieto.com>
    nl80211: fix mgmt tx status and testmode reporting for netns

Oleksij Rempel <linux@rempel-privat.de>
    ath9k_htc: do some initial hardware configuration

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial/mxs-auart: increase time to wait for transmitter to become idle

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial/mxs-auart: fix race condition in interrupt handler


-------------

Diffstat:

 MAINTAINERS                                   |  4 +--
 Makefile                                      |  4 +--
 arch/x86/kernel/i387.c                        |  2 +-
 drivers/acpi/battery.c                        |  2 ++
 drivers/net/arcnet/arcnet.c                   |  2 +-
 drivers/net/usb/smsc75xx.c                    | 12 +++------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  1 +
 drivers/net/wireless/mwifiex/sdio.c           |  4 +--
 drivers/net/wireless/rt2x00/rt2x00queue.c     | 18 ++++++++-----
 drivers/tty/serial/mxs-auart.c                | 38 ++++++++++++++++-----------
 fs/notify/fanotify/fanotify_user.c            |  1 +
 kernel/events/core.c                          | 30 +++++++++++++++++----
 kernel/sched_fair.c                           |  2 +-
 net/ipv4/sysctl_net_ipv4.c                    |  6 ++++-
 net/ipv6/ip6mr.c                              |  5 ++++
 net/key/af_key.c                              |  4 +++
 net/mac80211/rx.c                             | 10 +++++--
 net/sched/sch_atm.c                           |  1 +
 net/sched/sch_cbq.c                           |  1 +
 net/sctp/outqueue.c                           |  8 ++----
 net/wireless/nl80211.c                        |  7 +++--
 21 files changed, 105 insertions(+), 57 deletions(-)


