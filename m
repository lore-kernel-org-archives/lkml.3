Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaDDTP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:15:26 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:58516 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbaDDTPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:15:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL for v3.15-rc1] media updates
Date: Fri, 04 Apr 2014 21:17:27 +0200
Message-ID: <6647416.Eq0uqnt6If@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CA+55aFwSA58-gbBBLHd87HBj6X-wZisE+9KDoxaJ1UrvqiyYFA@mail.gmail.com>
References: <20140403131143.69f324c7@samsung.com> <CA+55aFwSA58-gbBBLHd87HBj6X-wZisE+9KDoxaJ1UrvqiyYFA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Friday 04 April 2014 10:26:42 Linus Torvalds wrote:
> On Thu, Apr 3, 2014 at 9:11 AM, Mauro Carvalho Chehab wrote:
> > PS.: You'll find some minor conflicts between this changeset and upstream,
> > mainly due to some code that moved from V4L2 to OF subsystem.
> 
> That conflict was not at all minor, unless I were willing to do the
> merge incorrectly and just drop all changes from one side. Which is
> not how I do merges if I can at all avoid it.
> 
> The *trivial* merge would be to just take the
> of_graph_get_next_endpoint() function as it existed in its new
> location of drivers/of/base.c.
> 
> However, there were to clashing changes to that function (one in the
> original location, one in the new moved location). They were:
> 
>  - b9db140c1e46: "[media] v4l: of: Support empty port nodes"
>  - 4329b93b283c: "of: Reduce indentation in of_graph_get_next_endpoint"
> 
> and quite frankly, I think that the second commit was the much less
> interesting of the two, so *that* was the one I felt I should drop.
> But that made the merge a lot more interesting than just picking the
> new location (because the new location didn't have the important
> change). And those two changes clash to the point of being basically
> mutually exclusive.
> 
> So I did the complex merge that I think is the right thing by hand.
> 
> However, I feel a bit bad about that more merge, because I have
> absolutely no way to test my result. So I'm including here all the
> relevant people wrt those two commits, and my note from my merge
> message:
> 
>   NOTE! This merge effective drops commit 4329b93b283c ("of: Reduce
>   indentation in of_graph_get_next_endpoint").
> 
>   The of_graph_get_next_endpoint() function was moved and renamed by
>   commit fd9fdb78a9bf ("[media] of: move graph helpers from
>   drivers/media/v4l2-core to drivers/of").  It was originally called
>   v4l2_of_get_next_endpoint() and lived in the file
>   drivers/media/v4l2-core/v4l2-of.c.
> 
>   In that original location, it was then fixed to support empty port
>   nodes by commit b9db140c1e46 ("[media] v4l: of: Support empty port
>   nodes"), and that commit clashes badly with the dropped "Reduce
>   intendation" commit.  I had to choose one or the other, and decided
>   that the "Support empty port nodes" commit was more important
> 
> So guys, can you please verify the end result? It looks sane to me,
> but there's no good way for me to do even basic compile testing of the
> OF code, so this was all done entirely blind. And hey, maybe you
> disagree about the empty port nodes being the important case anyway.
> 
> Maybe I should have done the "wrong" merge just to avoid this issue,
> but I do hate doing that.

I've reviewed the merge and tested it, and all looks good. Thank you for not 
dropping my patch :-)

-- 
Regards,

Laurent Pinchart

