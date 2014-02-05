Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaBETZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 14:25:39 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54964 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaBETZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:25:38 -0500
Date: Wed, 5 Feb 2014 11:25:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fengguang Wu <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [slub] WARNING: CPU: 1 PID: 1 at mm/slub.c:992
 deactivate_slab()
In-Reply-To: <20140205112449.GB18849@localhost>
Message-ID: <alpine.DEB.2.02.1402051123520.5616@chino.kir.corp.google.com>
References: <20140205072558.GC9379@localhost> <alpine.DEB.2.02.1402050009200.7839@chino.kir.corp.google.com> <20140205112449.GB18849@localhost>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Fengguang Wu wrote:

> > I think this is the inlined add_full() and should be fixed with 
> > http://marc.info/?l=linux-kernel&m=139147105027693 that has been added to 
> > the -mm tree and should now be in next.  Is this patch included for this 
> > kernel?
> 
> Hi David,
> 
> According to the bisect log, linux-next 20140204 is bad, but it does
> not yet include your fix.
> 
> git bisect  bad 38dbfb59d1175ef458d006556061adeaa8751b72  # 23:16      0-      2  Linus 3.14-rc1
> git bisect  bad cdd263faccc2184e685573968dae5dd34758e322  # 23:34      1-      3  Add linux-next specific files for 20140204
> 

Ah, that's because the patch didn't go through Pekka's slab tree but went 
into -mm instead so we have to wait for another -mm.  However, the traces 
from linux-next-20140204 that you provided indicate it's the same problem 
and should be fixed with that patch, so let's wait for another mmotm to be 
released.
