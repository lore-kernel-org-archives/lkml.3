Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaFJLe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:34:58 -0400
Received: from mail.siteground.com ([67.19.240.234]:52180 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaFJLe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:34:57 -0400
Message-ID: <5396ED66.7090401@1h.com>
Date: Tue, 10 Jun 2014 14:35:02 +0300
From: Marian Marinov <mm@1h.com>
Organization: 1H Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC] oom, memcg: handle sysctl oom_kill_allocating_task while memcg
 oom happening
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.siteground.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 1h.com
X-Get-Message-Sender-Via: mail.siteground.com: none
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,
a while back in 2012 there was a request for this functionality.
  oom, memcg: handle sysctl oom_kill_allocating_task while memcg oom happening

This is the thread:  https://lkml.org/lkml/2012/10/16/168

Now we run a several machines with around 10k processes on each machine, using containers.

Regularly we see OOM from within a container that causes performance degradation.

We are running 3.12.20 with the following OOM configuration and memcg oom enabled:

vm.oom_dump_tasks = 0
vm.oom_kill_allocating_task = 1
vm.panic_on_oom = 0

When OOM occurs we see very high numbers for the loadavg and the overall responsiveness of the machine degrades.

During these OOM states the load of the machine gradualy increases from 25 up to 120 in the interval of 10minutes.

Once we manually bring down the memory usage of a container(killing some tasks) the load drops down to 25 within 5 to
7 minutes.

I read the whole thread from 2012 but I do not see the expected behavior that is described by the people that
commented the issue.

In this case, with real usage for this patch, would it be considered for inclusion?

Marian


- -- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman@jabber.org
ICQ: 7556201
Mobile: +359 886 660 270
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlOW7WYACgkQ4mt9JeIbjJTZCACgj74t6T9GkCS5RlQEF6NkTbed
xJwAoK93irH+FneDoNdSi2DBSnR7a76r
=zl6k
-----END PGP SIGNATURE-----
