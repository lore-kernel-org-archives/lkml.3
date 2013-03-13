Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446Ab3CMXgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:36:51 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:45360 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933435Ab3CMXgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:36:49 -0400
Date: Wed, 13 Mar 2013 16:36:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Udo van den Heuvel <udovdh@xs4all.nl>
cc: Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.6.11: khubd issue SLAB related?
In-Reply-To: <5140A7F2.5080203@xs4all.nl>
Message-ID: <alpine.DEB.2.02.1303131633320.25372@chino.kir.corp.google.com>
References: <5139E36A.5000109@xs4all.nl> <alpine.DEB.2.02.1303111410470.4160@chino.kir.corp.google.com> <5140A7F2.5080203@xs4all.nl>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013, Udo van den Heuvel wrote:

> > If not, enable it and try again, or get root and manually try to 
> > defragment memory by doing echo 1 > /proc/sys/vm/compact_memory.
> 
> This needs to be done regularly, I assume?
> 

It's done when the page allocation initially fails, so it shouldn't need 
to be done explicitly by you.  I was hoping to see if that helped to solve 
the problem and something like deferred compaction wasn't involved.

> > If so, try killing a memory hogging process to free some memory and 
> > attempt to get some higher order pages available.
> 
> It's a 8GB box (7.5GB available to software) with modest load. Mostly
> email & web browsing, some torrents, nntp stuff, etc. Nothing weird.
> Around 4.8G in buffers/cache right now.
> 

That may be true, but you only have about 300MB available at the time of 
failure.

> Why is this issue occurring?
> Why did I not see this in the past?
> 

I already added Hans to the cc to see if the struct has grown recently.
