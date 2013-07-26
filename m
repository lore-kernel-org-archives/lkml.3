Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115Ab3GZXI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 19:08:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339Ab3GZXIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 19:08:54 -0400
Date: Fri, 26 Jul 2013 16:08:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: monstr@monstr.eu
Cc: Rich Felker <dalias@aerifal.cx>, Michal Simek <michal.simek@xilinx.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Hogan <james.hogan@imgtec.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, dholsgrove@xilinx.com,
        Al Viro <viro@ZenIV.linux.org.uk>, microblaze-uclinux@itee.uq.edu.au,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [microblaze-linux] [RESEND PATCH] microblaze: Fix clone syscall
Message-Id: <20130726160853.81f244ba08368e8cecab0c3b@linux-foundation.org>
In-Reply-To: <51EF78BB.8000503@monstr.eu>
References: <080727f78ba62f457320b766234f27eff248fa67.1374644031.git.michal.simek@xilinx.com>
	<20130724055518.GQ3249@brightrain.aerifal.cx>
	<51EF78BB.8000503@monstr.eu>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jul 2013 08:48:27 +0200 Michal Simek <monstr@monstr.eu> wrote:

> On 07/24/2013 07:55 AM, Rich Felker wrote:
> > On Wed, Jul 24, 2013 at 07:34:07AM +0200, Michal Simek wrote:
> >> Microblaze was assign to CLONE_BACKWARDS type where
> >> parent tid was passed via 3rd argument.
> >> Microblaze glibc is using 4th argument for it.
> >>
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

That's important information which was omitted from the changelog. 

Please identify the patch which casused this regression (SHA hash and
title), thanks.

