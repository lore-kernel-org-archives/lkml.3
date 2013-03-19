Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3CSAFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:05:42 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:47754 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab3CSAFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:05:40 -0400
Date: Mon, 18 Mar 2013 17:06:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Julius Werner <jwerner@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sameer Nanda <snanda@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>
Subject: Re: [PATCH] usb: Make USB persist default configurable
Message-ID: <20130319000656.GC6516@kroah.com>
References: <1363215451-26111-1-git-send-email-jwerner@chromium.org>
 <20130318230922.GA23175@kroah.com>
 <CAODwPW9c6NpDOzmh+q312qLn0fS+eQttQDGdCe0b2EigoJ9_PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAODwPW9c6NpDOzmh+q312qLn0fS+eQttQDGdCe0b2EigoJ9_PA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 05:02:19PM -0700, Julius Werner wrote:
> > Why can't you just revert this in userspace?  Isn't that easier than
> > doing a kernel patch and providing an option that we need to now
> > maintain for pretty much forever?
> 
> I could solve it in userspace, but that really feels like a hacky
> workaround and not a long term solution. It would mean that every new
> device starts with persist enabled and stays that way for a few
> milliseconds (maybe up to seconds if it's connected on boot), until
> userspace gets around to disable it again... opening the possibility
> for very weird race conditions and bugs with drivers/devices that
> don't work with persist.

What drivers/devices don't work with persist?  We need to know that now,
otherwise all other distros and users have problems, right?

> This default is a policy that really resides in the kernel, it has
> changed in the past, and since there is no definitive better choice
> for all cases I thought making it configurable is the right thing to
> do.

Too many options can be a bad thing.

I think Alan made this a "always on" option, so I'd like to get his
opinion on it.  Alan?

thanks,

greg k-h
