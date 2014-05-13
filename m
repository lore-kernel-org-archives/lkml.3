Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbaEMPAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:00:41 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:49834 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965051AbaEMPAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:00:33 -0400
From: Michael Mueller <mimu@linux.vnet.ibm.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Graf <agraf@suse.de>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Andreas Faerber <afaerber@suse.de>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>, mimu@linux.vnet.ibm.com
Subject: [PATCH v1 RFC 00/10] QEMU: s390: cpu model implementation
Date: Tue, 13 May 2014 17:00:12 +0200
Message-Id: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051315-1948-0000-0000-000008C5B953
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set in combination with its kernel kvm patch set proposes an
implementation of S390 cpu models. The origin of this item is to provide
a means for management interfaces like libvirt to draw decisions if life
guest migration to a target hypervisor is reasonable.

A migration constraint is that a target hypervisor is capable to run a
guest with the same S390 cpu model as the source hypervisor does. To
verify this condition, the administration interface employes the existing
QMP command "query-cpu-definitions" which returns a list of all currently
supported S390 cpu models of a given host system. Together with the newly
defined QMP command "query-cpu-model", which returns the current active
S390 cpu model of a guest, a conclusion can be drawn if a migration is
possible.

A S390 cpu model is defined as a triple of machine type, cpu facility set
and IBC value. Each historic, current and future triple receives a name
composed of the machine type and its general availability counter. This name
forms the cpu model name (e.g.: "2817-GA2".)

With means of the Instruction Blocking Control feature (IBC), the instruction
set available to a given guest is limitable.

Michael Mueller (10):
  QEMU: introduce function cpudesc_avail
  QEMU: s390: cpu model cpu class definition
  QEMU: s390: cpu model facilities support
  QEMU: s390: cpu model alias support
  s390: update linux-headers for kvm VM device attributes
  QEMU: s390: cpu model kvm VM attr interface routines
  QEMU: s390: cpu model class initialization
  QEMU: s390: cpu model QMP query-cpu-definitions
  QEMU: s390: cpu model QMP query-cpu-model
  QEMU: s390: cpu model enablement

 arch_init.c                  |   8 +
 hw/s390x/s390-virtio-ccw.c   |   2 +
 hw/s390x/s390-virtio.c       | 104 ++++++++
 hw/s390x/s390-virtio.h       |   1 +
 include/sysemu/arch_init.h   |   2 +
 linux-headers/asm-s390/kvm.h |  26 ++
 linux-headers/linux/kvm.h    |   1 +
 qapi-schema.json             |  23 ++
 qmp-commands.hx              |   6 +
 qmp.c                        |   5 +
 stubs/Makefile.objs          |   1 +
 stubs/arch-query-cpu-mod.c   |   9 +
 target-s390x/Makefile.objs   |   1 +
 target-s390x/cpu-models.c    | 586 +++++++++++++++++++++++++++++++++++++++++++
 target-s390x/cpu-models.h    | 362 ++++++++++++++++++++++++++
 target-s390x/cpu-qom.h       |  22 ++
 target-s390x/cpu.c           | 171 ++++++++++++-
 target-s390x/cpu.h           |   3 +
 target-s390x/kvm.c           |  66 +++++
 vl.c                         |   2 +-
 20 files changed, 1395 insertions(+), 6 deletions(-)
 create mode 100644 stubs/arch-query-cpu-mod.c
 create mode 100644 target-s390x/cpu-models.c
 create mode 100644 target-s390x/cpu-models.h

-- 
1.8.3.1

