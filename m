Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaAPQYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:24:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaAPQYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:24:42 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, riel@redhat.com, aarcange@redhat.com,
        aquini@redhat.com, mst@redhat.com, rusty@rustcorp.com.au,
        vdavydov@parallels.com, amit.shah@redhat.com, dfediuck@redhat.com,
        agl@us.ibm.com
Subject: [RFC PATCH 0/4] virtio_balloon: add pressure notification via a new virtqueue
Date: Thu, 16 Jan 2014 11:24:01 -0500
Message-Id: <1389889445-3855-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pressure notification added to the virtio-balloon driver by this series
is going to be used by the host (QEMU, in this case) to implement automatic
balloning support. More details in patch 3/4 and patch 4/4.

Patch 1/4 adds in-kernel vmpressure support and is not really part of this
series, it's added here for the convenience of someone who wants to try
automatic ballooning. Patch 2/4 is a hack to make in-kernel vmpressure work
for something not related to cgroups, I'll improve it in later versions.

Glauber Costa (1):
  vmpressure: in-kernel notifications

Luiz capitulino (3):
  vmpressure in-kernel: hack
  virtio_balloon: add pressure notification via a new virtqueue
  virtio_balloon: skip inflation if guest is under pressure

 drivers/virtio/virtio_balloon.c     | 100 ++++++++++++++++++++++++++++++++----
 include/linux/vmpressure.h          |   6 +++
 include/uapi/linux/virtio_balloon.h |   1 +
 mm/vmpressure.c                     |  58 +++++++++++++++++++--
 4 files changed, 151 insertions(+), 14 deletions(-)

-- 
1.8.1.4
