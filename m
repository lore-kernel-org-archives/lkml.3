Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab3GAVx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:53:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3GAVx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:53:58 -0400
Date: Mon, 1 Jul 2013 14:53:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: cl@linux.com, glommer@parallels.com, penberg@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
Message-Id: <20130701145356.f9c43875890d1aec90fe1ad9@linux-foundation.org>
In-Reply-To: <201307020645.JGI86434.FFHOLOSFOtJVMQ@I-love.SAKURA.ne.jp>
References: <201305040915.AID02071.FHVQJtOFOMOLSF@I-love.SAKURA.ne.jp>
	<0000013e7a18153d-4b59eaf6-0fcd-4eec-b357-31d3d40baa7d-000000@email.amazonses.com>
	<201305071938.DAC81273.HOSJOFFOQLtMFV@I-love.SAKURA.ne.jp>
	<0000013e7f651028-9a57bc30-4148-4aba-a0e6-737b83bf2458-000000@email.amazonses.com>
	<20130701130903.61459f57f4ba31e282065001@linux-foundation.org>
	<201307020645.JGI86434.FFHOLOSFOtJVMQ@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jul 2013 06:45:27 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> 
> > I've read through the thread trying to work out what the end-user
> > impact of that fix is, but it's all clear as mud.  It's possible that
> > the end-user effect is `kernel locks up after printing "Booting the
> > kernel"'.  Or maybe not.
> > 
> > And if the above patch does indeed fix something significant, we might
> > need a -stable backport.
> > 
> 
> Somebody needs this patch when debugging with CONFIG_LOCKDEP=y on
> architectures with PAGE_SHIFT + MAX_ORDER > 26 .

Well *why* do they need it?  What happens without the patch?  How would
a person determine whether their kernel needs this patch?

When this patch crosses Greg's desk for -stable inclusion he's going to
wonder "why do users of -stable kernels need this", and you guys
haven't told him!

Grumble.  Why is it so hard to get a simple and decent changelog for
this patch?


Look, I'll make this easier:

: Subject: slab: fix init_lock_keys
: 
: In 3.10 kernels with CONFIG_LOCKDEP=y on architectures with
: PAGE_SHIFT + MAX_ORDER > 26 such as [architecture goes here], the kernel does
: [x] when the user does [y].
:
: init_lock_keys() goes too far in initializing values in kmalloc_caches
: because it assumed that the size of the kmalloc array goes up to
: MAX_ORDER.  However, the size of the kmalloc array for SLAB may be
: restricted due to increased page sizes or CONFIG_FORCE_MAX_ZONEORDER.
:
: Fix this by [z].


Please fill in the text within [].
