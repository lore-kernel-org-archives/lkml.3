Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaLBPSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:18:38 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:51296 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaLBPSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:18:37 -0500
Date: Tue, 2 Dec 2014 10:18:29 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] mm: memory: remove ->vm_file check on shared
 writable vmas
Message-ID: <20141202151829.GC8401@phnom.home.cmpxchg.org>
References: <1417474682-29326-1-git-send-email-hannes@cmpxchg.org>
 <1417474682-29326-2-git-send-email-hannes@cmpxchg.org>
 <20141202085825.GA9092@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202085825.GA9092@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 09:58:25AM +0100, Jan Kara wrote:
> On Mon 01-12-14 17:58:01, Johannes Weiner wrote:
> > The only way a VMA can have shared and writable semantics is with a
> > backing file.
>   OK, one always learns :) After some digging I found that MAP_SHARED |
> MAP_ANONYMOUS mappings are in fact mappings of a temporary file in tmpfs.
> It would be worth to mention this in the changelog I believe. Otherwise
> feel free to add:
>   Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, Jan.  I updated the changelog to read:

Shared anonymous mmaps are implemented with shmem files, so all VMAs
with shared writable semantics also have an underlying backing file.
