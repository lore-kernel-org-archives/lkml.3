Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaJGJCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:02:47 -0400
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:54736 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaJGJCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:02:45 -0400
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, ebiederm@xmission.com, akpm@linux-foundation.org,
        adobriyan@gmail.com, rui.xiang@huawei.com, viro@zeniv.linux.org.uk,
        oleg@redhat.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com,
        grant.likely@secretlab.ca, tytso@mit.edu
Subject: [PATCH linux v3 0/1] Optimize network interfaces creation
Date: Tue,  7 Oct 2014 11:02:38 +0200
Message-Id: <1412672559-5256-1-git-send-email-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20141006.181448.1696747135961247651.davem@davemloft.net>
References: <20141006.181448.1696747135961247651.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a lot of netdevices are created, one of the bottleneck is the creation
of proc entries. This serie aims to accelerate this part.

I'm not sure against which tree this patch should be done. I've done it against
linux.git.

v2 -> v3
 - restore credit to Thierry Herbelot for the initial idea.

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
