Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3KACKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 22:10:40 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:40327 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3KACKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 22:10:38 -0400
MIME-Version: 1.0
In-Reply-To: <20131031154311.e65d16d79ba540ced736413b@linux-foundation.org>
References: <1382975339-25831-1-git-send-email-tom.leiming@gmail.com>
	<20131031154311.e65d16d79ba540ced736413b@linux-foundation.org>
Date: Fri, 1 Nov 2013 10:10:37 +0800
Message-ID: <CACVXFVMJmQJd0cFaZcmZZvFpUQUmTPJRj87QBVr0kbgZxjq8dw@mail.gmail.com>
Subject: Re: [PATCH] scripts/kallsyms: filter symbols not in kernel address space
From: Ming Lei <tom.leiming@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for your comment.

On Fri, Nov 1, 2013 at 6:43 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> For a start, please describe with great precision what these excluded
> symbols are (examples would help) and explain why no application will
> conceivably have had any use for them.

Looks Russell has given the example symbols already, and all these
symbols should be only for generating code, and they won't be run by
kernel since kernel can't run code which isn't in kernel virtual address
space, so there is no reason for application to use these symbols.

Actually, there is already report on the problem, see below link:

http://www.gossamer-threads.com/lists/linux/kernel/1808193?page=last

> OK.  Do you recall which patch that was?  And is it the case that this
> patch excludes only the symbols which that patch accidentally added?

This patch excludes all kernel symbols(non-module symbols) which
aren't in kernel virtual address space, I think it is reasonable and correct.


Thanks,
-- 
Ming Lei
