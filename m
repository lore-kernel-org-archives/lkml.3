Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab3D3Q3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:29:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3D3Q3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:29:41 -0400
Date: Tue, 30 Apr 2013 09:29:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Vincent =?ISO-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory hotplug: fix warnings
Message-Id: <20130430092919.a9ab7108.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1304300916500.10368@chino.kir.corp.google.com>
References: <1367310697-6332-1-git-send-email-vincent.stehle@laposte.net>
	<alpine.DEB.2.02.1304300916500.10368@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013 09:17:11 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Tue, 30 Apr 2013, Vincent Stehl__ wrote:
> 
> > diff --git a/include/linux/memory.h b/include/linux/memory.h
> > index 73817af..85c31a8 100644
> > --- a/include/linux/memory.h
> > +++ b/include/linux/memory.h
> > @@ -137,7 +137,7 @@ enum mem_add_context { BOOT, HOTPLUG };
> >  #define register_hotmemory_notifier(nb)		register_memory_notifier(nb)
> >  #define unregister_hotmemory_notifier(nb) 	unregister_memory_notifier(nb)
> >  #else
> > -#define hotplug_memory_notifier(fn, pri)	(0)
> > +#define hotplug_memory_notifier(fn, pri)	({ 0; })
> >  /* These aren't inline functions due to a GCC bug. */
> >  #define register_hotmemory_notifier(nb)    ({ (void)(nb); 0; })
> >  #define unregister_hotmemory_notifier(nb)  ({ (void)(nb); })
> 
> You can't use the standard do {} while (0)?

register_memory_notifier() (and hence hotplug_memory_notifier())
returns an errno.  Which nobody bothers checking.
