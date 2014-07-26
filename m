Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaGZTC2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:02:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaGZTCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:02:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/23] 3.4.100-stable review
Date: Sat, 26 Jul 2014 12:02:00 -0700
Message-Id: <20140726190149.723570428@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.100 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Jul 28 19:01:37 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.100-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.100-rc1

Takao Indoh <indou.takao@jp.fujitsu.com>
    iommu/vt-d: Disable translation if already enabled

Takashi Iwai <tiwai@suse.de>
    PM / sleep: Fix request_firmware() error at resume

John Stultz <john.stultz@linaro.org>
    alarmtimer: Fix bug where relative alarm timers were treated as absolute

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: avoid leaking edid data

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: fix Tx timeout issue

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
    perf/x86/intel: ignore CondChgd bit to avoid false NMI handling

Eric Dumazet <edumazet@google.com>
    ipv4: fix buffer overflow in ip_options_compile()

Ben Hutchings <ben@decadent.org.uk>
    dns_resolver: Null-terminate the right string

Manuel Schölling <manuel.schoelling@gmx.de>
    dns_resolver: assure that dns_query() result is null-terminated

Sowmini Varadhan <sowmini.varadhan@oracle.com>
    sunvnet: clean up objects created in vnet_new() on vnet_exit()

Christoph Schulz <develop@kristov.de>
    net: pppoe: use correct channel MTU when using Multilink PPP

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix information leaks in ulpevent layer

Jon Paul Maloy <jon.maloy@ericsson.com>
    tipc: clear 'next'-pointer of message fragments before reassembly

Suresh Reddy <Suresh.Reddy@emulex.com>
    be2net: set EQ DB clear-intr bit in be_open()

Andrey Utkin <andrey.krieger.utkin@gmail.com>
    appletalk: Fix socket referencing in skb

Yuchung Cheng <ycheng@google.com>
    tcp: fix false undo corner cases

dingtianhong <dingtianhong@huawei.com>
    igmp: fix the problem when mc leave group

Li RongQing <roy.qing.li@gmail.com>
    8021q: fix a potential memory leak

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb

Hugh Dickins <hughd@google.com>
    shmem: fix splicing from a hole while it's punched

Hugh Dickins <hughd@google.com>
    shmem: fix faulting into a hole, not taking i_mutex

Hugh Dickins <hughd@google.com>
    shmem: fix faulting into a hole while it's punched

Markus F.X.J. Oberhumer <markus@oberhumer.com>
    crypto: testmgr - update LZO compression test vectors


-------------

Diffstat:

 Makefile                                    |   4 +-
 arch/x86/kernel/cpu/perf_event_intel.c      |   9 ++
 crypto/testmgr.h                            |  38 ++++----
 drivers/gpu/drm/radeon/radeon_display.c     |   5 +
 drivers/iommu/dmar.c                        |  11 ++-
 drivers/iommu/intel-iommu.c                 |  15 +++
 drivers/net/ethernet/emulex/benet/be_main.c |   2 +-
 drivers/net/ethernet/sun/sunvnet.c          |  20 +++-
 drivers/net/ppp/pppoe.c                     |   2 +-
 drivers/net/wireless/mwifiex/main.c         |   1 +
 kernel/power/process.c                      |   1 +
 kernel/time/alarmtimer.c                    |  20 +++-
 mm/shmem.c                                  | 139 ++++++++++++++++++++++++++--
 mm/truncate.c                               |  25 -----
 net/8021q/vlan_core.c                       |   5 +-
 net/appletalk/ddp.c                         |   3 -
 net/dns_resolver/dns_query.c                |   4 +-
 net/ipv4/igmp.c                             |  10 +-
 net/ipv4/ip_options.c                       |   4 +
 net/ipv4/tcp_input.c                        |  10 +-
 net/ipv4/tcp_output.c                       |   6 +-
 net/sctp/ulpevent.c                         | 122 +++---------------------
 net/tipc/bcast.c                            |   1 +
 23 files changed, 274 insertions(+), 183 deletions(-)


