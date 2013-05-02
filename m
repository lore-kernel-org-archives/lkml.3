Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761770Ab3EBTtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:49:45 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:52007 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761707Ab3EBTtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:49:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130502193309.GC16031@redhat.com>
References: <20130502105353.GA24655@redhat.com>
	<1367520929.23900.114.camel@haakon3.risingtidesystems.com>
	<20130502193309.GC16031@redhat.com>
Date: Thu, 2 May 2013 12:49:42 -0700
X-Google-Sender-Auth: tueTZMpfZ3aWSequWG9bzdEkRX0
Message-ID: <CA+55aFwwVMhmmJfWoepipWT+WQZHt4gRPKSucgBABe5Rq=kVkw@mail.gmail.com>
Subject: Re: [PULL] vhost: cleanups and fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        KVM list <kvm@vger.kernel.org>, virtualization@lists.osdl.org,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Asias He <asias@redhat.com>,
        target-devel <target-devel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 12:33 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> I prefer not rebasing,

Good.

>                   will play with git to see why
> does request-pull get me a wrong diffstat and how
> to trick it into doing the right thing.
> Maybe merging my branch into master will do this.

No, don't do an unnecessary merge just to get the diffstat right.

git pull-request ends up assuming that there are no back-merges, and
that you have a uniquely defined single shared merge base. That allows
pull-request to just generate the diff directly from that merge base,
without actually trying to do the merge itself (which may have
conflicts etc).

But because git pull-request doesn't actually *do* the merge, it means
that it will fail to give the correct diffstat if the tree is
complicated and has multiple merge bases, and it can't really figure
what the original shared state was before the development.

This is just one reason I do *not* want to see back-merges. They make
history harder to read not just for humans.

You can either ignore the problem (I'll see the real diffstat when I
actually do the merge), or you can do a test-merge yourself (that you
do *not* then push out in the development branch - keep it in a
temporary branch for your own edification or just delete it after
doing the merge, and don't do development on it!)

In this case, it's an indirect back-merge: you back-merged a commit
from the target tree that I have now merged, so it has become a
back-merge. I'm not sure why you did that - if you needed to start
from that state, it would actually have been better to just start at
that state instead of merging it. But whatever. You can get the
diffstat by using your merge as the base, so

    git diff -M --stat --summary bc7562355fda..

in your branch should get the right result without any merges etc..
But please do send me a proper pull request.

              Linus
