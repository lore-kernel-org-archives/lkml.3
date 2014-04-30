Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbaD3AeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:34:06 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:58614 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaD3AeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:34:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140430003236.GA6472@thunk.org>
References: <535FADDA.2070803@1h.com> <20140429183534.GB19325@thunk.org>
 <20140429185251.GA27969@ubuntumail> <53601E5B.5050004@1h.com>
 <20140429220234.GC28410@ubuntumail> <536026B3.1020905@1h.com>
 <20140429222913.GD28410@ubuntumail> <53602B84.1020304@mit.edu>
 <20140430001641.GA28969@ubuntumail> <20140430003236.GA6472@thunk.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 29 Apr 2014 17:33:41 -0700
Message-ID: <CALCETrU4KXbwvfgtBo=fZ-=DGzgTkEVP0G=FhvJhdoo=+K1g6g@mail.gmail.com>
Subject: Re: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
To: "Theodore Ts'o" <tytso@mit.edu>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>, Marian Marinov <mm@1h.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lxc-devel <lxc-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 5:32 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Apr 30, 2014 at 12:16:41AM +0000, Serge Hallyn wrote:
>> I forget the details, but there was another case where I wanted to
>> have the userns which 'owns' the whole fs available.  I guess we'd
>> have to check against that instead of using inode_capable.
>
> Yes, that sounds right.
>
> And *please* tell me that that under no circumstances can anyone other
> than root@init_user_ns is allowed to use mknod....

I haven't read the code, but I tried it the other day, and I got
-EPERM.  So we're okay for now.  (Well, other than the issue I just
sent to security@kernel.org, but that's not quite the same thing.)

--Andy
