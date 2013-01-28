Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3A1Dpv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:45:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab3A1Dpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:45:50 -0500
From: Richard Guy Briggs <rbriggs@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 0/6] audit: add restricted capability read-only netlink multicast socket
Date: Sun, 27 Jan 2013 22:45:12 -0500
Message-Id: <1359344718-3953-1-git-send-email-rbriggs@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

Hi,

This is a patch set Eric Paris and I have been working on to add a restricted
capability read-only netlink multicast socket to kaudit to enable 
userspace clients such as systemd to consume audit logs, in addition to the
bidirectional auditd userspace client.

Currently, auditd has the CAP_AUDIT_CONTROL and CAP_AUDIT_WRITE capabilities
(bot uses CAP_NET_ADMIN).  The CAP_AUDIT_READ capability will be added for use
by read-only AUDIT_NLGRP_READLOG multicast group clients to the kaudit
subsystem.

https://bugzilla.redhat.com/show_bug.cgi?id=887992

Feedback please!

Richard Guy Briggs (6):
  audit: refactor hold queue flush
  audit: flatten kauditd_thread wait queue code
  audit: move kaudit thread start from auditd registration to kaudit
    init
  netlink: add send and receive capability requirement and capability
    flags
  audit: add the first netlink multicast socket group
  audit: send multicast messages only if there are listeners

 include/linux/netlink.h             |   4 +
 include/uapi/linux/audit.h          |   8 ++
 include/uapi/linux/capability.h     |   5 +-
 kernel/audit.c                      | 142 +++++++++++++++++++++++++-----------
 net/netlink/af_netlink.c            |  35 +++++++--
 security/selinux/include/classmap.h |   2 +-
 6 files changed, 144 insertions(+), 52 deletions(-)

-- 
1.8.0.2

