Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbaAUJwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:52:00 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:41170 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaAUJv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:51:57 -0500
Date: Tue, 21 Jan 2014 01:51:52 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
cc: akpm@linux-foundation.org, hannes@cmpxchg.org, liuj97@gmail.com,
        santosh.shilimkar@ti.com, grygorii.strashko@ti.com,
        iamjoonsoo.kim@lge.com, robin.m.holt@gmail.com,
        tangchen@cn.fujitsu.com, yinghai@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 1/3] mm/nobootmem: Fix unused variable
In-Reply-To: <20140121075738.771d29b3@lilie>
Message-ID: <alpine.DEB.2.02.1401210150220.29987@chino.kir.corp.google.com>
References: <1390217559-14691-1-git-send-email-phacht@linux.vnet.ibm.com> <1390217559-14691-2-git-send-email-phacht@linux.vnet.ibm.com> <alpine.DEB.2.02.1401202214540.21729@chino.kir.corp.google.com> <20140121075738.771d29b3@lilie>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014, Philipp Hachtmann wrote:

> > Not sure why you don't just do a one line patch:
> > 
> > -	phys_addr_t size;
> > +	phys_addr_t size __maybe_unused;
> > to fix it.
> 
> Just because I did not know that __maybe_unused thing.
> 

-	phys_addr_t size;
+	phys_addr_t size = 0;

would have done the same thing.

The compiler generated code isn't going to change with either of these, so 
we're only talking about how the source code is structured.  If you and 
Andrew believe that adding block scope to something so trivial then that's 
your taste.  Looks ugly to me.
