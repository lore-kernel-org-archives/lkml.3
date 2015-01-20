Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbbATVBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:01:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbbATVBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:01:42 -0500
Date: Wed, 21 Jan 2015 03:51:57 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-kernel@vger.kernel.org, kernel <kernel@savoirfairelinux.com>
Subject: Re: [PATCH 2/3] sysfs: Only accept read/write permissions for file
 attributes
Message-ID: <20150120195157.GA10864@kroah.com>
References: <54BDC087.4010906@roeck-us.net>
 <1272429736.105015.1421768641283.JavaMail.root@mail>
 <20150120171312.GA24203@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120171312.GA24203@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 09:13:12AM -0800, Guenter Roeck wrote:
> On Tue, Jan 20, 2015 at 10:44:01AM -0500, Vivien Didelot wrote:
> > Hi Guenter,
> > 
> [ ... ]
> > 
> > > Anyway, my goal was to keep things simple. Taking some bits from the default
> > > and others from the return value of the is_visible function isn't simple,
> > > even more so since your code would require the is_visible function to mask
> > > out SYSFS_PREALLOC to avoid the warning.
> > 
> > While I'm still not sure about the consequences of flipping this SYSFS_PREALLOC
> > bit at runtime, I do agree with your goal.
> > 
> > Then to keep it simple, the scope of is_visible could be limited to any bit
> > allowed at attribute declaration (using *_ATTR* macros). The compile-time check
> > macro VERIFY_OCTAL_PERMISSIONS() allows any bit but S_IWOTH. The scope can be
> > SYSFS_PREALLOC | 0775. (or 0664 if we want to avoid executables as well.)
> > 
> > [ This will prevent some follow-up patches "avoid world-writable sysfs files".
> > In the future, we may want a runtime equivalent of VERIFY_OCTAL_PERMISSIONS. ]
> > 
> 0775 and 0664 are both fine with me, with a preference for 0664. Before I
> resubmit - Greg, any preference from your side ?

I don't have the time to look at them this week, so feel free to fix up
what you know about and resend and I will get to them as soon as I can.

thanks,

greg k-h
