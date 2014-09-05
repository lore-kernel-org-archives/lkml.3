Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbaIENfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:35:11 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:33789 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422AbaIENfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:35:09 -0400
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Fri, 5 Sep 2014 09:35:04 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/17] locks: __break_lease cleanup in preparation of
 allowing direct removal of leases
Message-ID: <20140905093504.215b288f@tlielax.poochiereds.net>
In-Reply-To: <20140904180725.GA11232@infradead.org>
References: <1409834323-7171-1-git-send-email-jlayton@primarydata.com>
	<1409834323-7171-15-git-send-email-jlayton@primarydata.com>
	<20140904180725.GA11232@infradead.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014 11:07:25 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Sep 04, 2014 at 08:38:40AM -0400, Jeff Layton wrote:
> > Eliminate an unneeded "flock" variable. We can use "fl" as a loop cursor
> > everywhere. Add a any_leases_conflict helper function as well to
> > consolidate a bit of code.
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> One thing that came to mind after starring at this code for a while and
> then seeing your cleanup:
> 
> the sleep/wake patterns in __break_lease seem highly suboptimal, as
> we always wait for the break time on the first least found, why
> don't we simply take the max of the lease break times, and wait for
> that?
> 
> I guess the case of lots of read leases just isn't common enough to
> bother..

That would make more sense. I've no objection to changing it to do that
though it's probably outside the scope of this patchset.

-- 
Jeff Layton <jlayton@primarydata.com>
