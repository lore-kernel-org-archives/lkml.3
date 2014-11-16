Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119AbaKPWAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:00:22 -0500
Received: from 1wt.eu ([62.212.114.60]:47841 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbaKPWAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:21 -0500
Message-Id: <20141116215328.631129227@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:28 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 00/48] 2.6.32.64-longterm review
Message-ID: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.64 release.
All patches will be posted as a response to this one. If anyone has any
issue with these being applied, please let me know. If anyone is a
maintainer of the proper subsystem, and wants to add a Signed-off-by: line
to the patch, please respond with it.

Responses should be made within 72 hours. Anything received after that time
might be too late. If someone wants a bit more time for a deeper review,
please let me know.

The whole patch series can be found in one patch at :
     kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.64-rc1.gz

The shortlog and diffstat are appended below.

Thanks,
Willy

 arch/arm/lib/memset.S               | 100 +++++-----
 arch/mips/include/asm/thread_info.h |   3 +
 arch/mips/kernel/scall32-o32.S      |   2 +-
 arch/mips/kernel/scall64-64.S       |   2 +-
 arch/mips/kernel/scall64-n32.S      |   2 +-
 arch/mips/kernel/scall64-o32.S      |   2 +-
 arch/x86/include/asm/ptrace.h       |  16 ++
 arch/x86/kernel/entry_32.S          |  13 +-
 drivers/char/tty_io.c               |   7 +-
 drivers/md/dm-crypt.c               |  20 +-
 drivers/md/raid5.c                  |   2 +
 drivers/net/gianfar.c               |   6 -
 drivers/net/macvlan.c               |   1 +
 drivers/net/ppp_generic.c           |   2 +-
 drivers/net/pppoe.c                 |   2 +-
 drivers/net/sunvnet.c               |  20 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   4 +
 drivers/usb/serial/kobil_sct.c      |   4 +-
 drivers/usb/serial/option.c         | 129 ++++++++++++-
 fs/isofs/inode.c                    |  15 +-
 fs/isofs/isofs.h                    |  23 ++-
 fs/isofs/rock.c                     |  39 ++--
 fs/namei.c                          |   1 +
 fs/nfsd/nfs4xdr.c                   |   8 +-
 fs/proc/base.c                      |   1 -
 include/linux/lzo.h                 |  15 +-
 include/linux/ptrace.h              |   3 +
 include/net/sctp/sm.h               |   6 +-
 include/sound/core.h                |   2 +
 kernel/futex.c                      |   1 +
 kernel/trace/ring_buffer.c          |  12 +-
 lib/lzo/lzo1x_compress.c            | 335 ++++++++++++++++++--------------
 lib/lzo/lzo1x_decompress.c          | 370 +++++++++++++++++++-----------------
 lib/lzo/lzodefs.h                   |  38 ++--
 mm/mlock.c                          |   2 +
 mm/rmap.c                           |  14 +-
 net/appletalk/ddp.c                 |   3 -
 net/compat.c                        |   9 +-
 net/core/filter.c                   |   8 +-
 net/core/iovec.c                    |  10 +-
 net/core/skbuff.c                   |   2 +-
 net/ipv4/igmp.c                     |  10 +-
 net/ipv4/ip_options.c               |   4 +
 net/ipv4/tcp_input.c                |   2 +-
 net/ipv4/tcp_vegas.c                |   3 +-
 net/ipv4/tcp_veno.c                 |   2 +-
 net/netfilter/nfnetlink_log.c       |  14 +-
 net/sctp/associola.c                |   3 +-
 net/sctp/output.c                   |   2 +-
 net/sctp/sm_make_chunk.c            | 100 +++++-----
 net/sctp/sm_statefuns.c             |  18 +-
 net/sctp/ulpevent.c                 | 122 ++----------
 sound/core/control.c                |  38 +++-
 sound/core/init.c                   |   1 +
 54 files changed, 918 insertions(+), 655 deletions(-)


