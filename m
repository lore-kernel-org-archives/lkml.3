Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab3ALDH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 22:07:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab3ALDH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 22:07:56 -0500
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: edumazet@google.com, stefanha@redhat.com, Jason Wang <jasowang@redhat.com>
Subject: [PATCH V2 0/3] some fixes of tuntap
Date: Sat, 12 Jan 2013 10:59:31 +0800
Message-Id: <1357959574-13113-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

There series fixes two issues:
- Don't allow calling TUNSETIFF when a file is detached which may cause kernel
data structure corrupt.
- Fix the reference count leaking of sock and module.

Plus a suggestion from Eric to use rtnl_dereference() instead of the open code.

Changes from v1:
- don't use rcu to dereference tfile->detached as it was already protected by
rtnl lock.
- add a patch of switching to use rtnl_dereference().

Jason Wang (3):
  tuntap: switch to use rtnl_dereference()
  tuntap: forbid calling TUNSETIFF when detached
  tuntap: fix leaking reference count

 drivers/net/tun.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

