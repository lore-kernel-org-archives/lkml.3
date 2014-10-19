Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaJSWCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:02:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaJSWCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:02:19 -0400
Date: Mon, 20 Oct 2014 06:01:13 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org, Linux API <linux-api@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Anup Patel <anup.patel@linaro.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Message-ID: <20141019220113.GA3780@kroah.com>
References: <20141016124741.GA3832@kroah.com>
 <CALAqxLU05D8qQA47E77PiuuN7eVt66WEq1qn+PqdE-tpEUzFpw@mail.gmail.com>
 <20141016231221.GA13592@kroah.com>
 <20141018223630.497988fa@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141018223630.497988fa@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 10:36:30PM +0100, One Thousand Gnomes wrote:
> > Do we really need someone to do more work that has been done on it in
> > the past as an official "maintainer"?  I'll be glad to do it, as I doubt
> > it will require any time at all.
> 
> Well every time in the past that Al Viro looked in its direction he broke
> it so probably. Someone is going to have to clean up or fix the fact it
> pokes around in the depths of the low level fd I/O code and calls stuff
> like __fd_install and __alloc_fd directly, or mend it if it breaks.

As it is, it is ok, but bad things happen if you allow more than one
process to open the device node.  In android systems, that doesn't
happen, so all should be acceptable.

> I'm curious what Al Viro thinks of it

His last comments were along the lines of "don't let anything open that
device node other than libbinder".

> > > Currently in the android space no one but libbinder should use the
> > > kernel interface.
> > 
> > That is correct.  If you do that, you deserve all of the pain and
> > suffering and rooted machines you will get.
> 
> So what is the Android side model for its security. That probably also
> should be described so nobody goes off and uses it for something like
> systemd because "it looked neat".

The side model is "one owner that knows what they are doing as they have
root privileges".  I don't know a way to codify that, and we all know no
one reads documentation...

> > But all of the changes will be in new code.  Be it kdbus, or something
> > else if that doesn't work out.  This existing binder.c file will not be
> > changing at all.  This existing ABI, and codebase, is something that we
> > have to maintain forever for those millions of devices out there in the
> > real world today. 
> 
> 95% of those devices are locked down, most of them have non replaceable
> batteries that will dead and irreplacable (sanely anyway) in 3-5 years.
> "Forever" in the phone world is mercifully rather short.

I still see brand new devices with 2 year old Android userspace being
shipped today.  With a total mis-mash of random kernel versions,
depending on what the SoC supported.  If we can delete this in 2-5
years, I would be really happy.

thanks,

greg k-h
