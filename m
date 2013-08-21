Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3HUV1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:27:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3HUV1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:27:24 -0400
Date: Wed, 21 Aug 2013 14:27:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, hare@suse.de,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/4 v6] Avoid softlockups in console_unlock()
Message-Id: <20130821142723.5fd8c0b0062b35ee83a68dcc@linux-foundation.org>
In-Reply-To: <1377072512-7986-1-git-send-email-jack@suse.cz>
References: <1377072512-7986-1-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 10:08:28 +0200 Jan Kara <jack@suse.cz> wrote:

> These patches avoid softlockups when a CPU gets caught in console_unlock() for
> a long time during heavy printing from other CPU. As is discussed in patch 3/4
> it isn't enough to just silence the watchdog because if CPU spends too long in
> console_unlock() also RCU will complain, other CPUs can be blocked waiting for
> printing CPU to process IPI, and even disk can be offlined because commands
> couldn't be delivered to it for too long.
> 
> This patch series solves the problem by stopping printing in console_unlock()
> after 1000 characters and the printing is postponed to irq work. To avoid
> hogging a single CPU (irq work gets processed on the same CPU where it was
> queued so it doesn't really help to reduce the printing load on that CPU) we
> introduce a new type of lazy irq work - IRQ_WORK_UNBOUND - which can be
> processed by any CPU.

I still hate the patchset :(

Remind us why we need this?  Whose kernel is spewing so much logging and why?
