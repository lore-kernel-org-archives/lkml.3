Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab3H2Qhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:37:46 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:62456 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab3H2Qhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:37:45 -0400
Date: Thu, 29 Aug 2013 18:37:44 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, bfoster@redhat.com, xemul@parallels.com,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 2/2] fuse: wait for writeback in fuse_file_fallocate() -v2
Message-ID: <20130829163744.GC19636@tucsk.piliscsaba.szeredi.hu>
References: <20130812163935.10366.88320.stgit@maximpc.sw.ru>
 <20130816112854.5630.1907.stgit@maximpc.sw.ru>
 <20130829154110.GB19636@tucsk.piliscsaba.szeredi.hu>
 <521F7672.7050407@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521F7672.7050407@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 08:27:30PM +0400, Maxim Patlasov wrote:

> >So having a barrier like FUSE_NOWRITE is good but then we need to take care
> >of throwing away the truncated part of the queue.  But that should be doable
> >by passing the truncated range explicitly to fuse_release_nowrite().
> 
> Yes, I considered this approach, but splitting a fuse request into
> two in fuse_send_writepage() made me sick. What if allocation fails?

Heh, yeah.

I can think of a hundred ways this could be solved without needing an
allocation.  Probably none of them worth the hassle.

Or if the hole fits inside the write we could just zero out the affected pages.
Which is cheating a bit, but no one will notice ;)

Thanks,
Miklos
