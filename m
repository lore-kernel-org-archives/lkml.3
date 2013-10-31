Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3JaRL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 13:11:26 -0400
Received: from mail-gg0-f173.google.com ([209.85.161.173]:39545 "EHLO
	mail-gg0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3JaRLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:11:24 -0400
Date: Thu, 31 Oct 2013 13:11:20 -0400
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH driver-core-next] sysfs: rename sysfs_assoc_lock and
 explain what it's about
Message-ID: <20131031171120.GD11698@mtj.dyndns.org>
References: <20131029220939.GA23060@kroah.com>
 <8761sflhi1.fsf@tw-ebiederman.twitter.com>
 <CA+55aFwaxAoezL6GAJzw=D+7E_Oxr2sqdxvM3sFgPiO-1eh5LQ@mail.gmail.com>
 <87sivj9vi0.fsf@xmission.com>
 <20131030132831.GB27632@htj.dyndns.org>
 <20131030142836.GC27632@htj.dyndns.org>
 <8761se1jfx.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761se1jfx.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

On Wed, Oct 30, 2013 at 03:29:38PM -0700, Eric W. Biederman wrote:
> Except every time sysfs exports a restriction like that and doesn't
> verify people have held up their end of it someone in the kernel
> inevitably gets the code wrong.  So I don't see how a big fat comment
> buried deep in the underlying abstractions that people use is going to
> make the code easier to understand or maintain.  It certainly won't
> prevent people from goofing up and with no warning.

The big fat comment is not meant for kobject users.  They have always
assumed the responsibility of not issuing conflicting operations
concurrently.  The comment explains the role of the lock so that a
person reading the code can understand what's going on as it is
confusing why the locking is necessary there when the caller is
supposed to be responsible.

Now, it's true that we *can* make kobject interface to allow multiple
concurrent operations and synchronize internally by generalizing the
locking.  Given how kobject is used, I'm not sure what that'd buy tho,
especially for removal.  Because removal puts the base ref as I wrote
before, it's an operation intrinsically reserved to the owner of the
object.  I'm pretty skeptical about its usefulness but if you think
it's worthwhile, please feel free to give it a shot.

Thanks.

-- 
tejun
