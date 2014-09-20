Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbaITAUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 20:20:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43903 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538AbaITAUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 20:20:51 -0400
Date: Fri, 19 Sep 2014 17:19:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v2 2/5] Define new syscalls readv2,preadv2,writev2,pwritev2
Message-ID: <20140920001959.GA18131@birch.djwong.org>
References: <cover.1410983998.git.milosz@adfin.com>
 <a5d46efa590f0d32cf209495cdb897ffadb859c5.1410983999.git.milosz@adfin.com>
 <20140918184823.GA10155@birch.djwong.org>
 <20140919105220.GC14281@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919105220.GC14281@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 03:52:20AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 18, 2014 at 11:48:23AM -0700, Darrick J. Wong wrote:
> > A few months ago I was working on extending these interfaces (well, the
> > p{read,write}* ones and AIO) to tack on an IO extension buffer at the end of
> > the syscall arguments.
> 
> Honestly, that proposal is so but ugly that I treated it as an April
> first joke.  I don't really think we want any of that overload mess.

I agree that a kitchen sink structure full of IO attributes is messy; at best
it avoids maintenance of horrifying parameter lists.  The first two drafts of
the interface were too complicated and with the help of everyone who responded
to the first two threads with their criticisms, I've focused on paring down the
parts that people can screw up.

In v3, I define only a flat struct io_extension from which extensions can
copy_from_user whatever bits they want.  Ideally I'd have three or four uses of
the extension API lined up for a more thoughtful design, but I'm just now
getting around to a second.

Clearly you have ideas of what constitutes good and bad API design.  I've never
defined a major programming interface.  Can you point me towards examples of
where we've gotten it right?  Or possibly a discussion of design?  The
materials from mkerrisk's 2007 talk about kernel API design seem to have gone
down with kernel.org, and I prefer to avoid badgering linux-api until I'm more
confident that I won't fall into the "this is apparently so bad that people
won't reply" trap.

I'm willing to learn, but snark about April Fool's jokes leading to silence
does not help me to improve the code or to help myself.

--D
