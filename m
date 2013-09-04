Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761745Ab3IDCq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 22:46:28 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42411 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755814Ab3IDCq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 22:46:26 -0400
X-Sasl-enc: sLXwO0prnNz3YfER69GGtFxsWOqtA3q1sQgHBaR56JUh 1378262784
Message-ID: <1378262782.2364.6.camel@perseus.fritz.box>
Subject: Re: [PATCH 1/3] autofs4 - fix device ioctl mount lookup
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, rui.xiang@huawei.com,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 04 Sep 2013 10:46:22 +0800
In-Reply-To: <CA+55aFwF+dqSMyGE+3LamM+qSDymieyReYB+RPb8fHTTmntgqw@mail.gmail.com>
References: <20130904005456.5025.94309.stgit@perseus.fritz.box>
	 <20130904010301.GE13318@ZenIV.linux.org.uk>
	 <20130904020013.GF13318@ZenIV.linux.org.uk>
	 <CA+55aFwF+dqSMyGE+3LamM+qSDymieyReYB+RPb8fHTTmntgqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-03 at 19:18 -0700, Linus Torvalds wrote:
> On Tue, Sep 3, 2013 at 7:00 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > That aside, I'm really not happy with this kind of games; this stuff clearly
> > belongs in fs/namei.c where we can simply see the last component.  Doing that
> > on the level of "let's scan the pathname for slashes, etc." is just plain
> > wrong.  Let's step back for a minute here; what are you trying to do?
> > You have a pathname that should resolve to a mountpoint, without triggering
> > automount (or crossing into the mountpoint, for that matter) and you want
> > struct path for the bottom of that mount stack?  Or is it something
> > completely different?
> 
> Can we add a LOOKUP_NOAUTOMNT bit or something (not exposed to user
> space, only used for this particular kern_path() call). Then, if/when
> automount gets called recursively (through autofs4_lookup? Or is it
> just the autofs4_d_automount() interface?) it can just decide to not
> follow that last path.
> 
> Hmm? I don't think we pass in the lookup-flags to d_automount, but
> that could be changed. Yes?

We don't need to.

Al is completely right, Jeff's umount path lookup patch will cover all
the needed cases, AFAICS.

That's a relief.

> 
>              Linus


