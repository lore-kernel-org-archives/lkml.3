Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955Ab3DGP3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 11:29:39 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46267 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933901Ab3DGP3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 11:29:36 -0400
Date: Sun, 7 Apr 2013 08:29:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Huacai Chen <chenhc@lemote.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, stable@vger.kernel.org
Subject: Re: [PATCH] PM/reboot: call syscore_shutdown() after
 disable_nonboot_cpus()
Message-ID: <20130407152932.GA18032@kroah.com>
References: <1365300854-3133-1-git-send-email-chenhc@lemote.com>
 <3513307.9cks2gqsZt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3513307.9cks2gqsZt@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 07, 2013 at 10:46:00AM +0200, Rafael J. Wysocki wrote:
> On Sunday, April 07, 2013 10:14:14 AM Huacai Chen wrote:
> > As commit 40dc166c (PM / Core: Introduce struct syscore_ops for core
> > subsystems PM) say, syscore_ops operations should be carried with one
> > CPU on-line and interrupts disabled. However, after commit f96972f2d
> > (kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()),
> > syscore_shutdown() is called before disable_nonboot_cpus(), so break
> > the rules. We have a MIPS machine with a 8259A PIC, and there is an
> > external timer (HPET) linked at 8259A. Since 8259A has been shutdown
> > too early (by syscore_shutdown()), disable_nonboot_cpus() runs without
> > timer interrupt, so it hangs and reboot fails. This patch call
> > syscore_shutdown() a little later (after disable_nonboot_cpus()) to
> > avoid reboot failure, this is the same way as poweroff does.
> > 
> > BTW, add disable_nonboot_cpus() in kernel_halt() for consistency.
> > 
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > Cc: <stable@vger.kernel.org>
> 
> While I agree with the changes, I'm not sure if I'm the right maintainer,
> as this isn't really PM code.
> 
> Andrew, should I take this?

Andrew is on vacation for a few weeks, so you might need to take this
through your tree.

greg k-h
