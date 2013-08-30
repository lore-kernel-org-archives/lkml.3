Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3H3QjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:39:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154Ab3H3QjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:39:02 -0400
Date: Fri, 30 Aug 2013 18:37:33 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Kevin Hao <haokexin@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] jump_label: factor out the base part of jump_label.h
 to a separate file
Message-ID: <20130830163732.GA2353@hpx.cz>
References: <1377414952-15995-1-git-send-email-haokexin@gmail.com>
 <1377414952-15995-2-git-send-email-haokexin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377414952-15995-2-git-send-email-haokexin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-08-25 15:15+0800, Kevin Hao:
> We plan to use the jump label in the cpu/mmu feature check on ppc.
> This will need to include the jump_label.h in several very basic header
> files of ppc which seems to be included by most of the other head
> files implicitly or explicitly. But in the current jump_label.h,
> it also include the "linux/workqueue.h" and this will cause recursive
> inclusion. In order to fix this, we choose to factor out the base
> part of jump_label.h to a separate header file and we can include
> that file instead of jump_label.h to avoid the recursive inclusion.
> No functional change.

"linux/workqueue.h" was included because of deferred keys and they are
split into "linux/jump_label_ratelimit.h" to solve the same problem in
paravirt ticket spinlock series.
(still in -next: 851cf6e7 jump_label: Split jumplabel ratelimit)
