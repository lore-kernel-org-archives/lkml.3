Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaIDSDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:03:08 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:65220 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaIDSDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:03:06 -0400
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Thu, 4 Sep 2014 14:03:03 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 13/17] locks: remove i_have_this_lease check from
 __break_lease
Message-ID: <20140904140303.0b108188@tlielax.poochiereds.net>
In-Reply-To: <20140904175132.GG16935@infradead.org>
References: <1409834323-7171-1-git-send-email-jlayton@primarydata.com>
	<1409834323-7171-14-git-send-email-jlayton@primarydata.com>
	<20140904175132.GG16935@infradead.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014 10:51:32 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Sep 04, 2014 at 08:38:39AM -0400, Jeff Layton wrote:
> > I think that the intent of this code was to ensure that a process won't
> > deadlock if it has one fd open with a lease on it and then breaks that
> > lease by opening another fd. In that case it'll treat the __break_lease
> > call as if it were non-blocking.
> > 
> > This seems wrong -- the process could (for instance) be multithreaded
> > and managing different fds via different threads. I also don't see any
> > mention of this limitation in the (somewhat sketchy) documentation.
> > 
> > Remove the check and the non-blocking behavior when i_have_this_lease
> > is true.
> 
> This looks reasonable to me, but I'm always very worried about changing
> userspace exposed behavior..
> 

Yeah, me too, but I think the behavior in this case is just plain
wrong. It's really hard to understand how anyone would rely on this to
avoid deadlocking, but you never know...

I want to phase this out, but I'm certainly open to doing this in a
smoother fashion if anyone has suggestions on how to do so.

Thanks,
-- 
Jeff Layton <jlayton@primarydata.com>
