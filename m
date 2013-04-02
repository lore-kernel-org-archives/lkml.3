Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab3DBXsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:48:11 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58772 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3DBXsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:48:09 -0400
Date: Tue, 2 Apr 2013 16:48:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 1/1] Introduce Intel RAPL cooling device driver
Message-ID: <20130402234805.GA11880@kroah.com>
References: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
 <20130402230042.GA8713@kroah.com>
 <20130402163357.72dac902@chromoly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402163357.72dac902@chromoly>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 04:33:57PM -0700, Jacob Pan wrote:
> On Tue, 2 Apr 2013 16:00:42 -0700
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > > +#include "intel_rapl.h"
> > > +#include "../../../fs/sysfs/sysfs.h"  
> > 
> > WTF?
> > 
> > Oh, that's a sure sign you are not doing something properly, if you
> > think it's ok to muck around with the internals of sysfs.
> > 
> > There's a reason that file is "private", why do you think it's ok to
> > use it directly?  Did you just think that I somehow "forgot" to put
> > it in the proper include directory?
> I did feel unsure about this but i saw some precedence in the kernel.

Someone else is doing this with the sysfs api?  I don't see any other
code in Linus's tree doing this at the moment, where did you see this?
Let me know and I'll fix it up right away.

> Anyway, I needed a way to validate a userspace file passed to rapl
> driver belong to the same sysfs directory. I will look for alternative
> ways.

What do you mean by this?  What exactly are you trying to do?  No normal
driver code should _ever_ call sysfs functions directly, nor should they
ever care about sysfs internals.

And, odds are, you didn't test your code as a module, right, as any
internal sysfs function that you could get from this .h file, wouldn't
be exported for a module to use, unless I missed one somewhere?

greg k-h
