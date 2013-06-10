Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab3FJRXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:23:52 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:2880 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3FJRXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:23:51 -0400
Message-ID: <1370885029.1795.7.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc: don't allocate with GFP_KERNEL inside rcu read lock
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: akpm@linux-foundation.org, riel@redhat.com, walken@google.com,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
Date: Mon, 10 Jun 2013 10:23:49 -0700
In-Reply-To: <1370880870-23833-1-git-send-email-sasha.levin@oracle.com>
References: <1370880870-23833-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-10 at 12:14 -0400, Sasha Levin wrote:
> ipc_addid() is protected by a rcu read lock, which means we can't allocate
> using GFP_KERNEL inside it.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
> 
> Another option would be to call idr_preload from outside the read lock,
> but that complicates the code much more than this fix. If that's the
> preferred method to fix it I can resend that solution instead.
> 

This issue was reported last week by Fengguang
(http://www.spinics.net/lists/kernel/msg1545633.html#.UbYI9qqdmV8)

Your fix looks the simplest approach, but I'm not sure if doing the
atomic allocation would trigger some other problem, as a side effect.
Andrew?

A third option would be to simply revert the offending commit, leaving
the rcu locking as it originally was.

Thanks,
Davidlohr

