Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161620Ab3FUQvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:51:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161494Ab3FUQvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:51:43 -0400
Date: Fri, 21 Jun 2013 09:51:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: holt@sgi.com, travis@sgi.com, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org,
        akpm@linux-foundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
Message-ID: <20130621165142.GA32125@kroah.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 11:25:32AM -0500, Nathan Zimmer wrote:
> This rfc patch set delays initializing large sections of memory until we have
> started cpus.  This has the effect of reducing startup times on large memory
> systems.  On 16TB it can take over an hour to boot and most of that time
> is spent initializing memory.
> 
> We avoid that bottleneck by delaying initialization until after we have 
> started multiple cpus and can initialize in a multithreaded manner.
> This allows us to actually reduce boot time rather then just moving around
> the point of initialization.
> 
> Mike and I have worked on this set for a while, with him doing the most of the
> heavy lifting, and are eager for some feedback.

Why make this a config option at all, why not just always do this if the
memory size is larger than some specific number (like 8TB?)

Otherwise the distros will always enable this option, and having it be a
configuration choice doesn't make any sense.

thanks,

greg k-h
