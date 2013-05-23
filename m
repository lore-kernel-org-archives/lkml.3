Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab3EWDWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 23:22:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306Ab3EWDWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 23:22:45 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [net-next RFC 0/8] multiqueue API support for macvtap
Date: Thu, 23 May 2013 11:12:25 +0800
Message-Id: <1369278753-2533-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

This series implements a fully tuntap compatiable API which could be used by
userspace to manage multi macvtap queues. The main parts is to add TUNSETQUEUE
ioctl support for macvtap.

Patch 1 - 4 was some tuntap compatibility and misc cleanups.
Patch 5 removes the linear search in macvtap by reshuffling the macvtaps array
each time a queue is removed. After this, we could store both enabled and
disabled queues in the same array without introducing extra data structure.
Patch 6 let TUNSETIFF can create multiqueue device, nothing but some check were
added.
Patch 7 implement TUNSETQUEUE ioctl
Patch 8 reports IFF_MULTI_QUEUE to userspace to notify the userspace that the
multiqueue API is completed.

Flow caches implememtation were missed in this version, since I am doing rework
on the tuntap flow caches. Have some some stress test with both netperf and
pktgen.

Please review, thanks.

Jason Wang (8):
  macvlan: switch to use IS_ENABLED()
  macvtap: return -EBADFD when TUNGETIFF fails
  macvtap: introduce macvtap_get_vlan()
  macvlan: reduce the max number of taps to 8
  macvtap: eliminate linear search
  macvtap: allow TUNSETIFF to create multiqueue device
  macvtap: add TUNSETQUEUE ioctl
  macvtap: enable multiqueue flag

 drivers/net/macvtap.c      |  265 ++++++++++++++++++++++++++++++-------------
 include/linux/if_macvlan.h |   11 ++-
 2 files changed, 194 insertions(+), 82 deletions(-)

