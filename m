Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3LZPLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 10:11:33 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:57638 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab3LZPLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 10:11:31 -0500
Message-ID: <52BC4720.1070904@linaro.org>
Date: Thu, 26 Dec 2013 09:11:28 -0600
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sage Weil <sage@inktank.com>, David Miller <davem@davemloft.net>,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, Al Viro <viro@ZenIV.linux.org.uk>, jeffm@suse.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>, mst@redhat.com,
        Ingo Molnar <mingo@kernel.org>
CC: reiserfs-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 0/3] kernel.h: centrally define U32_MAX, etc.
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although types u32, s32, u16, s16 and so on are fundamental kernel
types, there is no central symbolic definition of their maximum and
minimum values.  In the past I've added and used such definitions
where I've needed them but they really belong in "kernel.h".

This series does this, in three steps.  The first makes existing
definitions be done conditionally; the second defines them in
"kernel.h"; and the third gets rid of the conditional definitions.

(These three can obviously be squashed into a single commit.)

    					-Alex

Alex Elder (3):
  conditionally define U32_MAX
  kernel.h: define u8, s8, u32, etc. limits
  remove extra definitions of U32_MAX

 fs/reiserfs/reiserfs.h      |    2 --
 include/linux/ceph/decode.h |   17 -----------------
 include/linux/kernel.h      |   13 +++++++++++++
 net/ipv4/tcp_illinois.c     |    1 -
 4 files changed, 13 insertions(+), 20 deletions(-)

-- 
1.7.9.5

