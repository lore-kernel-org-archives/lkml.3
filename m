Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab3EAWms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:42:48 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48966 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217Ab3EAWmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:42:45 -0400
Date: Wed, 1 May 2013 15:42:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cody P Schafer <cody@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] mmzone: note that node_size_lock should be manipulated
 via pgdat_resize_lock()
In-Reply-To: <51819900.1010301@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1305011541260.8804@chino.kir.corp.google.com>
References: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com> <1367446635-12856-4-git-send-email-cody@linux.vnet.ibm.com> <alpine.DEB.2.02.1305011528550.8804@chino.kir.corp.google.com> <51819900.1010301@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Cody P Schafer wrote:

> > > Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> > 
> > Nack, pgdat_resize_unlock() is unnecessary if irqs are known to be
> > disabled.
> > 
> 
> All this patch does is is indicate that rather than using node_size_lock
> directly (as it won't be around without CONFIG_MEMORY_HOTPLUG), one should use
> the pgdat_resize_[un]lock() helper macros.
> 

I think that's obvious given the lock is surrounded by
#ifdef CONFIG_MEMORY_HOTPLUG.  The fact remains that hotplug code need not 
use pgdat_resize_lock() if irqs are disabled.
