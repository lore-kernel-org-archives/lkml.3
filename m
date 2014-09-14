Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaINRjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:39:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbaINRjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:39:20 -0400
Date: Sun, 14 Sep 2014 10:39:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: mmarek@suse.cz, arnd@arndb.de, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        grant.likely@secretlab.ca, ebiederm@xmission.com,
        akpm@linux-foundation.org, ktkhai@parallels.com, sam@ravnborg.org
Subject: Re: [PATCH 0/3] Implement /proc/built-in file similar to
 /proc/modules
Message-ID: <20140914173919.GA10059@kroah.com>
References: <20140914100545.3745.23394.stgit@localhost>
 <20140914153832.GC4064@kroah.com>
 <5415D10E.90809@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5415D10E.90809@yandex.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 09:31:58PM +0400, Kirill Tkhai wrote:
> On 14.09.2014 19:38, Greg KH wrote:
> > On Sun, Sep 14, 2014 at 02:18:13PM +0400, Kirill Tkhai wrote:
> >> This series implements a possibility to show the list of built-in drivers
> >> to userspace. The names of drivers will be the same as when they are modules.
> > 
> > Have you looked at /sys/modules/ ?  Doesn't that show what you want
> > here?
> 
> There are only the drivers in "/sys/module" which have parameters.
> Drivers without parameters do not appear there.

Ah, didn't realize that.  Should be easy to fix though, if you really
wanted to list the modules.  Much better than a random proc file that
you have to parse :)

> >> So, if your system has "loop" driver then it appears either in /proc/modules
> >> or in /proc/built-in and userspace will be able to know about this.
> >>
> >> Now this is impossible. The only way to get kernel configuration is
> >> /proc/config.gz, but CONFIG_* names can change from time to time. Module
> >> names are more or less standardized.
> > 
> > Module names aren't "standardized", we change them at times when needed,
> > just like CONFIG_ names.
> > 
> > What is your end goal here?  As you say, config.gz is the real kernel
> > configuration, just having a list of modules built in isn't going to
> > help much in getting a working kernel config without it.
> 
> It looks like userspace applications oriented on modules names rather
> than on CONFIG_XXX parameters. /proc/config.gz is optional and userspace
> applications can't base on it.
> 
> For example, when I compile "loop" module built-in and "loop" is in
> /etc/modules, init script warns about this module is not present and
> can't be autoloaded. The script does not store CONFIG_XXX <-> module_xxx
> conformity. And nobody stores it.
> 
> When iptables wants extra functionality, it requests a module. Etc.
> 
> Nobody is oriented on CONFIG_XXX parameters. It would be simple for
> userspace to add a support of /proc/built-in analysing. It's very
> similar to /proc/modules.

Shouldn't userspace focus on the functionality a module provides, not
the module name itself?  Can't a test for the loop "module" just test to
see if the loop control device is present?  Same for iptables (there's
modprobe rules for iptable modules I think...)

In other words, don't focus on the module names, focus on the userspace
function a module provides, there should always be a way to check that
at run time (if not, then the module doesn't actually do much...)

thanks,

greg k-h
