Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbaGXQf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:35:29 -0400
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:49432 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757637AbaGXQf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:35:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:2691:2692:2693:2828:3138:3139:3140:3141:3142:3354:3622:3865:3867:3868:3870:3871:3872:3873:3874:4321:5007:6691:7652:7903:8660:10004:10400:10848:10967:11232:11658:11914:12296:12517:12519:12663:12740:13069:13148:13230:13311:13357:14096:14097:21080,0
X-HE-Tag: club60_693ffbe4c583e
X-Filterd-Recvd-Size: 3079
Message-ID: <1406219722.27221.46.camel@joe-AO725>
Subject: Re: [PATCH 9/9] fs: dlm: lockd: Convert int result to unsigned char
 type
From: Joe Perches <joe@perches.com>
To: Jeff Layton <jlayton@poochiereds.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        David Teigland <teigland@redhat.com>,
        Christine Caulfield <ccaulfie@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Thu, 24 Jul 2014 09:35:22 -0700
In-Reply-To: <20140724122445.2ebd1b23@tlielax.poochiereds.net>
References: <cover.1405879494.git.joe@perches.com>
	 <65b9ba0dba9c79a938267d5bed7ed0a8211e89ed.1405879494.git.joe@perches.com>
	 <20140723141139.2cf90cb0@tlielax.poochiereds.net>
	 <1406174039.2755.71.camel@joe-AO725>
	 <20140724122445.2ebd1b23@tlielax.poochiereds.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-24 at 12:24 -0400, Jeff Layton wrote:
> On Wed, 23 Jul 2014 20:53:59 -0700 Joe Perches <joe@perches.com> wrote:
> > On Wed, 2014-07-23 at 14:11 -0400, Jeff Layton wrote:
> > > On Sun, 20 Jul 2014 11:23:43 -0700 Joe Perches <joe@perches.com> wrote:
> > > > op->info.rv is an s32, but it's only used as a u8.
> > > I don't understand this patch. info.rv is s32 (and I assume that "rv"
> > > stands for "return value").
> > 
> > In this case it's not a return value but an input.
[]
> Well, it's an input into the lm_grant callback, but it originally comes
> in the downcall from userland (AFAICT). In this case, I'm referring to
[]
> It's been a while since I've looked over the lockd code, but I believe
> it's just a flag that indicates whether there is still a conflict
> between the block and the lock on the file.

Yes, that is how it is used.

> I don't think that patch will break anything. I just don't see it as an
> improvement on what's already there.
> 
> The rationale for this is lost in antiquity, but I think the basic idea
> was that you're either granting or updating the block based on the
> _result_ from some check for a lock conflict. While "result" as a name
> is a little confusing, "type" is even more so, IMO.
> 
> If you're hell-bent on changing this, then my suggestion would be
> to turn it into a bool and call it "conflict" or something similar. If
> you do decide to do that, adding some helpful kerneldoc comments would
> be a nice improvement too.

I hope I'm never hell-bent on patches.

I do prefer easier to read, clear code and I agree
that using it as a bool would make the code better.

I'll see about kernel-doc changes too.

cheers, Joe

