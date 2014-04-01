Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaDAOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:16:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaDAOPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:15:37 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        hadi@mojatatu.com, davem@davemloft.net
Subject: [PATCH 0/3] netlink: per-protocol bind fixup/enhancement set
Date: Tue,  1 Apr 2014 10:14:55 -0400
Message-Id: <cover.1396317747.git.rgb@redhat.com>
In-Reply-To: <20140324183406.GE28666@madcap2.tricolour.ca>
References: <20140324183406.GE28666@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set provides a way for per-protocol bind functions to signal an error and
to be able to clean up after themselves.

The first patch has already been accepted, but is included just in case to
avoid a merge error.

The second patch adds the per-protocol bind return code to signal to the
netlink code that no further processing should be done and to undo the work
already done.  This rev has fixed DaveM's last issue and flattened the
intentation as requested by Patrick McHardy by two by reworking the logic.

The third provides a way per protocol to undo actions on DROP.

Thanks for the feedback.

Richard Guy Briggs (3):
  netlink: simplify nfnetlink_bind
  netlink: have netlink per-protocol bind function return an error code.
  netlink: implement unbind to netlink_setsockopt NETLINK_DROP_MEMBERSHIP

 include/linux/netlink.h   |    3 ++-
 net/netfilter/nfnetlink.c |   10 ++++------
 net/netlink/af_netlink.c  |   44 +++++++++++++++++++++++++++++++-------------
 net/netlink/af_netlink.h  |    6 ++++--
 4 files changed, 41 insertions(+), 22 deletions(-)

