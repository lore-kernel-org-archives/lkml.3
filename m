Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3LSQh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:37:27 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56531 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab3LSQhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:37:25 -0500
Date: Thu, 19 Dec 2013 08:37:20 -0800
From: josh@joshtriplett.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/7] drivers: usb: Include appropriate header file in
 hcd.h
Message-ID: <20131219163720.GB1658@cloud>
References: <026c3f34e6c26d5456940c28a0f33da96064e023.1387439261.git.rashika.kheria@gmail.com>
 <Pine.LNX.4.44L0.1312191043280.984-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.1312191043280.984-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 10:45:42AM -0500, Alan Stern wrote:
> On Thu, 19 Dec 2013, Rashika Kheria wrote:
> 
> > Include header file include/linux/usb.h in include/linux/usb/hcd.h
> > because structures usb_device, usb_host_config and usb_interface have
> > their definitions in include/linux/usb.h.
> > 
> > This eliminates the following warning in include/linux/usb/hcd.h:
> > include/linux/usb/hcd.h:311:44: warning: ‘struct usb_device’ declared inside parameter list [enabled by default]
> > include/linux/usb/hcd.h:412:10: warning: ‘struct usb_host_config’ declared inside parameter list [enabled by default]
> > include/linux/usb/hcd.h:614:9: warning: ‘struct usb_interface’ declared inside parameter list [enabled by default]
> 
> Where does this problem show up?
> 
> Any file that include linux/usb/hcd.h should include linux/usb.h first.  
> IMO it would be better to fix the source files that don't do the 
> includes properly.
> 
> Of course, people have varying opinions on this issue.  As far as I 
> know, there is no fixed policy in the kernel about nested includes.

True.  I personally prefer the policy of making all headers
self-contained, and then only including headers that define things used
in the source file.  That has the advantage of not including any
unnecessary headers if the dependencies shrink, and not requiring
changes to multiple source files if the dependencies grow.

Any particular objection to making the headers self-contained?

- Josh Triplett
