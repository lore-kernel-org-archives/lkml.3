Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaKFRVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:21:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbaKFRVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:21:35 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Drivers: hv: kvp,vss: improve kernel-userspace communication in failure case
Date: Thu,  6 Nov 2014 18:21:23 +0100
Message-Id: <1415294485-23945-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series addresses two issues:
- There is no timeout when communicating with userspace VSS daemon.
- In case we fail to send a message to VSS or KVP userspace daemons we
  can report the failure to the host right away avoiding the timeout.

Newly introduced 10 second timeout is something worth discussing. In theory freeze/thaw
ioctls should be fast. In case someone thinks 10 seconds is not enough we can easily
increase it as we cover the most common failure scenario (when the daemon was stopped)
with the second patch of this series.

Vitaly Kuznetsov (2):
  Drivers: hv: vss: Introduce timeout for communication with userspace
  Drivers: hv: kvp,vss: Fast propagation of userspace communication
    failure

 drivers/hv/hv_kvp.c      |  9 ++++++++-
 drivers/hv/hv_snapshot.c | 28 +++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 4 deletions(-)

-- 
1.9.3

