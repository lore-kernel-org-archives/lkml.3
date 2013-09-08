Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449Ab3IHRBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 13:01:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab3IHRBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 13:01:42 -0400
Message-ID: <1378659692.2631.18.camel@ul30vt.home>
Subject: [GIT PULL] VFIO for v3.12
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Yann Droneaud <ydroneaud@opteya.com>,
        Zi Shen Lim <zishen.lim@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Date: Sun, 08 Sep 2013 11:01:32 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cb3e4330e697dffaf3d9cefebc9c7e7d39c89f2e:

  Merge branch 'x86-mm-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2013-09-04 09:39:26 -0700)

are available in the git repository at:


  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.12-rc0

for you to fetch changes up to dac09b57c0ff57e55dd6fa5109076c8af0468a75:

  vfio: fix documentation (2013-09-05 16:36:21 -0600)

----------------------------------------------------------------
VFIO updates include safer default file flags for VFIO device fds,
an external user interface exported to allow other modules to hold
references to VFIO groups, a fix to test for extended config space
on PCIe and PCI-x, and new hot reset interfaces for PCI devices
which allows the user to do PCI bus/slot resets when all of the
devices affected by the reset are owned by the user.

For this last feature, the PCI bus reset interface, I depend on
changes already merged from Bjorn's PCI pull request.  I therefore
merged my tree up to commit cb3e433, which I think was the correct
action, but as Stephen Rothwell noted, I failed to provide a commit
message indicating why the merge was required.  Sorry for that.
Thanks,
Alex

----------------------------------------------------------------
Alex Williamson (5):
      vfio: Add O_CLOEXEC flag to vfio device fd
      vfio-pci: Use fdget() rather than eventfd_fget()
      vfio-pci: Test for extended config space
      Merge remote branch 'origin/master' into next-merge
      vfio-pci: PCI hot reset interface

Alexey Kardashevskiy (1):
      vfio: add external user support

Yann Droneaud (1):
      vfio: use get_unused_fd_flags(0) instead of get_unused_fd()

Zi Shen Lim (1):
      vfio: fix documentation

 Documentation/vfio.txt             |   8 +-
 drivers/vfio/pci/vfio_pci.c        | 286 ++++++++++++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_config.c |  11 +-
 drivers/vfio/pci/vfio_pci_intrs.c  |  35 +++--
 drivers/vfio/vfio.c                |  64 ++++++++-
 include/linux/vfio.h               |   7 +
 include/uapi/linux/vfio.h          |  38 +++++
 7 files changed, 421 insertions(+), 28 deletions(-)

