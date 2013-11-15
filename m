Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3KOUy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 15:54:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3KOUyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 15:54:51 -0500
Date: Sat, 16 Nov 2013 05:54:54 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 00/40] staging/lustre: patch bomb 1
Message-ID: <20131115205454.GA13144@kroah.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
 <20131115035918.GA11032@kroah.com>
 <CA+a=Yy5B9o4YUaSkW8sjhfBvn2Ma1J2gvPKWAbda9evR9=qDyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy5B9o4YUaSkW8sjhfBvn2Ma1J2gvPKWAbda9evR9=qDyg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 05:51:14PM +0800, Peng Tao wrote:
> On Fri, Nov 15, 2013 at 11:59 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > Some of the stuff here looks a lot like "new features / functionality"
> > to me, insead of just cleanups and fixes.
> >
> > Ideally, you all would only work on cleanups and getting this code out
> > of staging, and not add new things while it's sitting here.  But I know
> > that's going to be hard as you all are still working with an external
> > tree.
> >
> > That external tree is going to be tough to keep up over time, I
> > _strongly_ suggest you drop it as soon as possible and only use the
> > upstream tree.  Otherwise this whole thing really isn't going to work
> > out at all.
> >
> There are many users of the external tree so we cannot just abandon
> it, especially that the upstream client is not shipped in any
> distribution yet. Thanks for your understanding.

What is keeping people using that tree?  Support for older/distro
kernels?

Is it the fact that the server code isn't in the kernel?  Should that be
added now too so that we can get a proper view of what can and can not
be changed?  Some of your patches are showing that things are shared by
the two chunks of code, so does that mean if I delete things in the
client code that don't look to be used by anything, you will have
problems because the server now breaks?

I think it's time to just merge the server and deal with the whole thing
all at once, otherwise this dependancy on your external tree, and
external code to the kernel, is going to doom the ability to ever get
this code cleaned up and merged properly.

thanks,

greg k-h
