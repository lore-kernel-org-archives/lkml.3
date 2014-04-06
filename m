Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaDFDDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 23:03:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35888 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754013AbaDFDD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 23:03:27 -0400
X-Sasl-enc: g/i3pKIBpaH/tBKmdsVk3gpjB/D/BM5NIHQaiqnt3JVC 1396753406
Message-ID: <1396753403.24991.3.camel@perseus.fritz.box>
Subject: Re: [PATCH] autofs4: check dev ioctl size before allocating
From: Ian Kent <raven@themaw.net>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        akpm@linux-foundation.org
Date: Sun, 06 Apr 2014 11:03:23 +0800
In-Reply-To: <53401C11.7010601@oracle.com>
References: <1394934021-16965-1-git-send-email-sasha.levin@oracle.com>
	 <53401C11.7010601@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-04-05 at 11:06 -0400, Sasha Levin wrote:
> Ping? Anyone wants to take this?

Is this causing a problem for users?
If it is I'll send it to Andrew straight away.

I do have this on my queue but don't have any other patches to send so
it's just sitting there.

If it worries you I'll send it to Andrew now.

> 
> On 03/15/2014 09:40 PM, Sasha Levin wrote:
> > There wasn't any check of the size passed from userspace before
> > trying to allocate the memory required.
> > 
> > This meant that userspace might request more space than allowed,
> > triggering an OOM.
> > 
> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> > ---
> >  fs/autofs4/dev-ioctl.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
> > index 3182c0e..86fa7af 100644
> > --- a/fs/autofs4/dev-ioctl.c
> > +++ b/fs/autofs4/dev-ioctl.c
> > @@ -103,6 +103,9 @@ static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *i
> >  	if (tmp.size < sizeof(tmp))
> >  		return ERR_PTR(-EINVAL);
> >  
> > +	if (tmp.size > (PATH_MAX + sizeof(tmp)))
> > +		return ERR_PTR(-E2BIG);
> > +
> >  	return memdup_user(in, tmp.size);
> >  }
> >  
> > 
> 


