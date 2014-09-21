Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaIUR4a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 13:56:30 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:9935 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636AbaIUR42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 13:56:28 -0400
X-IronPort-AV: E=Sophos;i="5.04,566,1406584800"; 
   d="scan'208";a="96998147"
Message-ID: <541F1149.5060208@gmail.com>
Date: Sun, 21 Sep 2014 19:56:25 +0200
From: Brice Goglin <brice.goglin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org
CC: dave.hansen@linux.intel.com, a.p.zijlstra@chello.nl, mingo@kernel.org,
        hpa@linux.intel.com, bp@alien8.de
Subject: Re: [PATCH] x86: new topology for multi-NUMA-node CPUs
References: <20140918193334.C065EBCE@viggo.jf.intel.com>
In-Reply-To: <20140918193334.C065EBCE@viggo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 18/09/2014 21:33, Dave Hansen a écrit :
> After this set, there are only 2 sets of core siblings, which
> is what we expect for a 2-socket system.
>
> # cat cpu*/topology/physical_package_id | sort | uniq -c
>      18 0
>      18 1
> # cat cpu*/topology/core_siblings_list | sort | uniq -c
>      18 0-17
>      18 18-35
>

Thanks a lot for working on this. I can't comment on the code but at
least the above core_siblings values should fix the original problem
observed with hwloc. I don't have a E5 v3 to test but installing the
hwloc package and running lstopo should confirm that it now sees a
single socket per group of 2 NUMA nodes as expected.

Brice

