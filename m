Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaGPW5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:57:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaGPW5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:57:43 -0400
Date: Wed, 16 Jul 2014 15:57:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Michalis Pappas <mpappas@fastmail.fm>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gdm72xx: conditionally compile debug code
Message-ID: <20140716225742.GA2983@kroah.com>
References: <1404219616-1788-1-git-send-email-mpappas@fastmail.fm>
 <1404219616-1788-2-git-send-email-mpappas@fastmail.fm>
 <20140709185142.GA13271@kroah.com>
 <53C6E332.2070301@fastmail.fm>
 <20140716205024.GA11078@kroah.com>
 <53C6F69A.5070108@fastmail.fm>
 <20140716221034.GB716@kroah.com>
 <1405550769.6381.17.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405550769.6381.17.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 03:46:09PM -0700, Joe Perches wrote:
> On Wed, 2014-07-16 at 15:10 -0700, Greg KH wrote:
> > On Wed, Jul 16, 2014 at 11:03:06PM +0100, Michalis Pappas wrote:
> []
> > > Ok, I agree on the ifdef stuff. My question was regarding your
> > > suggestion above to replace print_hex_debug() with dev_dbg()
> > 
> > You want the device name/id/label to show up as well, that is why you
> > should use the dev_dbg() version, print_hex_dump() does not take a
> > struct device *, so the user has no idea what device this data was
> > coming from.
> 
> But Michalis could alway add something like:
> 	dev_hex_dump()
> and
> 	dev_dbg_hex_dump()
> 

With the built-in "hex dump primitive" in printk(), why would you want
to do that?  You shouldn't be putting more than 64 bytes in a single
printk message in a hex dump, if you want to do more, use debugfs.

thanks,

greg k-h

