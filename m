Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab3GKWGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:06:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3GKWBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:01:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/19] 3.10.1-stable review
Date: Thu, 11 Jul 2013 15:01:17 -0700
Message-Id: <20130711214830.611455274@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<rant>
  I'm sitting on top of over 170 more patches that have been marked for
  the stable releases right now that are not included in this set of
  releases.  The fact that there are this many patches for stable stuff
  that are waiting to be merged through the main -rc1 merge window cycle
  is worrying to me.

  Why are subsystem maintainers holding on to fixes that are
  _supposedly_ affecting all users?  I mean, 21 powerpc core changes
  that I don't see until a -rc1 merge?  It's as if developers don't
  expect people to use a .0 release and are relying on me to get the
  fixes they have burried in their trees out to users.  That's not that
  nice.  6 "core" iscsi-target fixes?  That's the sign of either a
  broken subsystem maintainer, or a lack of understanding what the
  normal -rc kernel releases are supposed to be for.

  So, I've picked through the patches and dug out only those that I've
  "guessed" at being more important than others for the 3.10.1 release.
  I'll get to the rest of these after 3.11-rc1 is out, and eventually
  they will make it into the stable releases, but I am going to be much
  more strict as to what is being added (carriage return changes for
  debug messages, really ACPI developers?)

</rant>

This is the start of the stable review cycle for the 3.10.1 release.
There are 19 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jul 13 21:45:35 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.1-rc1

Michal Hocko <mhocko@suse.cz>
    Revert "memcg: avoid dangling reference count in creation failure"

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    cpufreq: Fix cpufreq regression after suspend/resume

Ben Hutchings <ben@decadent.org.uk>
    SCSI: sd: Fix parsing of 'temporary ' cache mode prefix

Gleb Natapov <gleb@redhat.com>
    KVM: VMX: mark unusable segment as nonpresent

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix decoding of compounds across page boundaries

Andy Adamson <andros@netapp.com>
    NFSv4.1 end back channel session draining

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller"

Peter Hurley <peter@hurleysoftware.com>
    tty: Reset itty for other pty

Zhang Yi <wetpzy@gmail.com>
    futex: Take hugepages into account when generating futex_key

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    MAINTAINERS: add stable_kernel_rules.txt to stable maintainer information

Kees Cook <keescook@chromium.org>
    crypto: sanitize argument for format string

Kees Cook <keescook@chromium.org>
    block: do not pass disk names as format strings

Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
    hpfs: better test for errors

Kees Cook <keescook@chromium.org>
    charger-manager: Ensure event is not used as format string

Rusty Russell <rusty@rustcorp.com.au>
    module: do percpu allocation after uniqueness check. No, really!

Jonathan Salwan <jonathan.salwan@gmail.com>
    drivers/cdrom/cdrom.c: use kzalloc() for failing hardware

Josh Durgin <josh.durgin@inktank.com>
    libceph: fix invalid unsigned->signed conversion for timespec encoding

majianpeng <majianpeng@gmail.com>
    ceph: fix sleeping function called from invalid context.

Tyler Hicks <tyhicks@canonical.com>
    libceph: Fix NULL pointer dereference in auth client code


-------------

Diffstat:

 MAINTAINERS                        |  1 +
 Makefile                           |  4 ++--
 arch/x86/kvm/vmx.c                 | 11 +++++++++--
 block/genhd.c                      |  2 +-
 crypto/algapi.c                    |  3 ++-
 drivers/block/nbd.c                |  3 ++-
 drivers/cdrom/cdrom.c              |  2 +-
 drivers/cpufreq/cpufreq_stats.c    |  1 +
 drivers/power/charger-manager.c    |  2 +-
 drivers/scsi/osd/osd_uld.c         |  2 +-
 drivers/scsi/sd.c                  |  2 +-
 drivers/tty/serial/8250/8250_pci.c |  4 ----
 drivers/tty/tty_io.c               |  2 ++
 fs/ceph/xattr.c                    |  9 +++++----
 fs/hpfs/map.c                      |  3 ++-
 fs/hpfs/super.c                    |  8 +++++++-
 fs/nfs/nfs4state.c                 | 23 +++++++++++------------
 fs/nfsd/nfs4xdr.c                  |  2 +-
 include/linux/ceph/decode.h        |  5 -----
 include/linux/hugetlb.h            | 16 ++++++++++++++++
 kernel/futex.c                     |  3 ++-
 kernel/module.c                    | 34 ++++++++++++++++++----------------
 mm/hugetlb.c                       | 17 +++++++++++++++++
 mm/memcontrol.c                    |  2 --
 net/ceph/auth_none.c               |  6 ++++++
 25 files changed, 109 insertions(+), 58 deletions(-)


