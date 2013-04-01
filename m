Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab3DAWR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:17:26 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53000 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab3DAWRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:17:25 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 1 Apr 2013 15:17:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andy King <acking@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH] misc/vmw_vmci: VMWARE_VMCI depends on NET
Message-ID: <20130401221730.GA28799@roeck-us.net>
References: <1364791439-28396-1-git-send-email-linux@roeck-us.net>
 <20130401192939.GA31983@kroah.com>
 <20130401200235.GA14969@roeck-us.net>
 <20130401201152.GA29283@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401201152.GA29283@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 01:11:52PM -0700, Greg Kroah-Hartman wrote:
> On Mon, Apr 01, 2013 at 01:02:35PM -0700, Guenter Roeck wrote:
> > On Mon, Apr 01, 2013 at 12:29:39PM -0700, Greg Kroah-Hartman wrote:
> > > On Sun, Mar 31, 2013 at 09:43:59PM -0700, Guenter Roeck wrote:
> > > > Fix:
> > > > 
> > > > ERROR: "memcpy_toiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
> > > > ERROR: "memcpy_fromiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
> > > > 
> > > > Both functions are defined in the core networking code.
> > > 
> > > This is already in linux-next, thanks.
> > > 
> > Uuh ... and I submitted it. Sorry for the noise.
> > 
> > Any chance to apply this to 3.9-rc ? It causes a bunch of unnecessary
> > nightly build errors for me.
> 
> As it's a configuration that no "real" user would ever hit, it's not
> really 3.9 material, sorry.
> 
Fair enough.

On the other side, value of "make randconfig" has been reduced significantly
compared to earlier times, when patches like this tended to be accepted into
release candidates. Until a few releases ago, "make randconfig" usually passed
at least for main targets by the time a kernel was relased. With this no longer
the case, fewer and fewer people will look into nightly or per-rc build results
and provide patches. This in turn will likely reduce reliability, as real
problems are more and more hidden among all the "unreal" build errors.
In addition to that, more and more people will end up with non-buildable
configurations and have to spend time trying to figure out why exactly
a build failed.

But maybe this is all my imagination, so feel free to just ignore my ranting ;).

Guenter
