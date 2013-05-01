Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab3EAW0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:26:41 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:54894 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab3EAW0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:26:39 -0400
Date: Wed, 1 May 2013 15:26:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cody P Schafer <cody@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] mmzone: make holding lock_memory_hotplug() a
 requirement for updating pgdat size
In-Reply-To: <1367446635-12856-2-git-send-email-cody@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1305011525580.8804@chino.kir.corp.google.com>
References: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com> <1367446635-12856-2-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Cody P Schafer wrote:

> All updaters of pgdat size (spanned_pages, start_pfn, and
> present_pages) currently also hold lock_memory_hotplug() (in addition
> to pgdat_resize_lock()).
> 
> Document this and make holding of that lock a requirement on the update
> side for now, but keep the pgdat_resize_lock() around for readers that
> can't lock a mutex.
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>

Nack, these fields are initialized at boot without lock_memory_hotplug(), 
so you're statement is wrong, and all you need is pgdat_resize_lock().
