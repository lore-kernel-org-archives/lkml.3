Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3HPIy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:54:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26886 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab3HPIye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:54:34 -0400
Date: Fri, 16 Aug 2013 11:54:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Frederich <jfrederich@gmail.com>
Cc: devel@driverdev.osuosl.org, Greg KH <gregkh@linuxfoundation.org>,
        Jon Nettleton <jon.nettleton@gmail.com>, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Staging: olpc_dcon: replace some magic numbers
Message-ID: <20130816085419.GD26086@mwanda>
References: <1376595295-7820-1-git-send-email-jfrederich@gmail.com>
 <20130816071338.GC26086@mwanda>
 <CAF92urq-bL_y9zjt9THh-LJjxrMYmdjwr7RssgBk+zxC-OhRdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF92urq-bL_y9zjt9THh-LJjxrMYmdjwr7RssgBk+zxC-OhRdQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 09:40:38AM +0200, Jens Frederich wrote:
> On Fri, Aug 16, 2013 at 9:13 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Thu, Aug 15, 2013 at 09:34:55PM +0200, Jens Frederich wrote:
> >> The 0x42 initialize squence 0x101 is wrong.  According to
> >> the specification Bit 8 is reserved, thus not in use.
> >> I removed it.
> >
> > Really these code changes should be in a separate patch and labeled
> > "Don't set reserved bit." instead of hidden away inside a cleanup
> > patch.
> >
> 
> The patch is applied. Still, good to know. It's not so easy to find the
> right patch granularity as newbie.
> 

Yeah.  Staging is for educating people about kernel process as much
as it is about writing code.

The rule here is "Don't mix code changes into a cleanup patches."
What we want is if you have a bug then you can look through
`git log --oneline` output and guess which patch introduced the bug.
This patch is a cleanup patch so it shouldn't introduce any code
changes or any bugs.

Meanwhile, if you are making a code change you can make any cleanups
you need to in order to do the change.  Also if there is an existing
checkpatch warning on any of the lines you touch, then that's ok to
fix as well.  Or if there are tiny related changes than that's fine.

There are three problems with big patches:
1) It breaks the --oneline summary to mix two things into one patch.
2) It makes the patch harder to review.  For example, sometimes
   people fix a bug and rename 10 variables as well.
3) The more lines your patch is, the more chance there is that we
   will reject it based on one of those lines.  You don't like
   redoing patches and we don't like making people redo them.  So
   small patches are better and put the more controversial ones at
   the end so the first patches can be applied.

No one totally agrees what "small closely related cleanups" means so
it's better to be conservative.

regards,
dan carpenter

