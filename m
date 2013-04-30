Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286Ab3D3Qy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:54:27 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62079 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761057Ab3D3QyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:54:21 -0400
Date: Tue, 30 Apr 2013 09:54:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: =?UTF-8?Q?Vincent_Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory hotplug: fix warnings
In-Reply-To: <20130430092919.a9ab7108.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1304300952210.31619@chino.kir.corp.google.com>
References: <1367310697-6332-1-git-send-email-vincent.stehle@laposte.net> <alpine.DEB.2.02.1304300916500.10368@chino.kir.corp.google.com> <20130430092919.a9ab7108.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Andrew Morton wrote:

> > > diff --git a/include/linux/memory.h b/include/linux/memory.h
> > > index 73817af..85c31a8 100644
> > > --- a/include/linux/memory.h
> > > +++ b/include/linux/memory.h
> > > @@ -137,7 +137,7 @@ enum mem_add_context { BOOT, HOTPLUG };
> > >  #define register_hotmemory_notifier(nb)		register_memory_notifier(nb)
> > >  #define unregister_hotmemory_notifier(nb) 	unregister_memory_notifier(nb)
> > >  #else
> > > -#define hotplug_memory_notifier(fn, pri)	(0)
> > > +#define hotplug_memory_notifier(fn, pri)	({ 0; })
> > >  /* These aren't inline functions due to a GCC bug. */
> > >  #define register_hotmemory_notifier(nb)    ({ (void)(nb); 0; })
> > >  #define unregister_hotmemory_notifier(nb)  ({ (void)(nb); })
> > 
> > You can't use the standard do {} while (0)?
> 
> register_memory_notifier() (and hence hotplug_memory_notifier())
> returns an errno.  Which nobody bothers checking.
> 

The notifier itself is statically allocated so there's no memory 
allocations in this path, there's no chance it'll fail.  Should we just 
make register_memory_notifier() return void?
