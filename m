Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbaAKAEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 19:04:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaAKAEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 19:04:32 -0500
Date: Fri, 10 Jan 2014 16:04:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: pavel@ucw.cz, joe@perches.com, keescook@chromium.org, geert@linux-m68k.org,
        jkosina@suse.cz, viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT format specifier
Message-Id: <20140110160430.526efb3ea91783fe8a32fec5@linux-foundation.org>
In-Reply-To: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
References: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jan 2014 21:52:00 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> This patch introduces %pT format specifier for printing task_struct->comm.
> Currently %pT does not provide consistency. I'm planning to change to use RCU
> in the future. By using RCU, the comm name read from task_struct->comm will be
> guaranteed to be consistent. But before modifying set_task_comm() to use RCU,
> we need to kill direct ->comm users who do not use get_task_comm().

On reflection...

It isn't obvious that this patch is sufficiently beneficial until we
have that RCU code in place.

So I could retain this patch in -mm until we have that all sorted out. 
And I'll have to avoid merging %pT users into mainline in the
meanwhile!

Am I wrong?  The patch seems fairly pointless as a standalone thing?
