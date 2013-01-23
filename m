Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3AWHTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 02:19:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38812 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab3AWHTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 02:19:36 -0500
X-IronPort-AV: E=Sophos;i="4.84,521,1355068800"; 
   d="scan'208";a="6634045"
From: Hu Tao <hutao@cn.fujitsu.com>
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Subject: [PATCH v12 rebased 0/8] pv event to notify host when the guest is panicked
Date: Wed, 23 Jan 2013 15:19:20 +0800
Message-Id: <cover.1358920534.git.hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1.240.ge8a1f5a
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/23 15:18:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/23 15:18:34,
	Serialize complete at 2013/01/23 15:18:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements a new interface, kvm pv event, to notify host when
some events happen in guest. Right now there is one supported event: guest
panic.

Also, the cpu runstate is preserved during save/load vm and migration. Thus,
if vm is panicked during migration, we can still know it by quring the status
of vm in destination host.

This version is a rebase and no code change.

v12: http://lists.gnu.org/archive/html/qemu-devel/2012-12/msg01459.html
v11: http://lists.gnu.org/archive/html/qemu-devel/2012-10/msg04361.html

Hu Tao (7):
  save/load cpu runstate
  update kernel headers
  add a new runstate: RUN_STATE_GUEST_PANICKED
  add a new qevent: QEVENT_GUEST_PANICKED
  introduce a new qom device to deal with panicked event
  allower the user to disable pv event support
  pv event: add document to describe the usage

Wen Congyang (1):
  start vm after resetting it

 docs/pv-event.txt                |  17 ++++
 hw/kvm/Makefile.objs             |   2 +-
 hw/kvm/pv_event.c                | 197 +++++++++++++++++++++++++++++++++++++++
 hw/pc_piix.c                     |  12 +++
 include/block/block.h            |   2 +
 include/monitor/monitor.h        |   1 +
 include/sysemu/kvm.h             |   2 +
 include/sysemu/sysemu.h          |   2 +
 kvm-stub.c                       |   4 +
 linux-headers/asm-x86/kvm_para.h |   1 +
 linux-headers/linux/kvm_para.h   |   6 ++
 migration.c                      |   7 +-
 monitor.c                        |   6 +-
 qapi-schema.json                 |   6 +-
 qemu-options.hx                  |   3 +-
 qmp.c                            |   5 +-
 savevm.c                         |   1 +
 vl.c                             |  56 ++++++++++-
 18 files changed, 313 insertions(+), 17 deletions(-)
 create mode 100644 docs/pv-event.txt
 create mode 100644 hw/kvm/pv_event.c

-- 
1.8.0.1.240.ge8a1f5a

