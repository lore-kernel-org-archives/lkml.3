Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbaDVKRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:17:54 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:64998 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaDVKRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:17:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140422094759.GC29311@dhcp22.suse.cz>
References: <1397861935-31595-1-git-send-email-nasa4836@gmail.com> <20140422094759.GC29311@dhcp22.suse.cz>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 22 Apr 2014 18:17:09 +0800
Message-ID: <CAHz2CGWrk3kuR=BLt2vT-8gxJVtJcj6h17ase9=1CoWXwK6a3w@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/memcontrol.c: remove meaningless while loop in mem_cgroup_iter()
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>,
        kamezawa.hiroyu@jp.fujitsu.com, Cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 5:47 PM, Michal Hocko <mhocko@suse.cz> wrote:
> What about
>   3. last_visited == last_node in the tree
>
> __mem_cgroup_iter_next returns NULL and the iterator would return
> without visiting anything.

Hi,  Michal,

yep,  if 3 last_visited == last_node, then this means we have done a round-trip,
thus __mem_cgroup_iter_next returns NULL, in turn mem_cgroup_iter() return NULL.

This is what comments above mem_cgroup_iter() says:

>Returns references to children of the hierarchy below @root, or
>* @root itself, or %NULL after a full round-trip.

Actually, this condition could be reduced to conditon 2.1

Thanks,
Jianyu Zhan
