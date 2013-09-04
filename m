Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760434Ab3IDDxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 23:53:11 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54456 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626Ab3IDDxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 23:53:08 -0400
X-Sasl-enc: WuHI+zCqPGUtBjHDN7o0FfhHP4SYNLpNmq13vwijCsoI 1378266787
Message-ID: <1378266784.2364.11.camel@perseus.fritz.box>
Subject: Re: [PATCH 1/3] autofs4 - fix device ioctl mount lookup
From: Ian Kent <raven@themaw.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, rui.xiang@huawei.com,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 04 Sep 2013 11:53:04 +0800
In-Reply-To: <20130904024230.GH13318@ZenIV.linux.org.uk>
References: <20130904005456.5025.94309.stgit@perseus.fritz.box>
	 <20130904010301.GE13318@ZenIV.linux.org.uk>
	 <20130904020013.GF13318@ZenIV.linux.org.uk>
	 <CA+55aFwF+dqSMyGE+3LamM+qSDymieyReYB+RPb8fHTTmntgqw@mail.gmail.com>
	 <20130904022617.GG13318@ZenIV.linux.org.uk>
	 <20130904024230.GH13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-04 at 03:42 +0100, Al Viro wrote:
> On Wed, Sep 04, 2013 at 03:26:17AM +0100, Al Viro wrote:
> > I've applied slightly modified variant of Jeff's "vfs: allow umount to handle
> > mountpoints without revalidating them" (modified by just leaving the
> > struct path filled with mountpoint and leaving the equivalent of follow_mount()
> > to caller) to the local queue and I'm pretty sure that it's what we want
> > here as well.
> 
> ... and killed the modifications since the result ends up uglier for
> caller(s) anyway.  Reapplied as-is.

But isn't that what's needed anyway?

Looks like it fits with the existing code that walks back down looking
for a match.

And that fits in with fixing the bug where we want the first match just
means breaking out early. The match should be close to the top, if not
the first then the second, for the common case.

Ian

