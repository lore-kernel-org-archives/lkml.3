Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab3GXHAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:00:24 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:60734 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3GXHAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:00:22 -0400
Date: Wed, 24 Jul 2013 02:59:57 -0400
From: Rich Felker <dalias@aerifal.cx>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Hogan <james.hogan@imgtec.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, dholsgrove@xilinx.com,
        Al Viro <viro@ZenIV.linux.org.uk>, microblaze-uclinux@itee.uq.edu.au,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [microblaze-linux] [RESEND PATCH] microblaze: Fix clone syscall
Message-ID: <20130724065957.GR3249@brightrain.aerifal.cx>
References: <080727f78ba62f457320b766234f27eff248fa67.1374644031.git.michal.simek@xilinx.com>
 <20130724055518.GQ3249@brightrain.aerifal.cx>
 <51EF78BB.8000503@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EF78BB.8000503@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 08:48:27AM +0200, Michal Simek wrote:
> >> Create new CLONE_BACKWARDS3 type where stack_size is passed
> >> via 3rd argument, parent thread id pointer via 4th,
> >> child thread id pointer via 5th and tls value as 6th
> >> argument
> > 
> > I believe this also affects us in musl. What is the motivation for
> > making a configure option that results in there being two incompatible
> > syscall ABIs for the same arch?
> > This sounds like a really bad idea...
> 
> This patch fixes bug which was introduced by Al's patch where he moved
> clone implementation from microblaze folder to generic location.
> It means I am not creating two incompatible syscalls ABIs but fixing
> broken one.

So this patch is just fixing a regression in the kernel?

> > And how was glibc successfuly using a form that mismatched the
> > existing kernel? Did nobody ever use/test it?
> 
> We are running LTP syscall tests and there is not LTP test which
> was able to find out this mismatch in clone. That's why I haven't
> figure it out at that time and ACKed that origin patch.

I would think pthread_create would have broken pretty badly; I
remember early-on in porting musl to microblaze, we had the clone
arguments misordered, and it blew up badly. ;) Perhaps you could just
run some general libc/libpthread level tests to catch things like this
that are hard to measure at the syscall-test level with existing
tests.

Rich
