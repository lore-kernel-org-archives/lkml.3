Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbaIEODe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:03:34 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:50064 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbaIEODd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:03:33 -0400
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Fri, 5 Sep 2014 10:03:29 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/17] locks: move freeing of leases outside of
 i_lock
Message-ID: <20140905100329.00da1065@tlielax.poochiereds.net>
In-Reply-To: <20140904175014.GE16935@infradead.org>
References: <1409834323-7171-1-git-send-email-jlayton@primarydata.com>
	<1409834323-7171-12-git-send-email-jlayton@primarydata.com>
	<20140904175014.GE16935@infradead.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014 10:50:14 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Sep 04, 2014 at 08:38:37AM -0400, Jeff Layton wrote:
> > There was only one place where we still could free a file_lock while
> > holding the i_lock -- lease_modify. Add a new list_head argument to the
> > lm_change operation, pass in a private list when calling it, and fix
> > those callers to dispose of the list once the lock has been dropped.
> 
> As mentioned I don't see a real need for this, but it does look correct
> to me.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Yeah, it's not strictly necessary, but I think it simplifies the API
for potential users. We already have the infrastructure to handle
deferring file_lock removal so we might as well take advantage of it
here too.

-- 
Jeff Layton <jlayton@primarydata.com>
