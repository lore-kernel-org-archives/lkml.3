Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624Ab3CLV2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:28:44 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:63551 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab3CLV2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:28:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130312212027.GE14792@thunk.org>
References: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
	<alpine.LRH.2.02.1303121510270.25612@tundra.namei.org>
	<20130312041641.GE18595@thunk.org>
	<CA+55aFzFLDcN-1GKae6Xqrns59K1xOD_HPzuv2Lv1__fZpqFMw@mail.gmail.com>
	<20130312212027.GE14792@thunk.org>
Date: Tue, 12 Mar 2013 14:28:39 -0700
X-Google-Sender-Auth: wt9-laVn-m2NEtyUhsvL673BBgA
Message-ID: <CA+55aFwHJtOU4Qzt3XZsER165kTc5P0ATQP2wPHvuUiVic8bnA@mail.gmail.com>
Subject: Re: linux-next: unneeded merge in the security tree
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Git Mailing List <git@vger.kernel.org>,
        Junio C Hamano <gitster@pobox.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 2:20 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> What if we added the ability to do something like this:
>
> [remote "origin"]
>         url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>         fetch = +refs/heads/master:refs/heads/master
>         mergeoptions = --ff-only

Hmm. Something like this could be interesting for other things:

 - use "--rebase" when pulling (this is common for people who maintain
a set of patches and do *not* export their git tree - I use it for
projects like git and subsurface where there is an upstream maintainer
and I usually send patches by email rather than git)

 - "--no-summary". As a maintainer, you people probably do want to
enable summaries for people they pull from, but *not* from upstream.
So this might even make sense to do by default when you clone a new
repository.

 - I do think that we might want a "--no-signatures" for the specific
case of merging signed tags without actually taking the signature
(because it's a "upstream" repo). The "--ff-only" thing is *too*
strict. Sometimes you really do want to merge in new code, disallowing
it entirely is tough.

Of course, I'm not really sure if we want to list the flags. Maybe
it's better to just introduce the notion of "upstream" directly, and
make that a flag, and make "origin" default to that when you clone.
And then have git use different heurstics for pulling upstream (like
warning by default when doing a back-merge, perhaps?)

                   Linus
