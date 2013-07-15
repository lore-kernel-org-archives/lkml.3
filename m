Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3GOAbe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 20:31:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3GOAbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 20:31:33 -0400
Date: Sun, 14 Jul 2013 17:32:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, abbotti@mev.co.uk, oliver@schinagl.nl,
        linux@roeck-us.net
Subject: Re: [PATCH v3 01/10] Driver core and sysfs changes for attribute
 groups
Message-ID: <20130715003232.GA25173@kroah.com>
References: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
 <20130715102700.33e848c5dba966d49e530bda@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715102700.33e848c5dba966d49e530bda@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 10:27:00AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Sun, 14 Jul 2013 16:05:50 -0700 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > Anyone else have a better name for this macro:
> > 	#define DEVICE_PATTR(_name)	&dev_attr_##_name.attr
> > that they can think of?  It will cut down on the typing done for
> > attribute lists.
> 
> Just one small peeve I have about all these places we do symbol pasting,
> is that it makes it impossible to find some things because grep complete
> fails us.  We type them once (often by cutting and pasting), but try to
> find them who knows how many times?
> 
> Just saying ...

Yeah, I know.  But realize that the dev_attr_##_name variable was
originally created with a:
	DEV_ATTR_RO(sysfs_file_name);
macro in the first place, so even trying to grep for dev_attr* brings up
nothing.  At least this way the grep would find the same thing, so it
does make a little bit sense in a way, right?

Or am I just trying to justify it as I'm tired of typing all that...

greg k-h
