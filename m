Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3JaWnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 18:43:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab3JaWnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 18:43:13 -0400
Date: Thu, 31 Oct 2013 15:43:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] scripts/kallsyms: filter symbols not in kernel address
 space
Message-Id: <20131031154311.e65d16d79ba540ced736413b@linux-foundation.org>
In-Reply-To: <1382975339-25831-1-git-send-email-tom.leiming@gmail.com>
References: <1382975339-25831-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct 2013 23:48:59 +0800 Ming Lei <tom.leiming@gmail.com> wrote:

> This patch uses CONFIG_PAGE_OFFSET to filter symbols which
> are not in kernel address space because these symbols are
> generally for generating code purpose and can't be run at
> kernel mode, so we needn't keep them in /proc/kallsyms.
> 
> For example, on ARM there are some symbols which are
> linked in relocatable code section, then perf can't parse
> symbols any more from /proc/kallsyms, and this patch fixes
> the problem.

This is a non-back-compatible change and I'd like to see a much
stronger assurance that it is safe to merge and will not break any
existing application on the planet, please.

For a start, please describe with great precision what these excluded
symbols are (examples would help) and explain why no application will
conceivably have had any use for them.

