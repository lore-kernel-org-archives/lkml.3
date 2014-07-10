Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaGJJyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:54:01 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:41380 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbaGJJxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:53:32 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [PATCH] drbd: fix regression 'out of mem, failed to invoke fence-peer helper'
Date: Thu, 10 Jul 2014 11:53:29 +0200
Message-ID: <2397073.C8BSPuutsL@fat-tyre>
User-Agent: KMail/4.13.2 (Linux/3.13.0-24-lowlatency; KDE/4.13.2; x86_64; ; )
In-Reply-To: <53BE57CA.9020807@kernel.dk>
References: <1404933512-5166-1-git-send-email-philipp.reisner@linbit.com> <1404933512-5166-2-git-send-email-philipp.reisner@linbit.com> <53BE57CA.9020807@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 10. Juli 2014, 11:07:22 schrieb Jens Axboe:
> On 2014-07-09 21:18, Philipp Reisner wrote:
> > From: Lars Ellenberg <lars.ellenberg@linbit.com>
> > 
> > Since linux kernel 3.13, kthread_run() internally uses
> > wait_for_completion_killable().  We sometimes may use kthread_run()
> > while we still have a signal pending, which we used to kick our threads
> > out of potentially blocking network functions, causing kthread_run() to
> > mistake that as a new fatal signal and fail.
> > 
> > Fix: flush_signals() before kthread_run().
> 
> Applied - should this have been marked stable, if it affects 3..13+ kernels?

Yes, you are right. It should go to the stable kernels since 3.13 as
well.

What is the correct way for me to mark it as stable when sending a patch?

-phil

