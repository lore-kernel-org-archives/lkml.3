Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaBYXoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:44:30 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42791 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbaBYXo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:44:28 -0500
Message-ID: <1393371856.2886.2.camel@linux-whg8.site>
Subject: Re: [RFC PATCH for-next 2/4] epoll: epoll() syscall declaration
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Feb 2014 15:44:16 -0800
In-Reply-To: <20140225103013.GB9963@dcvr.yhbt.net>
References: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
	 <1393206162-18151-3-git-send-email-n1ght.4nd.d4y@gmail.com>
	 <20140224053232.GB7056@dcvr.yhbt.net>
	 <CAJ3m7BrjXvCOD_JpBHO7-ZuHFycr=GCrBiW2S1gfN4Ms-9h-Hw@mail.gmail.com>
	 <20140225103013.GB9963@dcvr.yhbt.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 10:30 +0000, Eric Wong wrote:
> Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com> wrote:
> > On Sun, Feb 23, 2014 at 9:32 PM, Eric Wong <normalperson@yhbt.net> wrote:
> > > Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com> wrote:
> > >> +asmlinkage long sys_epoll(int ep, struct epoll __user *in,
> > >> +                       unsigned int inc, struct epoll __user *out,
> > >> +                       unsigned int outc, int timeout);
> > >
> > > I can understand using the new struct for 'in', but 'out' could just be
> > > "struct epoll_event *" like sys_epoll_wait, right?
> > >
> > >>  asmlinkage long sys_epoll_wait(int epfd, struct epoll_event __user *events,
> > 
> > Yeah and I went back and forth on that, it just seemed to me that the
> > inconsistency could be confusing to others... maybe instead of defining a new
> > struct to begin with it might make me sense to just have an 'infd' array of file
> > descriptors in addition to an 'in' array of epoll_event struct
> > (obviously the length
> > of these would be identical).
> 
> I don't think a separate array for in is a good idea, too error prone
> and you lose locality.
> 
> For output, some users either end up allocating more memory/retrieve
> fewer items with the larger struct for *out.
Well having a different struct for input and output would be just as
error prone too, plus the file descriptor of a triggered event is
highly relevant information.

