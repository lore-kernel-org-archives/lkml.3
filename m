Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3LCTMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:12:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52232 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3LCTMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:12:30 -0500
Message-ID: <529E2D14.9000303@canonical.com>
Date: Tue, 03 Dec 2013 14:12:20 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: zhiguohong@tencent.com
CC: "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [Regression][3.12] bridge: fix NULL pointer deref of br_port_get_rcu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hong,

A kernel bug was opened against Ubuntu [0].  After a kernel bisect, it
was found that reverting the following commit resolved
this bug:

commit 716ec052d2280d511e10e90ad54a86f5b5d4dcc2
Author: Hong Zhiguo <zhiguohong@tencent.com>
Date:   Sat Sep 14 22:42:28 2013 +0800

    bridge: fix NULL pointer deref of br_port_get_rcu


The regression was introduced as of v3.12-rc2 and has made it into some
of the stable trees(3.10 and 3.11).

I was thinking of requesting a revert for this commit, but I wanted to
get your feedback first, since you are the patch author.


Thanks,

Joe


[0] http://pad.lv/1249880
