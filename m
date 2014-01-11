Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaAKUrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 15:47:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaAKUrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 15:47:15 -0500
Date: Sat, 11 Jan 2014 12:48:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: kernel test robot <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [percpu_counter] WARNING: CPU: 1 PID: 1 at
 kernel/locking/lockdep.c:3537 check_flags()
Message-Id: <20140111124841.00cd5893.akpm@linux-foundation.org>
In-Reply-To: <CACVXFVNiOB3KE71kEJtEmi5GQ6QEUoftht308mvgsts8VCP5HQ@mail.gmail.com>
References: <20140111161404.GA7744@localhost>
	<CACVXFVNiOB3KE71kEJtEmi5GQ6QEUoftht308mvgsts8VCP5HQ@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jan 2014 00:36:07 +0800 Ming Lei <tom.leiming@gmail.com> wrote:

> >
> > [    8.093354] ------------[ cut here ]------------
> > [    8.095469] WARNING: CPU: 1 PID: 1 at kernel/locking/lockdep.c:3537 check_flags+0x77/0x1ba()
> > [    8.095469] DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)
> 
> The warning is caused by the added raw_local_irq_save(), which should
> have been local_irq_save(flags). Actually, it is a false positive.
> 
> Andrew, considered that your approach may be more efficient than this
> one since preempt_disable()/preempt_enable() can be removed too.
> 
> So could you prepare one patch for fixing the problem? Or if you are busy, I'd
> like to do it.

Yes, please send a fresh patch.
