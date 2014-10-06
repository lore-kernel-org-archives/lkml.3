Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaJFOa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 10:30:57 -0400
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:54087 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaJFOaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 10:30:55 -0400
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, ebiederm@xmission.com, akpm@linux-foundation.org,
        adobriyan@gmail.com, rui.xiang@huawei.com, viro@zeniv.linux.org.uk,
        oleg@redhat.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com,
        grant.likely@secretlab.ca, tytso@mit.edu
Subject: [PATCH linux v2 0/1] Optimize network interfaces creation
Date: Mon,  6 Oct 2014 16:30:33 +0200
Message-Id: <1412605834-4417-1-git-send-email-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <542EA009.4060009@6wind.com>
References: <542EA009.4060009@6wind.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a lot of netdevices are created, one of the bottleneck is the creation
of proc entries. This serie aims to accelerate this part.

I'm not sure against which tree this patch should be done. I've done it against
linux.git.

RFCv1 -> v2
 - use a red-black tree instead of a hash list

 fs/proc/generic.c  | 164 ++++++++++++++++++++++++++++++++++-------------------
 fs/proc/internal.h |  11 ++--
 fs/proc/proc_net.c |   1 +
 fs/proc/root.c     |   1 +
 4 files changed, 113 insertions(+), 64 deletions(-)

Comments are welcome.

Regards,
Nicolas
