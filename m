Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3ILWnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:43:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab3ILWnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:43:02 -0400
Date: Thu, 12 Sep 2013 15:43:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Tom Gundersen <teg@jklm.no>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG?] staging: zram: Add auto loading of module if user opens
 /dev/zram.
Message-ID: <20130912224301.GA21415@kroah.com>
References: <CAG-2HqWaoovz+-pY2JnA4BSTULa4Hq=_5Oy4hzWOdQbrkijQKw@mail.gmail.com>
 <CAPXgP11XKqsQB96t=NPB1sQT5ppxUOnz4FZyFtXsE0PyF2jArA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP11XKqsQB96t=NPB1sQT5ppxUOnz4FZyFtXsE0PyF2jArA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 06:41:48PM +0200, Kay Sievers wrote:
> On Mon, Sep 9, 2013 at 5:58 PM, Tom Gundersen <teg@jklm.no> wrote:
> > Hi Konrad,
> >
> > The above commit (c70bda9 in mainline) doesn't appear to work for me.
> > I.e., depmod does not create an entry in modules.devname and hence no
> > device node is created on boot.
> >
> > If I understand correctly, you'd also need to create the correct
> > "char-major-<MAJOR>-<MINOR>" alias. But I don't really see how this is
> > meant to work as I thought zram only created /dev/zramX type device
> > nodes, and not /dev/zram, or am I missing something?
> 
> Please just remove it. "devname" is meant to be used for
> single-instance devices with a static dev_t, never for things like
> zramX.
> 
> It will not do anything useful here, it does nothing really without a
> statically assigned dev_t, and it should not be used for devices of
> this kind anyway.

I'll revert this after 3.12-rc1 is out, thanks,

greg k-h
