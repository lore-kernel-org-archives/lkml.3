Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab3DFR6G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 13:58:06 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:50703 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab3DFR6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 13:58:05 -0400
Date: Sat, 6 Apr 2013 10:58:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
Message-ID: <20130406175800.GA2033@kroah.com>
References: <20130406165600.GA29660@kroah.com>
 <20130406170952.GK4068@ZenIV.linux.org.uk>
 <20130406172612.GA27809@kroah.com>
 <20130406174512.GL4068@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130406174512.GL4068@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 06:45:12PM +0100, Al Viro wrote:
> On Sat, Apr 06, 2013 at 10:26:12AM -0700, Greg KH wrote:
> 
> > Why not?  "closed" systems, like Android and other embedded systems,
> > have "assigned" uid and gid values that never change.  Right now they
> > have to have a horrible shell-script to set these values in devtmpfs
> > when the device shows up to the needed numbers.  This tiny patch gets
> > rid of that shell script entirely, allowing them to specify it from the
> > kernel as needed.
> 
> What's to stop them from using static /dev?  Has an extra benefit of
> getting rid of devtmpfs shite completely...

True, it would, but they like using devtmpfs :)

This change also allows systems that have "control" devices to properly
be able to pass in the uid for the device they are creating, like rawctl
(which I know is "obsolete"), and probably dm and lvm.  I thought loop
devices might also want this, as they can now be created by normal
users, but I don't think that's needed for them.

thanks,

greg k-h
