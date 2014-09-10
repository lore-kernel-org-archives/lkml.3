Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaIJTeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:34:07 -0400
Received: from fieldses.org ([174.143.236.118]:47744 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaIJTeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:34:05 -0400
Date: Wed, 10 Sep 2014 15:34:02 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jeff Layton <jeff.layton@primarydata.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, trond.myklebust@primarydata.com,
        smayhew@redhat.com
Subject: Re: [RFC PATCH 08/12] nfs: convert lock handling to use
 file_lock_context
Message-ID: <20140910193402.GE4210@fieldses.org>
References: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
 <1410359330-27564-9-git-send-email-jlayton@primarydata.com>
 <20140910191734.GD4210@fieldses.org>
 <20140910152810.36ec5bc0@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910152810.36ec5bc0@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 03:28:10PM -0400, Jeff Layton wrote:
> Yes, that's the downside of moving to multiple list_heads. Still, I
> think it's worth doing that even if we end up with the code a bit more
> verbose.
> 
> It may be best to consider moving some of this into helpers that live
> in locks.c. I really don't like having filesystems poke around in the
> intimate details of the file locking code as a general rule...

I was also wondering whether helpers like for_each_posix_lock() or
first_posix_lock() would be worth it.

--b.
