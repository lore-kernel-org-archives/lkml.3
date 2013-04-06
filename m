Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3DFR0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 13:26:17 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:44020 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3DFR0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 13:26:16 -0400
Date: Sat, 6 Apr 2013 10:26:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
Message-ID: <20130406172612.GA27809@kroah.com>
References: <20130406165600.GA29660@kroah.com>
 <20130406170952.GK4068@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130406170952.GK4068@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 06:09:52PM +0100, Al Viro wrote:
> On Sat, Apr 06, 2013 at 09:56:00AM -0700, Greg KH wrote:
> > From: Kay Sievers <kay@vrfy.org>
> > 
> > Some drivers want to tell userspace what uid and gid should be used for
> > their device nodes, so allow that information to percolate through the
> > driver core to userspace in order to make this happen.  This means that
> > some systems (i.e.  Android and friends) will not need to even run a
> > udev-like daemon for their device node manager and can just rely in
> > devtmpfs fully, reducing their footprint even more.
> 
> Excuse me, but "some drivers" have no fucking business to mess with
> uid and gid assignments in the first place...

Why not?  "closed" systems, like Android and other embedded systems,
have "assigned" uid and gid values that never change.  Right now they
have to have a horrible shell-script to set these values in devtmpfs
when the device shows up to the needed numbers.  This tiny patch gets
rid of that shell script entirely, allowing them to specify it from the
kernel as needed.

thanks,

greg k-h
