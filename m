Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab3AaWBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:01:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab3AaV7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:59:53 -0500
Date: Thu, 31 Jan 2013 13:59:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Hillf Danton <dhillf@gmail.com>, Benjamin LaHaise <bcrl@kvack.org>,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: next-20130117 - kernel BUG with aio
Message-Id: <20130131135952.77cf5d3a.akpm@linux-foundation.org>
In-Reply-To: <2553.1358890098@turing-police.cc.vt.edu>
References: <3544.1358774694@turing-police.cc.vt.edu>
	<CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com>
	<2553.1358890098@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013 16:28:18 -0500
Valdis.Kletnieks@vt.edu wrote:

> On Tue, 22 Jan 2013 21:43:27 +0800, Hillf Danton said:
> > On Mon, Jan 21, 2013 at 9:24 PM, Valdis Kletnieks
> > <Valdis.Kletnieks@vt.edu> wrote:
> > > Am seeing a reproducible BUG in the kernel with next-20130117
> > > whenever I fire up VirtualBox.  Unfortunately, I hadn't done that
> > > in a while, so the last 'known good' kernel was next-20121203.
> > >
> > > I'm strongly suspecting one of Kent Overstreet's 32 patches against aio,
> > > because 'git blame' shows those landing on Jan 12, and not much else
> > > happening to fs/aio.c in ages.
> > >
> > Take a try?
> > ---
> > --- a/fs/aio.c	Tue Jan 22 21:37:54 2013
> > +++ b/fs/aio.c	Tue Jan 22 21:43:58 2013
> > @@ -683,6 +683,9 @@ static inline void kioctx_ring_unlock(st
> >  {
> >  	struct aio_ring *ring;
> >
> > +	if (!ctx)
> > +		return;
> > +
> >  	smp_wmb();
> >  	/* make event visible before updating tail */
> 
> Well, things are improved - at least now it doesn't BUG :)
> 
> [  534.879083] ------------[ cut here ]------------
> [  534.879094] WARNING: at fs/aio.c:336 put_ioctx+0x1cb/0x252()
> [  534.879121] Call Trace:
> [  534.879129]  [<ffffffff8102f5ad>] warn_slowpath_common+0x7e/0x97
> [  534.879133]  [<ffffffff8102f5db>] warn_slowpath_null+0x15/0x17
> [  534.879137]  [<ffffffff811521f0>] put_ioctx+0x1cb/0x252
> [  534.879142]  [<ffffffff8105bee3>] ? __wake_up+0x3f/0x48
> [  534.879146]  [<ffffffff8115229e>] ? kill_ioctx_work+0x27/0x2b
> [  534.879150]  [<ffffffff811531a5>] sys_io_destroy+0x40/0x50
> [  534.879156]  [<ffffffff8161b112>] system_call_fastpath+0x16/0x1b
> [  534.879159] ---[ end trace a2c46a8bc9058404 ]---
> 
> Hopefully that tells you and Kent something. :)

Did this get fixed?
