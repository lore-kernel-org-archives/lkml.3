Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbaCOJJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 05:09:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45478 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaCOJJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 05:09:41 -0400
Date: Sat, 15 Mar 2014 02:09:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Roman Peniaev <r.peniaev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] fs/mpage.c: forgotten WRITE_SYNC in case of data
 integrity write
Message-ID: <20140315090932.GA24576@infradead.org>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 10:54:30AM -0400, Tejun Heo wrote:
> This is a bit surprising tho.  Were we always like this?  We never had
> even stupid "flush down everything and sync"?  Or is this something we
> broke while morphing flush implementation several times in the past
> years?

It's something that never worked in Linux.  Until XFS went ahead and
enabled barriers by default no filesystem in Linux ever flushed the
volatile cache by default, and most couldn't (and still can't) even if
you asked them to.
