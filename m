Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3AQSlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:41:17 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60304 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab3AQSlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:41:15 -0500
Date: Thu, 17 Jan 2013 10:41:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Tomas Hozza <thozza@redhat.com>, olaf@aepfle.de, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, apw@canonical.com,
        devel@linuxdriverproject.org
Subject: Re: [PATCH 1/3] tools/hv: Fix for long file names from readdir
Message-ID: <20130117184106.GA27974@kroah.com>
References: <1628506728.5754343.1355817969825.JavaMail.root@redhat.com>
 <1355834283.18807.227.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355834283.18807.227.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 12:38:03PM +0000, Ben Hutchings wrote:
> On Tue, 2012-12-18 at 03:06 -0500, Tomas Hozza wrote:
> > ----- Original Message -----
> > > > This is just for sanity. The value PATH_MAX was chosen after
> > > > discussion
> > > > with K. Y. Srinivasan and Olaf Hering instead of some "magic"
> > > > number like
> > > > 256 or 512.
> > > 
> > > PATH_MAX is a magic name.
> > 
> > It is defined in "limits.h". I would welcome some more constructive
> > argumentation and critics.
> 
> It still bears no relation to any actual limit in the C library or Linux
> kernel.  So it's no more valid than the previous number.
> 
> In the current context we're enumerating /sys/class/net and we know that
> all the interface names in there are limited to IFNAMSIZ-1 = 15 (there
> is also potentially "bonding_masters").  The longest path name we need
> to use is definitely much shorter than even 256 bytes.
> 
> > > > > Using snprintf() is a good idea, but you need to check the return
> > > > > value and handle the truncation case somehow.
> > > > 
> > > > By using PATH_MAX sized buffer there is no need for handling the
> > > > truncation
> > > > case.
> > >  
> > > You are claiming two contradictory things: sprintf() may overrun the
> > > buffer, so we need the length check provided by snprintf(), but there
> > > is no need to check for truncation because we know the length is
> > > sufficient.
> > 
> > So what do you propose? How should it be solved?
> 
> 	if (snprintf(dev_id, sizeof(dev_id), ...) >= sizeof(dev_id))
> 		continue;
> 
> Possibly logging a warning.

I agree, I'm dropping this patch from my to-apply queue.

greg k-h
