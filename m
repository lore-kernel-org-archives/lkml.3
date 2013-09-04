Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761713Ab3IDCSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 22:18:45 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:54797 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab3IDCSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 22:18:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130904020013.GF13318@ZenIV.linux.org.uk>
References: <20130904005456.5025.94309.stgit@perseus.fritz.box>
	<20130904010301.GE13318@ZenIV.linux.org.uk>
	<20130904020013.GF13318@ZenIV.linux.org.uk>
Date: Tue, 3 Sep 2013 19:18:42 -0700
X-Google-Sender-Auth: NSwTFP_gufOtuEq5pfR0GHwo_A4
Message-ID: <CA+55aFwF+dqSMyGE+3LamM+qSDymieyReYB+RPb8fHTTmntgqw@mail.gmail.com>
Subject: Re: [PATCH 1/3] autofs4 - fix device ioctl mount lookup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ian Kent <raven@themaw.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        rui.xiang@huawei.com, autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 7:00 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> That aside, I'm really not happy with this kind of games; this stuff clearly
> belongs in fs/namei.c where we can simply see the last component.  Doing that
> on the level of "let's scan the pathname for slashes, etc." is just plain
> wrong.  Let's step back for a minute here; what are you trying to do?
> You have a pathname that should resolve to a mountpoint, without triggering
> automount (or crossing into the mountpoint, for that matter) and you want
> struct path for the bottom of that mount stack?  Or is it something
> completely different?

Can we add a LOOKUP_NOAUTOMNT bit or something (not exposed to user
space, only used for this particular kern_path() call). Then, if/when
automount gets called recursively (through autofs4_lookup? Or is it
just the autofs4_d_automount() interface?) it can just decide to not
follow that last path.

Hmm? I don't think we pass in the lookup-flags to d_automount, but
that could be changed. Yes?

             Linus
