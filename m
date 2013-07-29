Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab3G2GlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 02:41:21 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:60921 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3G2GlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 02:41:20 -0400
Date: Mon, 29 Jul 2013 02:41:08 -0400
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Kees Cook <keescook@chromium.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, dholsgrove@xilinx.com,
        Al Viro <viro@ZenIV.linux.org.uk>, microblaze-uclinux@itee.uq.edu.au,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [microblaze-linux] [RESEND PATCH v2] microblaze: Fix clone
 syscall
Message-ID: <20130729064108.GF4284@brightrain.aerifal.cx>
References: <3fe61cc5f884f9367214b045da6b83f15c4101ec.1375078947.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fe61cc5f884f9367214b045da6b83f15c4101ec.1375078947.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: Rich Felker <dalias@aerifal.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 08:22:56AM +0200, Michal Simek wrote:
> Microblaze was assign to CLONE_BACKWARDS type where
> parent tid was passed via 3rd argument.
> Microblaze glibc is using 4th argument for it.
> 
> Create new CLONE_BACKWARDS3 type where stack_size is passed
> via 3rd argument, parent thread id pointer via 4th,
> child thread id pointer via 5th and tls value as 6th
> argument
> 
> Inconsistency was introduced by this patch:
> "microblaze: switch to generic fork/vfork/clone"
> (sha1: f3268edbe6fe0ce56e62c6d6b14640aeb04864b7)

I still don't think this is clear. I would suggest language like:

==
Fix inadvertent breakage in the clone syscall ABI for Microblaze
that was introduced in this patch:

    "microblaze: switch to generic fork/vfork/clone"
    (sha1: f3268edbe6fe0ce56e62c6d6b14640aeb04864b7)

The Microblaze syscall ABI for clone takes the parent tid address in
the 4th argument; the third argument slot is used for the stack size.
The incorrectly-used CLONE_BACKWARDS type assigned parent tid to the
3rd slot.

This commit restores the original ABI so that existing userspace libc
code will work correctly.
==

And maybe add something about which versions were affected by the
breakage.

Rich
