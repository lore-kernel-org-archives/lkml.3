Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaAOBFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:05:50 -0500
Received: from mail-gg0-f177.google.com ([209.85.161.177]:48460 "EHLO
	mail-gg0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOBFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:05:47 -0500
Date: Tue, 14 Jan 2014 17:05:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nathan Zimmer <nzimmer@sgi.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Hedi <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] hotplug, memory: move register_memory_resource out of the
 lock_memory_hotplug
In-Reply-To: <20140114151340.004d25c00056d88f33cadda0@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1401141702450.3375@chino.kir.corp.google.com>
References: <1389723874-32372-1-git-send-email-nzimmer@sgi.com> <20140114151340.004d25c00056d88f33cadda0@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Andrew Morton wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm/memory_hotplug.c: register_memory_resource() fixes
> 
> - register_memory_resource() should not go BUG on ENOMEM.  That's
>   appropriate at system boot time, but not at memory-hotplug time.  Fix.
> 
> - register_memory_resource()'s caller is incorrectly replacing
>   request_resource()'s -EBUSY with -EEXIST.  Fix this by propagating
>   errors appropriately.
> 

Unfortunately, -EEXIST is a special case return value for both 
acpi_memory_enable_device() and hv_mem_hot_add(), so they would need to be 
modified to agree concurrently with this change.
