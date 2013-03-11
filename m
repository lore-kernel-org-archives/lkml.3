Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab3CKVXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:23:33 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:62687 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab3CKVXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:23:31 -0400
Date: Mon, 11 Mar 2013 14:23:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Udo van den Heuvel <udovdh@xs4all.nl>
cc: Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.6.11: khubd issue SLAB related?
In-Reply-To: <5139E36A.5000109@xs4all.nl>
Message-ID: <alpine.DEB.2.02.1303111410470.4160@chino.kir.corp.google.com>
References: <5139E36A.5000109@xs4all.nl>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Mar 2013, Udo van den Heuvel wrote:

> [3663200.799579] SLAB: Unable to allocate memory on node 0 (gfp=0xd0)
> [3663200.799581]   cache: size-65536, object size: 65536, order: 4
> [3663200.799583]   node 0: slabs: 6/6, objs: 6/6, free: 0
> [3663200.799585] pwc: Oops, could not allocate memory for pwc_device.

You have memory freed, but like your earlier page allocation failure on 
mount, it is too fragmented.  This is an order-4 page allocation, the 
kmalloc() of struct pwc_device, and you don't even have any order-3 pages 
that are available.  Are you running with CONFIG_COMPACTION enabled?

If not, enable it and try again, or get root and manually try to 
defragment memory by doing echo 1 > /proc/sys/vm/compact_memory.

If so, try killing a memory hogging process to free some memory and 
attempt to get some higher order pages available.
