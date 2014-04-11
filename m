Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbaDKWN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:13:59 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:62880 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbaDKWN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:13:58 -0400
Date: Fri, 11 Apr 2014 15:13:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave.hansen@intel.com>
cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, drepper@gmail.com,
        anatol.pomozov@gmail.com, jkosina@suse.cz, akpm@linux-foundation.org,
        xemul@parallels.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] drivers/base/node.c: export physical address range of
 given node (Re: NUMA node information for pages)
In-Reply-To: <53481724.8020304@intel.com>
Message-ID: <alpine.DEB.2.02.1404111513040.17724@chino.kir.corp.google.com>
References: <87eh1ix7g0.fsf@x240.local.i-did-not-set--mail-host-address--so-tickle-me> <533a1563.ad318c0a.6a93.182bSMTPIN_ADDED_BROKEN@mx.google.com> <CAOPLpQc8R2SfTB+=BsMa09tcQ-iBNJHg+tGnPK-9EDH1M47MJw@mail.gmail.com> <5343806c.100cc30a.0461.ffffc401SMTPIN_ADDED_BROKEN@mx.google.com>
 <alpine.DEB.2.02.1404091734060.1857@chino.kir.corp.google.com> <5345fe27.82dab40a.0831.0af9SMTPIN_ADDED_BROKEN@mx.google.com> <alpine.DEB.2.02.1404101500280.11995@chino.kir.corp.google.com> <53474709.e59ec20a.3bd5.3b91SMTPIN_ADDED_BROKEN@mx.google.com>
 <alpine.DEB.2.02.1404110325210.30610@chino.kir.corp.google.com> <53481724.8020304@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2014, Dave Hansen wrote:

> > So?  Who cares if there are non-addressable holes in part of the span?  
> > Ulrich, correct me if I'm wrong, but it seems you're looking for just a 
> > address-to-nodeid mapping (or pfn-to-nodeid mapping) and aren't actually 
> > expecting that there are no holes in a node for things like acpi or I/O or 
> > reserved memory.
> ...
> > I think trying to represent holes and handling different memory models and 
> > hotplug in special ways is complete overkill.
> 
> This isn't just about memory hotplug or different memory models.  There
> are systems out there today, in production, that have layouts like this:
> 
> |------Node0-----|
>      |------Node1-----|
> 
> and this:
> 
> |------Node0-----|
>      |-Node1-|
> 

What additional information, in your opinion, can we export to assist 
userspace in making this determination that $address is on $nid?
