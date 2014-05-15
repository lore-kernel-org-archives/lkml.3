Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbaEOXYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 19:24:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaEOXYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 19:24:14 -0400
Date: Thu, 15 May 2014 16:24:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        rdunlap@infradead.org, richard@nod.at, umgwanakikbuti@gmail.com
Subject: Re: [PATCH 2/2] sysrq,rcu: suppress RCU stall warnings while sysrq
 runs
Message-Id: <20140515162412.51355f308c34768ad08c0e2f@linux-foundation.org>
In-Reply-To: <1398794796-17464-3-git-send-email-riel@redhat.com>
References: <1398794796-17464-1-git-send-email-riel@redhat.com>
	<1398794796-17464-3-git-send-email-riel@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 14:06:36 -0400 riel@redhat.com wrote:

> From: Rik van Riel <riel@redhat.com>
> 
> Some sysrq handlers can run for a long time, because they dump a lot
> of data onto a serial console. Having RCU stall warnings pop up in
> the middle of them only makes the problem worse.
> 
> This patch temporarily disables RCU stall warnings while a sysrq
> request is handled.
>
> ...
>
>  drivers/tty/sysrq.c      |  3 +++
>  include/linux/rcupdate.h | 12 ++++++++++++
>  kernel/rcu/update.c      | 12 ++++++++++++

OK, what's going on here.  Someone (of, I suspect, a Paulish nature)
has plucked out the rcu parts of this patch, put them in linux-next and
omitted the drivers/tty part.  Very tricky!


I have done the opposite and have staged two patches against linux-next:

http://ozlabs.org/~akpm/mmots/broken-out/sysrq-rcu-ify-__handle_sysrq.patch
http://ozlabs.org/~akpm/mmots/broken-out/sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch

Please check, review, comment, etc.
