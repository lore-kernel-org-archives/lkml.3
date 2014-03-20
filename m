Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbaCTRN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:13:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:21701 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757087AbaCTRNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:13:55 -0400
Date: Thu, 20 Mar 2014 13:13:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jump label: constify lookup functions
Message-ID: <20140320131352.560df1dd@gandalf.local.home>
In-Reply-To: <53235B15.7070807@oracle.com>
References: <1390850839-24346-1-git-send-email-sasha.levin@oracle.com>
	<52FB7D96.2050100@oracle.com>
	<53235B15.7070807@oracle.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 15:40:05 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> ping?
> 
> On 02/12/2014 08:56 AM, Sasha Levin wrote:
> > ping?
> >
> > On 01/27/2014 02:27 PM, Sasha Levin wrote:
> >> Modify the parameters of all the lookup and the bookkeeping functions which
> >> should be const to const.
> >>
> >> For example, jump_label_text_reserved() doesn't modify the memory it works on,
> >> it just checks whether there are any jump labels there.
> >>
> >> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> >> ---
> >>   arch/arm/include/asm/jump_label.h     |  2 +-
> >>   arch/arm/kernel/jump_label.c          |  6 ++---
> >>   arch/arm64/include/asm/jump_label.h   |  2 +-
> >>   arch/arm64/kernel/jump_label.c        |  6 ++---
> >>   arch/mips/include/asm/jump_label.h    |  2 +-
> >>   arch/mips/kernel/jump_label.c         |  2 +-
> >>   arch/powerpc/include/asm/jump_label.h |  2 +-
> >>   arch/powerpc/kernel/jump_label.c      |  2 +-
> >>   arch/s390/include/asm/jump_label.h    |  2 +-
> >>   arch/s390/kernel/jump_label.c         | 12 ++++-----
> >>   arch/sparc/include/asm/jump_label.h   |  2 +-
> >>   arch/sparc/kernel/jump_label.c        |  2 +-
> >>   arch/x86/include/asm/jump_label.h     |  2 +-
> >>   arch/x86/include/asm/spinlock.h       |  2 +-
> >>   arch/x86/kernel/jump_label.c          |  6 ++---

The arch changes should be broken up per arch. They are not dependent
on each other, and they require being either acked by or pulled in by
the architecture maintainers.

> >>   include/linux/jump_label.h            | 27 ++++++++++----------
> >>   kernel/jump_label.c                   | 46 ++++++++++++++++++-----------------
> >>   17 files changed, 64 insertions(+), 61 deletions(-)

The jump label generic patch should also be by itself, and that I can
take.

-- Steve
