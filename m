Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3ALUzh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 15:55:37 -0500
Received: from mx.treblig.org ([80.68.94.177]:45258 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab3ALUzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 15:55:36 -0500
X-Greylist: delayed 1667 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jan 2013 15:55:35 EST
Date: Sat, 12 Jan 2013 20:27:47 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, dwalsh@redhat.com,
        dmalcolm@redhat.com
Subject: Re: Friendlier EPERM - Request for input
Message-ID: <20130112202747.GA13942@gallifrey>
References: <1357747463.2593.28.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357747463.2593.28.camel@localhost>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.36.4-kvm-i386-20110819 (i686)
X-Uptime: 20:20:43 up 313 days,  6:54,  1 user,  load average: 0.01, 0.02,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Paris (eparis@redhat.com) wrote:
> Getting an EPERM/EACCES in userspace really kinda blows.  As a user you
> don't have any idea why you got it.  It could be SELinux, it could be
> rwx bits on the file, it could be a missing capability, it could be an
> ACL, it could be who knows what.  We'd like to start figuring out the
> who knows what and hopefully find a way to expose that to userspace.  My
> initial thought is a small buffer in the task struct in which the kernel
> can dump some data when it is going to send back an EPERM.  I was
> thinking of exposing that data via a /proc/self/task/[tid]/file which
> userspace could poll after an EPERM.  The hope would be to all userspace
> a better understanding of why it failed.  Wouldn't it be nice if instead
> of httpd log just saying 'permission denied' it would be able to say
> 'permision denied because the file was 640"?

It's not just file access that's the problem (although with all the security
layers it's probably one of the more complex ones).

I've wasted way too much time trying to figure out why mmap (for example)
has given me an EINVAL; there are just too many holes you can fall into.

I've wondered in the past about using more bits of errno; making the
standard syscalls mask those out (when -ve), and making a new syscall that
returns the whole lot; that probably doesn't provide you enough for file
stuff though (unless it provided an index into your buffer?).  So that
shouldn't break an existing libc, but a new one would have a chance
at a better errno.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
