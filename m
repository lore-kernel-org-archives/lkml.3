Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaAOA6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:58:14 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:63899 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaAOA6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:58:11 -0500
Date: Tue, 14 Jan 2014 16:58:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nathan Zimmer <nzimmer@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Hedi <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] hotplug, memory: move register_memory_resource out of the
 lock_memory_hotplug
In-Reply-To: <1389723874-32372-1-git-send-email-nzimmer@sgi.com>
Message-ID: <alpine.DEB.2.02.1401141656030.3375@chino.kir.corp.google.com>
References: <1389723874-32372-1-git-send-email-nzimmer@sgi.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Nathan Zimmer wrote:

> We don't need to do register_memory_resource() since it has its own lock and
> doesn't make any callbacks.
> 

We need to do it, just not under lock_memory_hotplug() :).

> Also register_memory_resource return NULL on failure so we don't have anything
> to cleanup at this point.
> 
> 
> The reason for this rfc is I was doing some experiments with hotplugging of
> memory on some of our larger systems.  While it seems to work, it can be quite
> slow.  With some preliminary digging I found that lock_memory_hotplug is
> clearly ripe for breakup.
> 
> It could be broken up per nid or something but it also covers the
> online_page_callback.  The online_page_callback shouldn't be very hard to break
> out.
> 
> Also there is the issue of various structures(wmarks come to mind) that are
> only updated under the lock_memory_hotplug that would need to be dealt with.
> 
> 
> cc: Andrew Morton <akpm@linux-foundation.org>
> cc: Tang Chen <tangchen@cn.fujitsu.com>
> cc: Wen Congyang <wency@cn.fujitsu.com>
> cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> cc: Hedi <hedi@sgi.com>
> cc: Mike Travis <travis@sgi.com>
> cc: linux-mm@kvack.org
> cc: linux-kernel@vger.kernel.org

Looks like you're modifying a pre-3.12 kernel version that doesn't have 
27356f54c8c3 ("mm/hotplug: verify hotplug memory range").

When your patch is signed off, feel free to add

Acked-by: David Rientjes <rientjes@google.com>
