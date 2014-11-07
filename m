Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaKGSt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:49:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbaKGSt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:49:57 -0500
Message-ID: <545D1435.90505@redhat.com>
Date: Fri, 07 Nov 2014 13:49:25 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>, peterz@infradead.org,
        mingo@redhat.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: core: fix out of bounds read in sched_init_numa()
References: <1415372020-1871-1-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1415372020-1871-1-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/07/2014 09:53 AM, Andrey Ryabinin wrote:

> Zero 'level' (e.g. on non-NUMA system) causing out of bounds
> access in this line:
> 
> sched_max_numa_distance = sched_domains_numa_distance[level - 1];
> 
> Fix this by exiting from sched_init_numa() earlier.
> 
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com> Fixes:
> 9942f79ba ("sched/numa: Export info needed for NUMA balancing on
> complex topologies")

Reviewed-by: Rik van Riel <riel@redhat.com>

> Another option would be to not call sched_init_numa() if
> nr_node_ids == 1, but I'm not sure that there is no such
> configuration where nr_node_ids > 1 and node_distance(i, j) =
> node_distance(0, 0) for any i and j.

When there is only one node, the distance from the node to itself
will always be equal to node_distance(0, 0)

I am somewhat surprised we go through all of sched_init_numa on
a non-numa system, though :)

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUXRQ1AAoJEM553pKExN6D+h4H/jWfrFnEJFJMIrZU/nK5EcHg
CiUGVJH2f4jL6qCSRIIduxyyu9qggsQ5Qp7Ci5bfGm98Sj89DNnXUv4sarPWT3zA
KIDM+BuKFjKSXfCjcwrCkBP6x8gIYgCLR3hSThmq/MPrbNULy+1SUslb77i3kmBK
OhLrjSC0SQty5yvGkCfWYGGh7rRboRcfVyckvODRRdhwHtBP1p/seDNWHadAeX+d
WRNqdqJkvwwJ+eW9e7e009+OqB2EmS9xKBjXGIc7zEehfgOaeROQZ8sL7exs2g3n
6gtnWpn4firR15BSaHdK8kaEmsReWUZdrIebNVsUDmErN97O/AJ9UygJ5wUenzQ=
=YPeU
-----END PGP SIGNATURE-----
