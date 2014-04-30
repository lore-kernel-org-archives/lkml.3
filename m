Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbaD3AkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:40:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53885 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaD3AkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:40:04 -0400
Date: Wed, 30 Apr 2014 00:40:00 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        Marian Marinov <mm@1h.com>, containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lxc-devel <lxc-devel@lists.sourceforge.net>
Subject: Re: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
Message-ID: <20140430004000.GC28969@ubuntumail>
References: <535FADDA.2070803@1h.com>
 <20140429183534.GB19325@thunk.org>
 <20140429185251.GA27969@ubuntumail>
 <53601E5B.5050004@1h.com>
 <20140429220234.GC28410@ubuntumail>
 <536026B3.1020905@1h.com>
 <20140429222913.GD28410@ubuntumail>
 <53602B84.1020304@mit.edu>
 <20140430001641.GA28969@ubuntumail>
 <20140430003236.GA6472@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430003236.GA6472@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Theodore Ts'o (tytso@mit.edu):
> On Wed, Apr 30, 2014 at 12:16:41AM +0000, Serge Hallyn wrote:
> > I forget the details, but there was another case where I wanted to
> > have the userns which 'owns' the whole fs available.  I guess we'd
> > have to check against that instead of using inode_capable.
> 
> Yes, that sounds right.
> 
> And *please* tell me that that under no circumstances can anyone other
> than root@init_user_ns is allowed to use mknod....

That's the case.  We've considered making exceptions for things like
/dev/null, but in practice bind-mounting devices from the host has
worked out just fine.
