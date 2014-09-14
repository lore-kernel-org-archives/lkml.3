Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaINRaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:30:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbaINRaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:30:03 -0400
Date: Sun, 14 Sep 2014 19:27:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>, mmarek@suse.cz, arnd@arndb.de,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, ebiederm@xmission.com,
        akpm@linux-foundation.org, ktkhai@parallels.com, sam@ravnborg.org
Subject: Re: [PATCH 0/3] Implement /proc/built-in file similar to
	/proc/modules
Message-ID: <20140914172709.GA1569@redhat.com>
References: <20140914100545.3745.23394.stgit@localhost> <20140914153832.GC4064@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140914153832.GC4064@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14, Greg KH wrote:
>
> On Sun, Sep 14, 2014 at 02:18:13PM +0400, Kirill Tkhai wrote:
> > This series implements a possibility to show the list of built-in drivers
> > to userspace. The names of drivers will be the same as when they are modules.
>
> Have you looked at /sys/modules/ ?  Doesn't that show what you want
> here?

Well, /sys/module/ doesn't list the modules (drivers) compiled in. Say,
/sys/module/kernel. And it can't help a user to figure out that, say, the
loop driver is already "loaded" because CONFIG_BLK_DEV_LOOP=y.

> Module names aren't "standardized", we change them at times when needed,
> just like CONFIG_ names.

OK, but still the name will be the same, in /proc/modules or /proc/builtin.

> What is your end goal here?  As you say, config.gz is the real kernel
> configuration, just having a list of modules built in isn't going to
> help much in getting a working kernel config without it.

Perhaps you are right... but otoh perhaps this can can be useful anyway.
Again, a user can know about "insmod loop", but he can know nothing
about CONFIG_ names.

That said, I do not really understand 2/3. Not only I do not understand
this kbuild magic, I am not sure I understand what /proc/built-in will
actually show.

To me it would be better to change the "ifndef MODULE" version of
module_init() to add KBUILD_MODNAME into __builtin_drivers_list[].

Yes, module_init() is overused. Say, why does kernel/kprobes.c use
module_init() ? This looks confusing, this code can't be compiled as a
module. And it seems that it has a lot more users which should have used
__initcall() instead.

In short, I dunno ;)

Oleg.

