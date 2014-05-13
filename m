Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbaEMO65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:58:57 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:50149 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964990AbaEMO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:58:51 -0400
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
Subject: [PATCH v1 RFC 0/6] KVM: s390: cpu model implementation
Date: Tue, 13 May 2014 16:58:28 +0200
Message-Id: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051314-6892-0000-0000-000008C5C88D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The proposed patch set implements S390 cpu model support in kvm. A cpu
model is defined by a triple comprizing the cpu type , the cpu facility
set and instruction blocking control. A consumer requests a feasible
combination of that that triple before vcpu creation. All subsequently
created vcpu's will use this cpu configuration. 

Michael Mueller (6):
  s390/sclp: add sclp_get_ibc function
  KVM: s390: split SIE state guest prefix field
  KVM: s390: use facilities and cpu_id per KVM
  KVM: s390: add ibc api
  KVM: s390: initial implementation of soft facilities
  KVM: s390: add cpu model support

 arch/s390/include/asm/kvm_host.h |  13 +-
 arch/s390/include/asm/sclp.h     |   1 +
 arch/s390/include/uapi/asm/kvm.h |  23 ++++
 arch/s390/kvm/Makefile           |   2 +-
 arch/s390/kvm/diag.c             |   2 +-
 arch/s390/kvm/gaccess.c          |   4 +-
 arch/s390/kvm/gaccess.h          |   8 +-
 arch/s390/kvm/ibc.c              |  29 +++++
 arch/s390/kvm/kvm-s390.c         | 263 +++++++++++++++++++++++++++++++++------
 arch/s390/kvm/kvm-s390.h         |  43 ++++++-
 arch/s390/kvm/priv.c             |  16 ++-
 arch/s390/kvm/softfac.c          |  38 ++++++
 drivers/s390/char/sclp_early.c   |  12 +-
 13 files changed, 397 insertions(+), 57 deletions(-)
 create mode 100644 arch/s390/kvm/ibc.c
 create mode 100644 arch/s390/kvm/softfac.c

-- 
1.8.3.1

