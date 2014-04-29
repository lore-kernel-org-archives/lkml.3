Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbaD2XFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 19:05:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbaD2XFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 19:05:12 -0400
Date: Wed, 30 Apr 2014 01:04:58 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <kmo@daterainc.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] aio: change exit_aio() to load mm->ioctx_table once
 and avoid rcu_read_lock()
Message-ID: <20140429230457.GA4604@mguzik.redhat.com>
References: <20140429183915.GA32513@redhat.com>
 <20140429184004.GB32521@redhat.com>
 <20140429204217.GO14608@kvack.org>
 <20140429212222.GA28959@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140429212222.GA28959@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 05:22:22PM -0400, Benjamin LaHaise wrote:
> On Tue, Apr 29, 2014 at 04:42:17PM -0400, Benjamin LaHaise wrote:
> > > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > 
> > Your patch does not apply because it is whitespace damaged.  Please resend 
> > and verify that it applies with 'git am'.
> 
> Whoops, it's not whitespace damange, but rather that it doesn't apply with 
> the other changes that are queued up in the aio-next tree.  You can find a 
> copy of that tree at git://git.kvack.org/~bcrl/aio-next.git .  The change 
> that conflicts is an additional parameter to kill_ioctx().

While here is there any reason for:
rcu_assign_pointer(mm->ioctx_table, NULL);

Nothing looks at this pointer afterwards and mm is about to be freed.

I thought it would be used to sanity check that everything was cleared
before freeing, but that is nod one and not every pointer is nullified
anyway.

-- 
Mateusz Guzik
