Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaINS4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 14:56:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaINS4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 14:56:32 -0400
Date: Sun, 14 Sep 2014 11:56:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: mmarek@suse.cz, arnd@arndb.de, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        grant.likely@secretlab.ca, ebiederm@xmission.com,
        akpm@linux-foundation.org, ktkhai@parallels.com, sam@ravnborg.org
Subject: Re: [PATCH 0/3] Implement /proc/built-in file similar to
 /proc/modules
Message-ID: <20140914185631.GB18506@kroah.com>
References: <20140914100545.3745.23394.stgit@localhost>
 <20140914153832.GC4064@kroah.com>
 <5415D10E.90809@yandex.ru>
 <20140914173919.GA10059@kroah.com>
 <5415D8FA.8040305@yandex.ru>
 <20140914181353.GA12497@kroah.com>
 <5415E00E.1000706@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5415E00E.1000706@yandex.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 10:35:58PM +0400, Kirill Tkhai wrote:
> On 14.09.2014 22:13, Greg KH wrote:
> > On Sun, Sep 14, 2014 at 10:05:46PM +0400, Kirill Tkhai wrote:
> >> On 14.09.2014 21:39, Greg KH wrote:
> >>> On Sun, Sep 14, 2014 at 09:31:58PM +0400, Kirill Tkhai wrote:
> >>>> On 14.09.2014 19:38, Greg KH wrote:
> >>>>> On Sun, Sep 14, 2014 at 02:18:13PM +0400, Kirill Tkhai wrote:
> >>>>>> This series implements a possibility to show the list of built-in drivers
> >>>>>> to userspace. The names of drivers will be the same as when they are modules.
> >>>>>
> >>>>> Have you looked at /sys/modules/ ?  Doesn't that show what you want
> >>>>> here?
> >>>>
> >>>> There are only the drivers in "/sys/module" which have parameters.
> >>>> Drivers without parameters do not appear there.
> >>>
> >>> Ah, didn't realize that.  Should be easy to fix though, if you really
> >>> wanted to list the modules.  Much better than a random proc file that
> >>> you have to parse :)
> >>
> >> But it looks like one file is better than many new directories.
> > 
> > Why?
> 
> It's just an unification with /proc/modules. Why should we do any
> difference between external and built-in modules? It's the same,
> it's similar, it's better to parse when they can be shown similar.

/proc/modules is for loaded modules, and it includes lots of information
that tools rely on.  It is also a very old file, no new
non-process-related proc/ files should be created anymore.  It's been
that way since sysfs was created (and one of the reasons for sysfs.)

> > No, they want the functionality that a module provides, not the module
> > name, or some random configuation option.
> > 
> > It seems like you are trying to solve a problem that isn't there.  What
> > program is broken right now that this new proc file (or sysfs directory)
> > would fix?
> 
> The initial reason was I'm building custom kernels for more than 10
> years (not so long, I agree), and every boot I see a big list of modules
> from distribution /etc/module, which can't be autoloaded. I prefer to
> build drivers in kernel. I tried to find is there a way for userspace to
> understand that a module are present, but there is no a way. So this is
> a reason.

I don't understand, my distro doesn't have any modules listed in
/etc/module that aren't autoloaded, perhaps you should work with your
distro on that :)

And how would these patches remove those config files?

Again, focus on kernel functionality, not module names or config
options, and you should be fine.

thanks,

greg k-h
