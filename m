Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935640Ab3DHSZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:25:57 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34593 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935445Ab3DHSZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:25:30 -0400
Date: Mon, 8 Apr 2013 11:25:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
Message-ID: <20130408182527.GB12889@kroah.com>
References: <20130406165600.GA29660@kroah.com>
 <1365444853.18069.51@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365444853.18069.51@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 01:14:13PM -0500, Rob Landley wrote:
> On 04/06/2013 11:56:00 AM, Greg KH wrote:
> >From: Kay Sievers <kay@vrfy.org>
> >
> >Some drivers want to tell userspace what uid and gid should be
> >used for
> >their device nodes, so allow that information to percolate through the
> >driver core to userspace in order to make this happen.  This means
> >that
> >some systems (i.e.  Android and friends) will not need to even run a
> >udev-like daemon for their device node manager and can just rely in
> >devtmpfs fully, reducing their footprint even more.
> 
> Wasn't the entire "devfsd" saga because this was policy and didn't
> belong in kernel space?

devfs did a number of things "wrong", not the least being it set a
naming policy that was non-standard, and it had unfixable race conditons
in it.

> I guess it's not policy if Android wants it?
> It's just The One True Way?

Don't be facetious please.

> Or is this because containers allow UID/GID to be redefined, and
> thus imposing magic values on userspace can now be mapped away or
> something?

I don't understand, what do you mean by this?

greg k-h
