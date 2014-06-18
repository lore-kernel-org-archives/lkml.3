Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbaFRX2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:28:54 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:56721 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbaFRX2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:28:51 -0400
Date: Wed, 18 Jun 2014 16:28:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ian Kent <raven@themaw.net>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] proc/stat: convert to single_open_size()
In-Reply-To: <1402909492-36486-2-git-send-email-heiko.carstens@de.ibm.com>
Message-ID: <alpine.DEB.2.02.1406181623400.22789@chino.kir.corp.google.com>
References: <1402909492-36486-1-git-send-email-heiko.carstens@de.ibm.com> <1402909492-36486-2-git-send-email-heiko.carstens@de.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Heiko Carstens wrote:

> Use seq_file's single_open_size() to preallocate a buffer that is large
> enough to hold the whole output, instead of open coding it.
> Also calculate the requested size using the number of online cpus instead
> of possible cpus, since the size of the output only depends on the number
> of online cpus.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>

I have no idea why the check for size > KMALLOC_MAX_SIZE was there, all 
slab allocators will fallback to the page allocator and the slowpath will 
return NULL.
