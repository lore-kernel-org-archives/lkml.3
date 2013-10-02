Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3JBPir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:38:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab3JBPip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:38:45 -0400
Date: Wed, 2 Oct 2013 17:38:42 +0200
From: Jan Kara <jack@suse.cz>
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        infinipath <infinipath@intel.com>, Roland Dreier <roland@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Message-ID: <20131002153842.GD32181@quack.suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
 <1380724087-13927-24-git-send-email-jack@suse.cz>
 <32E1700B9017364D9B60AED9960492BC211AEF75@FMSMSX107.amr.corp.intel.com>
 <20131002152811.GC32181@quack.suse.cz>
 <32E1700B9017364D9B60AED9960492BC211AF005@FMSMSX107.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC211AF005@FMSMSX107.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 02-10-13 15:32:47, Marciniszyn, Mike wrote:
> > > The risk of GUP fast is the loss of the "force" arg on GUP fast, which
> > > I don't see as significant give our use case.
> >   Yes. I was discussing with Roland some time ago whether the force
> > argument is needed and he said it is. So I kept the arguments of
> > get_user_pages() intact and just simplified the locking...
> 
> The PSM side of the code is a more traditional use of GUP (like direct
> I/O), so I think it is a different use case than the locking for IB
> memory regions.
  Ah, I see. Whatever suits you best. I don't really care as long as
get_user_pages() locking doesn't leak into IB drivers :)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
