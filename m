Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaFLU7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:59:33 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:55516 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaFLU7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:59:31 -0400
Date: Thu, 12 Jun 2014 13:59:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Ian Kent <raven@themaw.net>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/2] fs: proc/stat: use usual seq_file ops rather than
 single_open
In-Reply-To: <20140612072741.GA4296@osiris>
Message-ID: <alpine.DEB.2.02.1406121358390.8305@chino.kir.corp.google.com>
References: <20140521122521.GB7471@osiris> <20140521143229.GA32011@infradead.org> <20140528085841.GA4219@osiris> <20140528090153.GC4219@osiris> <20140528153704.b2a3f46dc39ebf8f681d528a@linux-foundation.org> <1402301519.2775.47.camel@perseus.fritz.box>
 <20140611124301.GC4296@osiris> <alpine.DEB.2.02.1406111524330.27885@chino.kir.corp.google.com> <1402554262.2642.16.camel@perseus.fritz.box> <alpine.DEB.2.02.1406112350010.23724@chino.kir.corp.google.com> <20140612072741.GA4296@osiris>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Heiko Carstens wrote:

> Yes, that doesn't make any sense. I wrote the patch together in a hurry and
> didn't think much about it.
> So below is the what I think most simple conversion to a vmalloc fallback
> approach for seq files. However the question remains if this seems to be an
> acceptable approach at all...
> 

I think the approach is fine.  We do now have a generic kvfree() function 
defined in mm.h that will handle the freeing, though, determined by 
is_vmalloc_addr() so seq_free() is no longer necessary.
