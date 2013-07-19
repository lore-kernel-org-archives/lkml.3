Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3GSXQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:16:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3GSXQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:16:23 -0400
Date: Fri, 19 Jul 2013 16:16:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module
 dependency.
Message-ID: <20130719231630.GC1701@kroah.com>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp>
 <2493652.fjZLqTL8IF@vostro.rjw.lan>
 <1374257329.22432.382.camel@schen9-DESK>
 <4295105.1txhDL4OOg@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4295105.1txhDL4OOg@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 11:38:04PM +0200, Rafael J. Wysocki wrote:
> Alas, this is not the one I'd like to apply.
> 
> With that patch applied, new device objects are created to avoid binding the
> processor driver directly to the cpu system device objects, because that
> apparently confuses udev and it starts to ignore the cpu modalias once the
> driver has been bound to any of those objects.
> 
> I've verified in the meantime that this indeed is the case.
> 
> A link to the patch in question: https://patchwork.kernel.org/patch/2830561/
> 
> Greg, I asked you some time ago whether or not it was possible for udev to stop
> autoloading modules that matched the cpu modalias after a driver had been bound
> to the cpu system device objects and you said "no".  However, this time I can
> say with certainty that that really is the case.  So, the question now is
> whether or not we can do anything in the kernel to avoid that confusion in udev
> instead of applying the patch linked above (which is beyond ugly in my not so
> humble opinion)?

udev isn't doing any module loading, 'modprobe' is just being called for
any new module alias that shows up in the system, and all of the drivers
that match it then get loaded.

How is it a problem if a module is attempted to be loaded that is
already loaded?  How is it a problem if a different module is loaded for
a device already bound to a driver?  Both of those should be total
"no-ops" for the kernel.

But, I don't know anything about the cpu code, how is loading a module
causing problems?  That sounds like it needs to be fixes, as any root
user can load modules whenever they want, you can't protect the kernel
from doing that.

thanks,

greg k-h
