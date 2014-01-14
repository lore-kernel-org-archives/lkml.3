Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaANMwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:52:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59766 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaANMwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:52:14 -0500
Date: Tue, 14 Jan 2014 13:51:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the tip
 tree
Message-ID: <20140114125153.GY7572@laptop.programming.kicks-ass.net>
References: <20140114155331.88d170d3c991b9465c23a537@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114155331.88d170d3c991b9465c23a537@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 03:53:31PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm-current tree got a conflict in
> kernel/futex.c between commit a52b89ebb6d4 ("futexes: Increase hash table
> size for better performance") from the tip tree and commit 61beee6c76e5
> ("futex: switch to USER_DS for futex test") from the akpm-current tree.
> 
> @@@ -2869,10 -2748,13 +2871,13 @@@
>   	 * implementation, the non-functional ones will return
>   	 * -ENOSYS.
>   	 */
> + 	fs = get_fs();
> + 	set_fs(USER_DS);
>   	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
>   		futex_cmpxchg_enabled = 1;
> + 	set_fs(fs);
>   

This seems terribly broken, the *futex_value*() ops should not need
that; they are supposed to access userspace without any of that.
