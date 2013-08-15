Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab3HOQiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:38:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab3HOQit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:38:49 -0400
Date: Thu, 15 Aug 2013 09:40:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 35/36] hid: roccat: convert class code to use bin_attrs
 in groups
Message-ID: <20130815164024.GB15688@kroah.com>
References: <1376582626.2452.26.camel@neuromancer.tessier-ashpool>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376582626.2452.26.camel@neuromancer.tessier-ashpool>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 06:03:46PM +0200, Stefan Achatz wrote:
> Hello Greg,
> looking through the patch I found the following:
> 
> 
> 
> In hid-roccat-kone.c, PROFILE_ATTR macro:
> The line
>  .private = &profile_numbers[number],
> should read
>  .private = &profile_numbers[number-1],

Ah, ok, thanks, will fix up.

> Regarding the compiler warning about unused pyra_sysfs_write_settings:
> The attribute is indeed readwrite, but the code to write is not standard
> code. The read function was created with the PYRA_SYSFS_R macro and the
> write function was written manually. Used were both by
> PYRA_BIN_ATTRIBUTE_RW.
> In this case I would keep the PYRA_SYSFS_* macros standalone so that the
> calling code looks like this:
> 
> PYRA_SYSFS_W(control, CONTROL);
> PYRA_SYSFS_RW(info, INFO);
> PYRA_SYSFS_RW(profile_settings, PROFILE_SETTINGS);
> PYRA_SYSFS_RW(profile_buttons, PROFILE_BUTTONS);
> PYRA_SYSFS_R(settings, SETTINGS);
> 
> PYRA_BIN_ATTRIBUTE_W(control, CONTROL);
> PYRA_BIN_ATTRIBUTE_RW(info, INFO);
> PYRA_BIN_ATTRIBUTE_RW(profile_settings, PROFILE_SETTINGS);
> PYRA_BIN_ATTRIBUTE_RW(profile_buttons, PROFILE_BUTTONS);
> PYRA_BIN_ATTRIBUTE_RW(settings, SETTINGS);

Hm, I'll look this over again and see if I can make it better.

But why are you using a "non standard" write function?  What is special
here about this?

> Another thing: Why does nobody (besides me) use the get_maintainer.pl
> script, so I have to search manually for patches regarding my code?

I did use it:

$ ./scripts/get_maintainer.pl --file drivers/hid/hid-roccat-kone.c 
Jiri Kosina <jkosina@suse.cz> (maintainer:HID CORE LAYER)
linux-input@vger.kernel.org (open list:HID CORE LAYER)
linux-kernel@vger.kernel.org (open list)

You aren't listed there, perhaps a MAINTAINERS entry needs to be added?

thanks,

greg k-h
