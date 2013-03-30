Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab3C3Tn0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 15:43:26 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:33069 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab3C3TnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 15:43:25 -0400
Subject: [GIT PULL] target fixes for v3.9-rc5
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Mar 2013 12:43:15 -0700
Message-ID: <1364672595.10253.161.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are two more target-pending fixes for v3.9-rc5 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This includes the bug-fix for a >= v3.8-rc1 regression specific to
iscsi-target persistent reservation conflict handling (CC'ed to stable),
and a tcm_vhost patch to drop VIRTIO_RING_F_EVENT_IDX usage so that
in-flight qemu vhost-scsi-pci device code can detect the proper vhost
feature bits.

Also, there are two more tcm_vhost patches still being discussed by MST
and Asias for v3.9 that will be required for the in-flight qemu
vhost-scsi-pci device patch to function properly, and that should
(hopefully) be the last target fixes for this round.

Thank you,

--nab

Nicholas Bellinger (2):
  tcm_vhost: Avoid VIRTIO_RING_F_EVENT_IDX feature bit
  target: Fix RESERVATION_CONFLICT status regression for iscsi-target
    special case

 drivers/target/target_core_transport.c |    4 +++-
 drivers/vhost/tcm_vhost.c              |   13 +++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

