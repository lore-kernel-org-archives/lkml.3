Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaJBPZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:25:43 -0400
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:57575 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbaJBPZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:25:39 -0400
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, ebiederm@xmission.com, akpm@linux-foundation.org,
        adobriyan@gmail.com, rui.xiang@huawei.com, viro@zeniv.linux.org.uk,
        oleg@redhat.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com,
        grant.likely@secretlab.ca, tytso@mit.edu
Subject: [RFC PATCH linux 0/2] Optimize network interfaces creation
Date: Thu,  2 Oct 2014 17:24:59 +0200
Message-Id: <1412263501-6572-1-git-send-email-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20131003.150947.2179820478039260398.davem@davemloft.net>
References: <20131003.150947.2179820478039260398.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a lot of netdevices are created, one of the bottleneck is the creation
of proc entries. This serie aims to accelerate this part.

The first patch only prepares the second one.

I'm not sure against which tree this patch should be done. I've done it against
linux.git.

 fs/proc/generic.c  | 100 +++++++++++++++++++++++++++++++++++++++++------------
 fs/proc/internal.h |  49 +++++++++++++++++++++++---
 fs/proc/proc_net.c |   8 +++++
 fs/proc/root.c     |   5 +++
 4 files changed, 135 insertions(+), 27 deletions(-)

Comments are welcome.

Regards,
Nicolas
