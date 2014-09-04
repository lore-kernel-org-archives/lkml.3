Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbaIDVZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:25:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbaIDVZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:25:30 -0400
Date: Thu, 4 Sep 2014 14:25:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Greg KH <greg@kroah.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH] kernel: add support for gcc 5
Message-Id: <20140904142529.860f4dc4514def7fb7a9d365@linux-foundation.org>
In-Reply-To: <CAFLxGvx0Os=qJP8XSpCvj17SNNk6YA1bNZoQsVO3CksgfFbxfQ@mail.gmail.com>
References: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com>
	<20140904141215.9e6125150824d0768aedbfcb@linux-foundation.org>
	<CAFLxGvx0Os=qJP8XSpCvj17SNNk6YA1bNZoQsVO3CksgfFbxfQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014 23:19:34 +0200 Richard Weinberger <richard.weinberger@gmail.com> wrote:

> On Thu, Sep 4, 2014 at 11:12 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Thu,  4 Sep 2014 11:37:19 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
> >
> >> We're missing include/linux/compiler-gcc5.h which is required now
> >> because gcc branched off to v5 in trunk.
> >>
> >> Just copy the relevant bits out of include/linux/compiler-gcc4.h,
> >> no new code is added as of now.
> >>
> >> This fixes a build error when using gcc 5.
> >
> > I think I'll stick a cc:stable on this one, as people will presumably
> > wish to compile older kernels with newer gcc's at some time in the
> > future.
> 
> CC'ing Hannes, he sent a much simpler gcc5 patch a few days ago.
> https://lkml.org/lkml/2014/8/26/710

That approach won't last for long - as soon as we add some
gcc5-specific thing, we'll need a new file.

Let history be a guide:

diff -u include/linux/compiler-gcc3.h include/linux/compiler-gcc4.h
