Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3J3Woq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:44:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3J3Wop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:44:45 -0400
Date: Wed, 30 Oct 2013 15:44:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: WTF: driver-core-next contains recursive directory removal!
Message-ID: <20131030224444.GA9092@kroah.com>
References: <8761sexu2l.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761sexu2l.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 03:38:58PM -0700, Eric W. Biederman wrote:
> 
> Greg what is  going on?  I just looked and Tejuns ill-conceived recursive
> directory deletion code has been merged into your driver-core-next tree.
> 
> That code is semantically broken.  I reviewed it and I gave the reasons
> why it was wrong.  You came up to me and mentioned at LPC that you
> agreed with my reasons.  And yet I just looked in driver-core-next and
> there the code is in all of it's broken glory.

Because I tested it out, and there were no such problems.

> Please pull out that crap it has no business ever going into a stable
> kernel.

Really?  It seems to survive my testing here just fine.

> The short version is unless someone has drastically changed pci hotplug
> since last time I looked the code is dramatically wrong as pci hotplug
> removes directories in the wrong order remove the parent first.

That should still work here, and I'm pretty sure I tested it, but will
do so before I send it to Linus.

I don't think there's an issue here, otherwise both Tejun and I would
have found some issues during testing, same for all of the other
linux-next users for the past few weeks.

thanks,

greg k-h
