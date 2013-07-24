Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab3GXGKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:10:12 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:60718 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3GXGKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:10:11 -0400
X-Greylist: delayed 883 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jul 2013 02:10:11 EDT
Date: Wed, 24 Jul 2013 01:55:19 -0400
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
Subject: Re: [microblaze-linux] [RESEND PATCH] microblaze: Fix clone syscall
Message-ID: <20130724055518.GQ3249@brightrain.aerifal.cx>
References: <080727f78ba62f457320b766234f27eff248fa67.1374644031.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <080727f78ba62f457320b766234f27eff248fa67.1374644031.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: Rich Felker <dalias@aerifal.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 07:34:07AM +0200, Michal Simek wrote:
> Microblaze was assign to CLONE_BACKWARDS type where
> parent tid was passed via 3rd argument.
> Microblaze glibc is using 4th argument for it.
> 
> Create new CLONE_BACKWARDS3 type where stack_size is passed
> via 3rd argument, parent thread id pointer via 4th,
> child thread id pointer via 5th and tls value as 6th
> argument

I believe this also affects us in musl. What is the motivation for
making a configure option that results in there being two incompatible
syscall ABIs for the same arch? This sounds like a really bad idea...
And how was glibc successfuly using a form that mismatched the
existing kernel? Did nobody ever use/test it? I think the broken
userspace software that was already failing to work due to this
mismatch should simply be fixed rather than adding incompatible kernel
ABI variants.

Rich
