Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaINPjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 11:39:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbaINPjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 11:39:21 -0400
Date: Sun, 14 Sep 2014 08:38:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: mmarek@suse.cz, arnd@arndb.de, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        grant.likely@secretlab.ca, ebiederm@xmission.com,
        akpm@linux-foundation.org, ktkhai@parallels.com, sam@ravnborg.org
Subject: Re: [PATCH 0/3] Implement /proc/built-in file similar to
 /proc/modules
Message-ID: <20140914153832.GC4064@kroah.com>
References: <20140914100545.3745.23394.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140914100545.3745.23394.stgit@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 02:18:13PM +0400, Kirill Tkhai wrote:
> This series implements a possibility to show the list of built-in drivers
> to userspace. The names of drivers will be the same as when they are modules.

Have you looked at /sys/modules/ ?  Doesn't that show what you want
here?

> So, if your system has "loop" driver then it appears either in /proc/modules
> or in /proc/built-in and userspace will be able to know about this.
> 
> Now this is impossible. The only way to get kernel configuration is
> /proc/config.gz, but CONFIG_* names can change from time to time. Module
> names are more or less standardized.

Module names aren't "standardized", we change them at times when needed,
just like CONFIG_ names.

What is your end goal here?  As you say, config.gz is the real kernel
configuration, just having a list of modules built in isn't going to
help much in getting a working kernel config without it.

thanks,

greg k-h
