Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbaCNPIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:08:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbaCNPIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:08:53 -0400
Date: Fri, 14 Mar 2014 16:08:50 +0100
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Roman Peniaev <r.peniaev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] fs/mpage.c: forgotten WRITE_SYNC in case of data
 integrity write
Message-ID: <20140314150850.GA5175@quack.suse.cz>
References: <CACZ9PQUKzsP4mwJSO3c=Z3W2pYr2AME-9j+1Cqg9t8a4T+uQQg@mail.gmail.com>
 <20140313200119.GB504@quack.suse.cz>
 <20140313143456.157404fd7f208638ca70e317@linux-foundation.org>
 <20140314130712.GC12613@htj.dyndns.org>
 <CACZ9PQUQX-sSNo+z0LB0Tefq9pSHFr6GjKg2tWzdAtw3OYYDsg@mail.gmail.com>
 <20140314141143.GH12613@htj.dyndns.org>
 <20140314141511.GF18583@quack.suse.cz>
 <CACZ9PQXNK=z-bk8BJ8rmU9dJiEAcoHBFBoGDK_QoJ0NQFweufQ@mail.gmail.com>
 <20140314145215.GG18583@quack.suse.cz>
 <20140314145430.GL12613@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314145430.GL12613@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 14-03-14 10:54:30, Tejun Heo wrote:
> On Fri, Mar 14, 2014 at 03:52:15PM +0100, Jan Kara wrote:
> >   Well, for ext2, you can use ext4 kernel driver which takes care of
> > REQ_FLUSH properly. For fat, you'll need to fix the fs...
> 
> This is a bit surprising tho.  Were we always like this?  We never had
> even stupid "flush down everything and sync"?  Or is this something we
> broke while morphing flush implementation several times in the past
> years?
  It has been always like this. We could add some sending of REQ_FLUSH into
generic code - like generic_file_fsync() and some similar helper for
->sync_fs(). Just someone has to do it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
