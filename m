Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaI1QpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 12:45:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:6290 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbaI1QpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 12:45:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,615,1406617200"; 
   d="asc'?scan'208";a="609918299"
Message-ID: <1411922704.3156.40.camel@dwillia2-mobl2.amr.corp.intel.com>
Subject: [GIT PULL] dmaengine-3.17, close my dmaengine tree
From: Dan Williams <dan.j.williams@intel.com>
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Vinod Koul <vinod.koul@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 28 Sep 2014 09:45:04 -0700
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-QxoVZTT4PIcYCGCvCT3l"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QxoVZTT4PIcYCGCvCT3l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Even though this has fixes marked for -stable, given the size and the
needed conflict resolutions this is 3.18-rc1/merge-window material.

The following changes since commit dcb99fd9b08cfe1afe426af4d8d3cbc429190f15=
:

  Linux 3.14-rc7 (2014-03-16 18:51:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine tags/dmaengi=
ne-3.17


These patches have been languishing in my tree for a long while.  The
fact that I do not have the time to do proper/prompt maintenance of this
tree is a primary factor in the decision to step down as dmaengine
maintainer.  That and the fact that the bulk of drivers/dma/ activity is
going through Vinod these days.

The net_dma removal has not been in -next.  It has developed simple
conflicts against mainline and net-next (for-3.18).  I have resolved
those conflicts here:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine dmaengine-3.=
17+conflicts

...which is a back-merge of 3.17-rc6 and current net-next into
dmaengine-3.17.  I figure you would like to resolve those yourself, and
that -stable would appreciate the older net_dma removal commit.  This is
more a heads up to Dave and Stephen that "conflicts are coming".

Stephen: please remove the dmaengine tree from -next:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine next

Finally, someone scream at me if you would rather I just rebase the
net_dma removal and let it soak in -next properly.

Continuing thanks to Vinod for staying on top of drivers/dma/.

--
Dan


----------------------------------------------------------------
dmaengine-3.17

1/ Step down as dmaengine maintainer see commit 08223d80df38 "dmaengine
   maintainer update"

2/ Removal of net_dma, as it has been marked 'broken' since 3.13 (commit
   77873803363c "net_dma: mark broken"), without reports of performance
   regression.

3/ Miscellaneous fixes

----------------------------------------------------------------
Alexander Gordeev (1):
      ioat: Use pci_enable_msix_exact() instead of pci_enable_msix()

Andy Shevchenko (1):
      dmatest: prevent memory leakage on error path in thread

Dan Williams (4):
      dmaengine maintainer update
      net_dma: simple removal
      net_dma: revert 'copied_early'
      net: make tcp_cleanup_rbuf private

Ezequiel Garcia (4):
      dma: mv_xor: Add DMA API error checks
      dma: mv_xor: Remove unneeded mv_xor_clean_completed_slots() call
      dma: mv_xor: Remove all callers of mv_xor_slot_cleanup()
      dma: mv_xor: Rename __mv_xor_slot_cleanup() to mv_xor_slot_cleanup()

Manuel Sch=C3=B6lling (1):
      ioat: Use time_before_jiffies()

Rashika (2):
      drivers: dma: Mark functions as static in dma_v3.c
      drivers: dma: Include appropriate header file in dca.c

Xuelin Shi (1):
      dmaengine: fix xor sources continuation

Yijing Wang (1):
      ioat/dca: Use dev_is_pci() to check whether it is pci device

 Documentation/ABI/removed/net_dma      |   8 +
 Documentation/networking/ip-sysctl.txt |   6 -
 MAINTAINERS                            |  19 +--
 crypto/async_tx/async_xor.c            |   3 +-
 drivers/dma/Kconfig                    |  12 --
 drivers/dma/Makefile                   |   1 -
 drivers/dma/dmaengine.c                | 104 ------------
 drivers/dma/dmatest.c                  |   4 +-
 drivers/dma/ioat/dca.c                 |  13 +-
 drivers/dma/ioat/dma.c                 |   3 +-
 drivers/dma/ioat/dma.h                 |   7 -
 drivers/dma/ioat/dma_v2.c              |   4 +-
 drivers/dma/ioat/dma_v3.c              |   7 +-
 drivers/dma/iovlock.c                  | 280 -----------------------------=
----
 drivers/dma/mv_xor.c                   |  80 ++++++++--
 include/linux/dmaengine.h              |  22 +--
 include/linux/skbuff.h                 |   8 +-
 include/linux/tcp.h                    |   8 -
 include/net/netdma.h                   |  32 ----
 include/net/sock.h                     |  19 +--
 include/net/tcp.h                      |   9 --
 kernel/sysctl_binary.c                 |   1 -
 net/core/Makefile                      |   1 -
 net/core/dev.c                         |  10 --
 net/core/sock.c                        |   6 -
 net/core/user_dma.c                    | 131 ---------------
 net/dccp/proto.c                       |   4 +-
 net/ipv4/sysctl_net_ipv4.c             |   9 --
 net/ipv4/tcp.c                         | 149 ++----------------
 net/ipv4/tcp_input.c                   |  83 +---------
 net/ipv4/tcp_ipv4.c                    |  18 +--
 net/ipv6/tcp_ipv6.c                    |  13 +-
 net/llc/af_llc.c                       |  10 +-
 33 files changed, 129 insertions(+), 955 deletions(-)
 create mode 100644 Documentation/ABI/removed/net_dma
 delete mode 100644 drivers/dma/iovlock.c
 delete mode 100644 include/net/netdma.h
 delete mode 100644 net/core/user_dma.c

Full log:

commit 3f334078567245429540e6461c81c749fce87f70
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Dec 30 17:12:07 2013 -0800

    net: make tcp_cleanup_rbuf private
   =20
    net_dma was the only external user so this can become local to tcp.c
    again.
   =20
    Cc: James Morris <jmorris@namei.org>
    Cc: Patrick McHardy <kaber@trash.net>
    Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
    Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
    Acked-by: Neal Cardwell <ncardwell@google.com>
    Acked-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d27f9bc104375a0a835cf68bb88fc9cec69125da
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Dec 30 11:37:15 2013 -0800

    net_dma: revert 'copied_early'
   =20
    Now that tcp_dma_try_early_copy() is gone nothing ever sets
    copied_early.
   =20
    Also reverts "53240c208776 tcp: Fix possible double-ack w/ user dma"
    since it is no longer necessary.
   =20
    Cc: Ali Saidi <saidi@engin.umich.edu>
    Cc: James Morris <jmorris@namei.org>
    Cc: Patrick McHardy <kaber@trash.net>
    Cc: Eric Dumazet <edumazet@google.com>
    Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
    Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
    Cc: Neal Cardwell <ncardwell@google.com>
    Reported-by: Dave Jones <davej@redhat.com>
    Acked-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 7bced397510ab569d31de4c70b39e13355046387
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Dec 30 12:37:29 2013 -0800

    net_dma: simple removal
   =20
    Per commit "77873803363c net_dma: mark broken" net_dma is no longer use=
d
    and there is no plan to fix it.
   =20
    This is the mechanical removal of bits in CONFIG_NET_DMA ifdef guards.
    Reverting the remainder of the net_dma induced changes is deferred to
    subsequent patches.
   =20
    Marked for stable due to Roman's report of a memory leak in
    dma_pin_iovec_pages():
   =20
        https://lkml.org/lkml/2014/9/3/177
   =20
    Cc: Dave Jiang <dave.jiang@intel.com>
    Cc: Vinod Koul <vinod.koul@intel.com>
    Cc: David Whipple <whipple@securedatainnovations.ch>
    Cc: Alexander Duyck <alexander.h.duyck@intel.com>
    Cc: <stable@vger.kernel.org>
    Reported-by: Roman Gushchin <klamm@yandex-team.ru>
    Acked-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 08223d80df38e666a42d7c82eb340db55c6e03bd
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Aug 19 06:07:56 2014 -0700

    dmaengine maintainer update
   =20
    I am stepping down as dmaengine maintainer as the bulk of the activity
    in the subsystem is primarily targeted at the slave-dma case handled by
    Vinod, and I have recently been unable to give the few patches I do
    receive timely review.  There is still an item in my backlog to
    eliminate the async_tx api and the constraints it poses on dmaengine
    drivers, but I need not hold on to the maintainer role in the meantime.
    I will still be subscribed to dmaengine@vger.kernel.org to answer
    questions, but all patches should be routed through Vinod unless/until =
a
    maintainer for the non-slave-dma use case arrives.  It is non-entirely
    clear at this point that there is enough work going forward for a
    separate maintainer of the pure-offload case.
   =20
    Ongoing development of the ioatdma driver is handled by Dave.  I'm stil=
l
    interested in reviewing ioatdma patches, but he is the primary
    maintainer/developer going forward.
   =20
    IOP platforms are not generating any traffic in my inbox, but if a patc=
h
    did arrive I've long since lost access to hardware.
   =20
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Vinod Koul <vinod.koul@intel.com>
    Cc: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8e1f50d7433b9a6e52cb296943f53c3ce8189ea5
Author: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date:   Fri Aug 22 15:19:44 2014 +0300

    dmatest: prevent memory leakage on error path in thread
   =20
    When we fail to allocate memory for thread->srcs or thread->dsts and sr=
c_cnt or
    dst_cnt great than 1 we leak memory on error path. This patch fixes the=
 issue.
   =20
    Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e628ce70cae5ccd67830b0e2c3d038831746d86b
Author: Manuel Sch=C3=B6lling <manuel.schoelling@gmx.de>
Date:   Thu May 22 22:11:06 2014 +0200

    ioat: Use time_before_jiffies()
   =20
    To be future-proof and for better readability the time comparisons are =
modified
    to use time_before_jiffies() instead of plain, error-prone math.
   =20
    Signed-off-by: Manuel Sch=C3=B6lling <manuel.schoelling@gmx.de>
    [djbw: use time_before_jiffies() to make argument order more clear]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 87cea76384257e6ac3fa4791b6a6b9d0335f7457
Author: Xuelin Shi <xuelin.shi@freescale.com>
Date:   Tue Jul 1 16:32:38 2014 +0800

    dmaengine: fix xor sources continuation
   =20
    the partial xor result must be kept until the next
    tx is generated.
   =20
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Xuelin Shi <xuelin.shi@freescale.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit fbeec99ad5c03060ba71c470ac373e24e23a80e0
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Fri Mar 7 16:46:47 2014 -0300

    dma: mv_xor: Rename __mv_xor_slot_cleanup() to mv_xor_slot_cleanup()
   =20
    Now that mv_xor_slot_cleanup() has no remaining callers, we remove it
    and rename __mv_xor_slot_cleanup() to mv_xor_slot_cleanup().
   =20
    We take this opportunity to add a comment that makes it clear that the
    channel spinlock should be held before calling mv_xor_slot_cleanup().
   =20
    Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e43147acba6f64ba32664dd0e590657cc49b6940
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Fri Mar 7 16:46:46 2014 -0300

    dma: mv_xor: Remove all callers of mv_xor_slot_cleanup()
   =20
    In order to simplify the code, remove all the calls to the locked
    mv_xor_slot_cleanup() and instead use the unlocked version only,
   =20
    It's less error prone to have just one function, and require the caller
    to ensure proper locking.
   =20
    Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 890766d278548afdc059cd977687c4f1297d72a0
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Fri Mar 7 16:46:45 2014 -0300

    dma: mv_xor: Remove unneeded mv_xor_clean_completed_slots() call
   =20
    In mv_xor_status(), we are currently calling mv_xor_clean_completed_slo=
ts()
    when the transaction is complete (the cookie status is DMA_COMPLETE).
    However, a completed status means that mv_xor_slot_cleanup() was called=
,
    which cleans the completed slots.
   =20
    In other words, there's nothing to cleanup for a completed transaction =
in
    mv_xor_status(). Remove the unneeded call to mv_xor_clean_completed_slo=
ts().
   =20
    Reported-by: Dan Williams <dan.j.williams@intel.com>
    Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 368da992b93eaf8861f1ef2d27bbe22c01140733
Author: Alexander Gordeev <agordeev@redhat.com>
Date:   Thu Mar 6 21:11:21 2014 +0100

    ioat: Use pci_enable_msix_exact() instead of pci_enable_msix()
   =20
    As result of deprecation of MSI-X/MSI enablement functions
    pci_enable_msix() and pci_enable_msi_block() all drivers
    using these two interfaces need to be updated to use the
    new pci_enable_msi_range()  or pci_enable_msi_exact()
    and pci_enable_msix_range() or pci_enable_msix_exact()
    interfaces.
   =20
    Function pci_enable_msix() returns a tri-state value while
    pci_enable_msi_exact() is a canonical zero/-errno variant.
    The former is being phased out in favor of the latter.
    In case of 'ioat' there (should be) no difference.
   =20
    Cc: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2358b820d42a33f1d1052b438489c90a4cc8f3fc
Author: Rashika <rashika.kheria@gmail.com>
Date:   Mon Dec 16 15:44:39 2013 +0530

    drivers: dma: Include appropriate header file in dca.c
   =20
    Includes an appropriate header file dma_v2.h in ioat/dca.c because
    functions ioat2_dca_init() and ioat3_dca_init() have their function
    declarations in dma_v2.h.
   =20
    This eliminates the following warning in ioat/dca.c:
    drivers/dma/ioat/dca.c:410:22: warning: no previous prototype for =E2=
=80=98ioat2_dca_init=E2=80=99 [-Wmissing-prototypes]
    drivers/dma/ioat/dca.c:624:22: warning: no previous prototype for =E2=
=80=98ioat3_dca_init=E2=80=99 [-Wmissing-prototypes]
   =20
    Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
    Reviewed-by: Josh Triplett <josh@joshtriplett.org>
    Acked-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8d1d32767ca0df1b5cd75cdc1be3915bc6887ed1
Author: Rashika <rashika.kheria@gmail.com>
Date:   Mon Dec 16 15:40:40 2013 +0530

    drivers: dma: Mark functions as static in dma_v3.c
   =20
    Mark the functions ioat3_prep_xor_val(), ioat3_prep_pq_val() and
    ioat3_prep_pqxor_val() as static in dma_v3.c because they are not used
    outside this file.
   =20
    This eliminates the following warnings in dma_v3.c:
    drivers/dma/ioat/dma_v3.c:741:1: warning: no previous prototype for =E2=
=80=98ioat3_prep_xor_val=E2=80=99 [-Wmissing-prototypes]
    drivers/dma/ioat/dma_v3.c:1092:1: warning: no previous prototype for =
=E2=80=98ioat3_prep_pq_val=E2=80=99 [-Wmissing-prototypes]
    drivers/dma/ioat/dma_v3.c:1134:1: warning: no previous prototype for =
=E2=80=98ioat3_prep_pqxor_val=E2=80=99 [-Wmissing-prototypes]
   =20
    Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
    Reviewed-by: Josh Triplett <josh@joshtriplett.org>
    Acked-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b8c01d259a08d75c5049b2bd5f579648262c30a4
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Tue Dec 10 09:32:37 2013 -0300

    dma: mv_xor: Add DMA API error checks
   =20
    This commit adds proper error checking for various DMA API calls,
    as reported by DMA_API_DEBUG=3Dy.
   =20
    Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1fde2548460c1ded9fe71220b506473f0b7de768
Author: Yijing Wang <wangyijing@huawei.com>
Date:   Thu Dec 5 19:31:18 2013 +0800

    ioat/dca: Use dev_is_pci() to check whether it is pci device
   =20
    Use PCI standard marco dev_is_pci() instead of directly compare
    pci_bus_type to check whether it is pci device.
   =20
    Signed-off-by: Yijing Wang <wangyijing@huawei.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


--=-QxoVZTT4PIcYCGCvCT3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJUKDsQAAoJEB7SkWpmfYgCd1oP/Rs2UO3n0mm3gDQ7rzitBr+y
T1WtHDR+eZnOLpejOH8H6cduNO3vu7qIZ54lHNh+M+jde/vtc3fYyrBoiHs+VsY3
NOT3HlHm+bMHgv1U38Qq4W5Tt73lTIcudBbfmZhVy4P+g9A2b1qbm/xjEM9N218X
TSuYT1R8WLvyeq06wCN51g6/jhTSPeBMoDR4flrwzSo8xy1HIvTcDtBDk+pHZ6NI
oJKjck8NvLvsIglpSpPz3bXMadLjUBP1ktJqkErVYrMPgr/xV1o/Xl+pmZgF5aws
7M9o/V55dHV7Lw/5rq2RtKFh2rwFRwi4eeBiRB5I/AdIZ8NcWNm8bijkpU/wu5vA
EWONNwefSOtJlOTEE9Aw8rbtTRxPaLg+9b0lgz3gVRV/TdF4/w1LWXAiao3nGPV4
iASVoiaIM8Gdczx5Aj9/hAQxorhHgtZuJ0V0xNp8YoNvrd0oNHgS/hIzCfGps3QH
L5rsfxobpcSzYjQoBDqoLNVyr9K0+NaNGrBVIfcw+HnSFf5iujN0p2u5Cuon7Nuk
7AGhsSUMMs3di9TV9kykirzNZIcDw1Y5JtN7apVEYazZZzIOtFr2eCkwLKcTCgak
Xw9reotqZVMuIze7MDN5Sb/7zAVgAXl9FSlpBinAEYAZDo9OZtFV5r7XJh+mbYOd
AK3A27UvoOmB7yB1SCgB
=YLmI
-----END PGP SIGNATURE-----

--=-QxoVZTT4PIcYCGCvCT3l--

