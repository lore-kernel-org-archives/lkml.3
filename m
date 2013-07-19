Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965390Ab3GSABW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 20:01:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab3GSABT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 20:01:19 -0400
Date: Thu, 18 Jul 2013 17:01:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, abbotti@mev.co.uk, oliver@schinagl.nl
Subject: Re: [PATCH v3 01/10] Driver core and sysfs changes for attribute
 groups
Message-ID: <20130719000127.GA716@kroah.com>
References: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
 <20130718235417.GA9538@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718235417.GA9538@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 04:54:17PM -0700, Guenter Roeck wrote:
> On Sun, Jul 14, 2013 at 04:05:50PM -0700, Greg Kroah-Hartman wrote:
> > Hi all,
> > 
> > Here is the third iteration of the patchset to add better attribute
> > group support to the driver core and sysfs.
> > 
> > Others have now tested it, and we got 3 more patches fixing a warning
> > that was showing up when binary attributes were in a group with no
> > "normal" attributes, and some more helper macros were added and cleaned
> > up.
> > 
> > I've booted this successfully against 3.11-rc1 with no problems (am
> > sending these from that machine.)
> > 
> > Ian, I didn't add a DEVICE_PATTR() macro yet, that can come later.  I
> > considered it, but that would also mean a BUS_PATTR() and the like, which I
> > guess works, but I hate even a _hint_ of "Hungarian" notation, which this
> > implies.
> > 
> > Anyone else have a better name for this macro:
> > 	#define DEVICE_PATTR(_name)	&dev_attr_##_name.attr
> > that they can think of?  It will cut down on the typing done for
> > attribute lists.
> > 
> > changes from v3:
> > 	- tested by Guenter
> > 	- patches from Oliver added
> > 	- refreshed on 3.11-rc1 (minor fuzz)
> > 	- Ian glanced at them.
> > 
> > changes from v2:
> > 	- actually boots
> > 	- 7th patch added properly
> > 	- added BUS_ATTR, CLASS_ATTR, and DRIVER_ATTR RW and RO macros
> > 	  to help with converting code to use attributes properly.
> > 
> Hi Greg,
> 
> thanks a lot for this series of patches, and for pushing it upstream.
> 
> Do you by any chance have a repository for the cleanup patches depending on this
> series ? It looks like a good area to get involved with when I am tired/annoyed
> by my other work, but I would not want to duplicate your work.

Give me a week or so to get them out, I have 1500+ "normal" patches to
wade through, and 150+ stable patches to deal with first.

But, if you want to look, I do keep my patches in a quilt series on
git.kernel.org in my patches.git repo, feel free to grab those to play
with.

thanks,

greg k-h
